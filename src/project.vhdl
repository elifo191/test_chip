library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ps2_receiver is
    Port (
        clk     : in  std_logic;                       -- System clk
        rst     : in  std_logic;                       -- Reset
        ps2c    : in  std_logic;                       -- PS/2 clock
        ps2_d   : in  std_logic;                       -- PS/2 data
        d_out   : out std_logic_vector(7 downto 0)     -- Output
    );
end ps2_receiver;

architecture Behavioral of ps2_receiver is

    type statetype is (idle, receiving, load);  -- States
    signal state_reg, state_next : statetype;   

    signal b_reg : std_logic_vector(10 downto 0) := (others => '0'); -- Data to be processed
    signal count : integer range 0 to 10 := 0;  -- Counter

    signal ps2c_sync    : std_logic_vector(2 downto 0) := (others => '1');  -- Synced PS/2 clk
    signal ps2c_falling : std_logic := '0';

    signal data_ready : std_logic := '0';   -- 0 / Not ready     1 / Ready
    signal d_out_reg  : std_logic_vector(7 downto 0) := (others => '0'); -- Output register

begin

    -- Sync PS/2 clk and 
    process(clk)
    begin
        if rising_edge(clk) then
            ps2c_sync <= ps2c_sync(1 downto 0) & ps2c;
            if ps2c_sync(2 downto 1) = "10" then
                ps2c_falling <= '1'
            else
                ps2c_falling <= '0'
            end if;
        end if;
    end process;


    process(clk, rst)
    begin
        if rst = '1' then
            state_reg <= idle;
            b_reg <= (others => '0');
            count <= 0;
            d_out_reg <= (others => '0');
        elsif rising_edge(clk) then
            case state_reg is

                when idle =>
                    if ps2c_falling = '1' then
                        count <= 0;
                        state_reg <= receiving;
                    end if;

                when receiving =>
                    if ps2c_falling = '1' then
                        b_reg(count) <= ps2_d;
                        if count = 10 then
                            state_reg <= load;
                        else
                            count <= count + 1;
                        end if;
                    end if;

                when load =>
                    d_out_reg <= b_reg(8 downto 1);  -- Extract only data bits
                    state_reg <= idle;
            end case;
        end if;
    end process;

    d_out <= d_out_reg;

end Behavioral;