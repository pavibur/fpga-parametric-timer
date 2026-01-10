library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

library design_lib;

entity tb_timer is
  generic (
    runner_cfg : string;
    tb_clk_freq_g : natural := 10;
    tb_delay_g : natural := 1000 
    );
  
end entity;

architecture tb of tb_timer is
  signal clk, reset_n, done : std_logic := '0';
  signal start : std_logic := '0';
  constant clk_period_c  : time    := (1_000_000_000 / tb_clk_freq_g) * 1 ns;
  signal clk_freq_hz_g_in : natural := tb_clk_freq_g;
  signal delay_g_in : time := tb_delay_g * 1 ms;

begin
  dut: entity design_lib.timer(rtl)
    generic map(
      clk_freq_hz_g => clk_freq_hz_g_in,
      delay_g       => delay_g_in
    )
    port map (
      clk_i     => clk,
      arst_i    => reset_n,
      start_i   => start,
      done_o    => done
    );

  clk <= not clk after clk_period_c / 2;
  
  main: process
  begin
    test_runner_setup(runner, runner_cfg);  
    while test_suite loop
      if run("test_timer_basic") then
        
        reset_n <= '1'; wait for 2 * clk_period_c;  
        reset_n <= '0'; wait for clk_period_c / 4;
        
        start <= '1'; wait for clk_period_c;
        start <= '0';
        
        wait for delay_g_in - 100 ms;
        check_equal(done, '0', "done should be 0 before delay");  
        wait for delay_g_in;
        check_equal(done, '1', "done should assert after delay");  
        
      end if;
    end loop;

    test_runner_cleanup(runner);  
  end process;

end architecture;
