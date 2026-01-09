library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

library design_lib;

entity tb_timer is
  generic (runner_cfg : string);
end entity;

architecture tb of tb_timer is
  signal clk, reset_n, done : std_logic := '0';
  signal start : std_logic := '0';
  constant clk_freq_hz_c : natural := 10;
  constant clk_period_c  : time    := (1_000_000_000 / clk_freq_hz_c) * 1 ns;

begin
  dut: entity design_lib.timer(rtl)
    generic map(
      clk_freq_hz_g => 10,
      delay_g       => 1000 ms
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
        
        wait until done = '1';
        check_equal(done, '1', "done should assert after delay");  
        
      end if;
    end loop;

    test_runner_cleanup(runner);  
  end process;

end architecture;
