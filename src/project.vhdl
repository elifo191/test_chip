library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ps2_reciever is
    port (
        clk     :   in  std_logic;
        d_in    :   in  std_logic;
        d_out   :   out std_logic_vector(10 downto 0)
    );
end ps2_reciever;

architecture Behavioral of tt_um_example is
begin

    --uo_out <= std_logic_vector(unsigned(ui_in) + unsigned(uio_in));
    uo_out <= not (ui_in and uio_in);
    uio_out <= "00000000";
    uio_oe <= "00000000";

end Behavioral;