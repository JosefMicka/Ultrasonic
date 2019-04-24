library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity meas is
	port(
		-- Inputs
		start_meas_i : in std_logic;	--start measurement when '1'
		pin_meas_i : in std_logic;		--ultrasonic sensor output
		reset_i : in std_logic;				--reset active '0'
		clk_i : in std_logic;

		-- Output
		distance_bcd_o : out std_logic_vector(16-1 downto 0);
		pin_pulse_o : out std_logic		--ultrasonic sensor input - trigger pulse (10 us)
	);
end meas;

architecture Behavioral of meas is
	signal s_show : std_logic;
  signal s_rst : std_logic;
  signal s_tmr0_r, s_tmr1_r : std_logic;
	signal s_tmr0_en, s_tmr1_en : std_logic;
  signal s_bcd_cnt : std_logic;
	signal s_reg, s_dist_bcd : std_logic_vector(16-1 downto 0);
begin

	--control timer0
	s_tmr0_en <= '1' when (start_meas_i = '1' and s_tmr1_r = '0') else s_tmr0_r;
	--control timer1
	s_tmr1_en <= '1' when (start_meas_i = '1' and s_tmr1_r = '0') else s_tmr1_r;

	s_rst <= not s_tmr0_r;
	--output pin
	pin_pulse_o <= s_tmr0_r;

	--output measured time
	distance_bcd_o <= s_dist_bcd;

	--D-latch
	s_dist_bcd <= s_reg when s_show = '1' else s_dist_bcd;

	s_show <= not pin_meas_i;


	-- pulse 10 us
  TIMER0 : entity work.timer2
		generic map(
			COUNT_TOP => 10,
			N_BIT => 4
		)
    port map(
      clk_i => clk_i,
      en_i => s_tmr0_en,
			reset_i => reset_i,
			timer_running_o => s_tmr0_r
    );

  -- delay 60 ms between two measurements
  TIMER1 : entity work.timer2
    generic map(
      COUNT_TOP => 60000,
			N_BIT => 16
    )
    port map(
      clk_i => clk_i,
      en_i => s_tmr1_en,
			reset_i => reset_i,
      timer_running_o => s_tmr1_r
    );

		--division by 6
		DIVIDESIX : entity work.up_to_six
		port map(
				clk_i => clk_i,
				rst_n_i => pin_meas_i,
				carry_n_o => s_bcd_cnt
		);

		DISTANCEBCD : entity work.four_bcd_cnts
		port map(
		  clk_i => s_bcd_cnt,
		  rst_i => s_rst,
		  bcd_o => s_reg
		);



end Behavioral;
