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
  signal period_ns_c  : natural := 1_000_000_000 / clk_freq_hz_g;
  signal max_count_c  : natural := natural(real(delay_g / 1 ns) / real(period_ns_c));
begin
  counting: process(clk_i, arst_i)
  begin
    if arst_i = '1' then
      count    <= (OTHERS => '0');
      done_o   <= '1';
    elsif rising_edge(clk_i) then
      if done_o = '1' and start_i = '1' then  
        count  <= to_unsigned(0, count'length);  
        done_o <= '0';                           
      elsif done_o = '0' then  
        if count = max_count_c - 1 then
          count  <= (others => '0');
          done_o <= '1';  
        else
          count <= count + 1;
        end if;
      end if;  
    end if;
  end process;
end architecture;
