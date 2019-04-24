--------------------------------------------------------------------------------
-- Brno University of Technology, Department of Radio Electronics
--------------------------------------------------------------------------------
-- Author: Tomas Fryza (tomas.fryza@vut.cz)
-- Date: 2019-02-28 10:20
-- Design: bcd_cnt
-- Description: BCD counter with synchronous reset and carry output.
--------------------------------------------------------------------------------
-- TODO: Verify functionality of Up BCD counter and extend it to Up Down BCD
--       counter.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;    -- for +/- arithmetic operations

--------------------------------------------------------------------------------
-- Entity declaration for BCD counter
--------------------------------------------------------------------------------
entity bcd_cnt is
    port (
        -- Entity input signals
        clk_i   : in std_logic;
        rst_n_i : in std_logic;     -- reset =0: reset active
                                    --       =1: no reset
        -- Entity output signals
        carry_n_o : out std_logic;  -- carry =0: carry active
                                    --       =1: no carry
        bcd_cnt_o : out std_logic_vector(4-1 downto 0)
    );
end bcd_cnt;

--------------------------------------------------------------------------------
-- Architecture declaration for BCD counter
--------------------------------------------------------------------------------
architecture Behavioral of bcd_cnt is
    signal s_reg  : std_logic_vector(4-1 downto 0);
    signal s_next : std_logic_vector(4-1 downto 0);
begin
    --------------------------------------------------------------------------------
    -- Register
    --------------------------------------------------------------------------------
    p_bcd_cnt: process(clk_i, rst_n_i)
    begin
        if rst_n_i = '0' then           -- asynchronous reset
          s_reg <= (others => '0');   -- clear all bits in register
        elsif rising_edge(clk_i) then
                s_reg <= s_next;            -- update register value
        end if;
    end process p_bcd_cnt;

    --------------------------------------------------------------------------------
    -- Next-state logic
    --------------------------------------------------------------------------------
    -- Up counter only
    s_next <= "0000" when s_reg = "1001" else   -- up
              s_reg + 1;

    --------------------------------------------------------------------------------
    -- Output logic
    --------------------------------------------------------------------------------
    bcd_cnt_o <= s_reg;
    -- Up counter only
    carry_n_o <= '0' when s_reg = "1001" else   -- up
                 '1';
end Behavioral;
