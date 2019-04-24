library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity timer2 is
  generic(
    COUNT_TOP : integer := 255;
    N_BIT : integer := 8
  );
  port(
    clk_i : in std_logic;
    en_i : in std_logic;    -- 1 - timer running
    reset_i : in std_logic; -- 0 - reset active

    timer_running_o : out std_logic
  );
end timer2;

architecture Behavioral of timer2 is
  signal s_cnt : std_logic_vector(N_BIT-1 downto 0) := (others => '0');
  signal s_reset : std_logic;
begin

  s_reset <=  '0' when reset_i = '0' else
              '0' when s_cnt = COUNT_TOP else
              '1';

  timer_running_o <= '0' when s_reset = '0' else
                      en_i;

  p_run : process(clk_i)
	begin
    if rising_edge(clk_i) then
      if s_reset = '0' then
        s_cnt <= (others => '0');
      elsif en_i = '1' then
					s_cnt <= s_cnt + '1';
			end if;
    end if;
	end process;

end Behavioral;
