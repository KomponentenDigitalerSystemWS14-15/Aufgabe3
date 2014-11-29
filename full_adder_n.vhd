LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY full_adder_n IS
    GENERIC(N: natural := 8);                       -- length of full adder
    PORT(cin:   IN std_logic;                       -- carry input
         op1:   IN std_logic_vector(N-1 DOWNTO 0);  -- operand 1
         op2:   IN std_logic_vector(N-1 DOWNTO 0);  -- operand 2
         sum:   OUT std_logic_vector(N-1 DOWNTO 0); -- resulting sum
         cout:  OUT std_logic);                     -- carry output
END full_adder_n;

ARCHITECTURE behavioral OF full_adder_n IS
    COMPONENT full_adder IS
    PORT(cin:   IN std_logic;   -- carry input
         op1:   IN std_logic;   -- 1. operand
         op2:   IN std_logic;   -- 2. operand
         sum:   OUT std_logic;  -- result
         cout:  OUT std_logic); -- carry output
    END COMPONENT;
    
    SIGNAL carry: std_logic_vector(N DOWNTO 0);
BEGIN
    carry(0) <= cin;
    e1: FOR i IN 0 to N-1 GENERATE
        u1: full_adder
        PORT MAP(
            cin => carry(i),
            op1 => op1(i),
            op2 => op2(i),
            sum => sum(i),
            cout => carry(i+1));
    END GENERATE;
    
    cout <= carry(N);
    
END behavioral;