library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real .all ;

entity timer is
  generic (
    clk_freq_hz_g : natural ; -- Clock frequency in Hz
    delay_g : time -- Delay duration , e.g. , 100 ms
  );
  port (
    clk_i : in std_ulogic ;
    arst_i : in std_ulogic ;
    start_i : in std_ulogic ; -- No effect if not done_o
    done_o : out std_ulogic -- ’1 ’ when not counting (" not busy ")
  );
end entity timer ;

architecture rtl of timer is
  signal count :  unsigned(10 DOWNTO 0) := (OTHERS => '0');
begin
  count: process(clk_i, arst_i)
  begin
    if arst_i = '1' then
      count    <= (OTHERS => '0');
      done_o   <= '0';
    elsif rising_edge(clk_i) then
      if count = max_count-1 then
        count <= (OTHERS => '0');
      else
        count <= count + 1;
      end if;
    end if;
  end process;
end architecture;
