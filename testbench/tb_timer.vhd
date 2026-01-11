library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


library vunit_lib;
context vunit_lib.vunit_context;

library design_lib;

entity tb_timer is
  generic (
    runner_cfg : string;
    tb_clk_freq_g : natural := 10;
    tb_delay_g    : natural := 1000
  );
end entity;

architecture tb of tb_timer is
  signal clk, reset_n, done, start : std_logic := '0';

  constant clk_period_c            : time := (1_000_000_000 / tb_clk_freq_g) * 1 ns;
  signal clk_freq_hz_g_in          : natural := tb_clk_freq_g;

  constant tb_delay_ns_c           : real := real(tb_delay_g) * 1_000_000.0;
  constant tb_cycles_real_c        : real := tb_delay_ns_c * real(tb_clk_freq_g) / 1_000_000_000.0;
  constant tb_max_count_c   : natural := natural(ceil(tb_cycles_real_c));

  constant delay_c                 : time := tb_max_count_c * clk_period_c;

begin
  dut: entity design_lib.timer(rtl)
    generic map(
      clk_freq_hz_g => clk_freq_hz_g_in,
      delay_g       => delay_c
    )
    port map (
      clk_i     => clk,
      arst_i    => reset_n,
      start_i   => start,
      done_o    => done
    );

  clk <= not clk after clk_period_c / 2;
  
  main: process
  variable count : natural := 0;
  begin
    test_runner_setup(runner, runner_cfg);  
    while test_suite loop
      if run("test_timer_basic") then
        count := 0;
        
        reset_n <= '1'; wait for 2 * clk_period_c;  
        reset_n <= '0'; wait for clk_period_c;
        check_equal(done, '1', "1. idle: done=1");
        
        start <= '1'; wait for clk_period_c;
        start <= '0';
        check_equal(done, '0', "2. start: counting begins");

        while done = '0' loop
          wait until rising_edge(clk);
          count := count + 1;
          if count > tb_max_count_c + 2 then
            check_false(true, "timeout: never completes");
            exit;
          end if;
        end loop;

        wait until rising_edge(clk);
        wait until rising_edge(clk);      

        start <= '1'; wait for clk_period_c;
        start <= '0';
        
        wait for (tb_max_count_c / 2) * clk_period_c;

        start <= '1'; wait for clk_period_c;
        start <= '0';

        wait for (tb_max_count_c / 2 + 1) * clk_period_c;
        check_equal(done, '1', "5. busy: ignores start pulse, ends at expected time");
        
      end if;
    end loop;

    test_runner_cleanup(runner);  
  end process;

end architecture;