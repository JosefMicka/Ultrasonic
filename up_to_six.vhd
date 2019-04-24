library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity up_to_six is
    port (
        -- Entity input signals
        clk_i   : in std_logic;
        rst_n_i : in std_logic;     -- reset =0: reset active
        -- Entity output signals
        carry_n_o : out std_logic  -- carry =0: carry active
                                    --       =1: no carry
      --  up_to_six_o : out std_logic_vector(4-1 downto 0)
    );
end up_to_six;

architecture Behavioral of up_to_six is
    signal s_reg  : std_logic_vector(3-1 downto 0);
    signal s_next : std_logic_vector(3-1 downto 0);
begin
    p_up_to_six: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_n_i = '0' then           -- synchronous reset
                s_reg <= (others => '0');   -- clear all bits in register
            else
                s_reg <= s_next;            -- update register value
            end if;
        end if;
    end process p_up_to_six;

    --------------------------------------------------------------------------------
    -- Next-state logic
    --------------------------------------------------------------------------------
    -- Up counter only
    s_next <= "000" when s_reg = "101" else   -- up
              s_reg + 1;

    --------------------------------------------------------------------------------
    -- Output logic
    --------------------------------------------------------------------------------
    --up_to_six_o <= s_reg;
    -- Up counter only
    carry_n_o <= '0' when s_reg = "101" else   -- up
                 '1';
end Behavioral;
