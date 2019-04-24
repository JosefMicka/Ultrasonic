library ieee;
use ieee.std_logic_1164.all;


entity top is
    port (
        --Inputs
        btn_start_i : in std_logic; --start when '1', not used
        btn_rst_i : in std_logic;   --reset active '0'
        pin_meas_i : in std_logic;  --ultrasonic sensor output
        clk_i : in std_logic;

        pin_trigger_o : out std_logic;  --pulse 10 us
        disp_digit_o : out std_logic_vector(4-1 downto 0);  -- multiplex
        disp_sseg_o  : out std_logic_vector(7-1 downto 0)   --7-segment
    );
end top;

--------------------------------------------------------------------------------
-- Architecture declaration for top level
--------------------------------------------------------------------------------
architecture Behavioral of top is
  constant TIME_US_MAX : integer := 25000;
  signal s_time_us : integer range 0 to TIME_US_MAX;
  signal s_dist_bcd : std_logic_vector(16-1 downto 0);
begin

  MEAS : entity work.meas
  	port map(
  		-- Inputs
  		start_meas_i => '1',
      pin_meas_i => pin_meas_i,
      reset_i => btn_rst_i,
  		clk_i => clk_i,
  		-- Outputs
      distance_bcd_o => s_dist_bcd,
      pin_pulse_o => pin_trigger_o
  	);

	DISPMUX : entity work.disp_mux
    port map(
        -- Entity input signals
        data3_i => s_dist_bcd(16-1 downto 12),
        data2_i => s_dist_bcd(12-1 downto 8),
        data1_i => s_dist_bcd(8-1 downto 4),
        data0_i => s_dist_bcd(4-1 downto 0),
        clk_i  => clk_i,
        -- Entity output signals
        an_o   => disp_digit_o,    -- 1-of-4 decoder
        sseg_o => disp_sseg_o     -- 7-segment display
    );
end Behavioral;
