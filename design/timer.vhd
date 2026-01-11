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
  type state_t is (IDLE, COUNTING);
  signal state : state_t := IDLE;
  
  constant delay_fs_c     : real := real(delay_g / 1 fs);
  constant freq_real_c    : real := real(clk_freq_hz_g);
  constant cycles_real_c  : real := freq_real_c * delay_fs_c * 1.0e-15;
  constant max_count_c       : natural := natural(ceil(cycles_real_c));

  
  
  signal count :  unsigned(31 DOWNTO 0) := (OTHERS => '0');
  signal period_ns_c  : natural := 1_000_000_000 / clk_freq_hz_g;
begin
  main: process(clk_i, arst_i)
  begin
    if arst_i = '1' then
      count    <= (OTHERS => '0');
      done_o   <= '1';
      state <= IDLE;
    elsif rising_edge(clk_i) then
      case state is
        when IDLE =>
          done_o <= '1';
          if start_i = '1' then
            if max_count_c > 0 then
              count   <= to_unsigned(max_count_c - 1, count'length);
              state <= COUNTING;
              done_o  <= '0';
            end if;
          end if;
        when COUNTING =>
          if count = 0 then
            state <= IDLE;
            done_o  <= '1';
          else
            count <= count - 1;
            done_o <= '0';
          end if;
      end case;
    end if;
  end process;
end architecture;