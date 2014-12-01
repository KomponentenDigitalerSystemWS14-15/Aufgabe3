LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY accumulator IS
    GENERIC(N: NATURAL := 8;
            RSTDEF: std_logic := '0');
    PORT(rst:   IN std_logic;                           -- reset, RSTDEF active
         clk:   IN std_logic;                           -- clock, rising edge
         swrst: IN std_logic;                           -- software reset, RSTDEF active
         en:    IN std_logic;                           -- enable, high active
         cin:   IN std_logic;                           -- carry input
         op:    IN std_logic_vector(N-1 DOWNTO 0);      -- operand
         sum:   OUT std_logic_vector(N-1 DOWNTO 0);     -- result
         cout:  OUT std_logic);                         -- carry output
END accumulator;

ARCHITECTURE behavioral OF accumulator IS
    COMPONENT full_adder_n IS
    GENERIC(N: natural);                            -- length of full adder
    PORT(cin:   IN std_logic;                       -- carry input
         op1:   IN std_logic_vector(N-1 DOWNTO 0);  -- operand 1
         op2:   IN std_logic_vector(N-1 DOWNTO 0);  -- operand 2
         sum:   OUT std_logic_vector(N-1 DOWNTO 0); -- resulting sum
         cout:  OUT std_logic);                     -- carry output
    END COMPONENT;
    
    SIGNAL tmp_sum: std_logic_vector(N-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL adder_sum: std_logic_vector(N-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL adder_cout: std_logic := 0;
BEGIN

    add1: full_adder_n
    PORT GENERIC(N => N)
    PORT MAP(cin => cin,
             op1 => tmp_sum,
             op2 => op,
             sum => adder_sum,
             cout => adder_cout);

    sum <= tmp_sum;
        
    PROCESS(rst, clk)
    BEGIN
        IF rst = RSTDEF THEN
            tmp_sum <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF en = '1' THEN
                -- only apply new value when enabled
                tmp_sum <= adder_sum;
                cout <= adder_cout;
            END IF;
        END IF;
    END PROCESS;


END behavioral;