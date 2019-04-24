library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity four_bcd_cnts is
port(
  clk_i : in std_logic;
  rst_i : in std_logic;

  bcd_o : out std_logic_vector(16-1 downto 0)
);
end four_bcd_cnts;


architecture Behavioral of four_bcd_cnts is
signal s_c0, s_c1, s_c2 : std_logic := '0';
signal s_bcd : std_logic_vector(16-1 downto 0);

begin

  bcd_o <= s_bcd;

  BCD0 : entity work.bcd_cnt
  port map(
      clk_i   => clk_i,
      rst_n_i => rst_i,
      carry_n_o => s_c0,
      bcd_cnt_o => s_bcd(3 downto 0)
  );

  BCD1 : entity work.bcd_cnt
  port map(
      clk_i   => s_c0,
      rst_n_i => rst_i,
      carry_n_o => s_c1,
      bcd_cnt_o => s_bcd(7 downto 4)
  );

  BCD2 : entity work.bcd_cnt
  port map(
      clk_i   => s_c1,
      rst_n_i => rst_i,
      carry_n_o => s_c2,
      bcd_cnt_o => s_bcd(11 downto 8)
  );

  BCD3 : entity work.bcd_cnt
  port map(
      clk_i   => s_c2,
      rst_n_i => rst_i,
      --carry_n_o => ,
      bcd_cnt_o => s_bcd(15 downto 12)
  );

end Behavioral;
