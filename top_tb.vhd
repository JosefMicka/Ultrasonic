library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_tb is
end top_tb;

architecture test of top_tb is

  component top
  port (
      --Inputs
      btn_start_i : in std_logic;
      btn_rst_i : in std_logic;
      pin_meas_i : in std_logic;  --ultrasonic sensor output
      clk_i : in std_logic;

      pin_trigger_o : out std_logic;
      disp_digit_o : out std_logic_vector(4-1 downto 0);  -- 7-segment
      disp_sseg_o  : out std_logic_vector(7-1 downto 0)
  );
end component;

for all: top use entity work.top(Behavioral);

constant CLK_PER : time := 1 us;
signal s_pin_trg : std_logic := '0';
signal s_rst : std_logic := '1';
signal s_clk, s_btn_start, s_pin_meas : std_logic := '0';
signal s_disp_digit : std_logic_vector(4-1 downto 0);
signal s_disp_sseg : std_logic_vector(7-1 downto 0);

begin
	uut : top
  port map(
    btn_start_i => s_btn_start,
    btn_rst_i => s_rst,
    pin_meas_i => s_pin_meas,  --ultrasonic sensor output
    clk_i => s_clk,

    pin_trigger_o => s_pin_trg,
    disp_digit_o => s_disp_digit,  -- 7-segment
    disp_sseg_o => s_disp_sseg
  );

  p_clk_i : process
  begin
    s_clk <= '0';
    wait for CLK_PER/2;
    s_clk <= '1';
    wait for CLK_PER/2;
  end process;


  p_count : process
  begin
    s_rst <= '0';
    wait for 10 us;
    s_rst <= '1';
    wait until falling_edge(s_pin_trg);
    wait for 10 us;
    s_pin_meas <= '1';
    wait for 600 us;
    s_pin_meas <= '0';
    wait;
  end process;

end test;
