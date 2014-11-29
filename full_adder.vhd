LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY full_adder IS
    PORT(cin:   IN std_logic;   -- carry input
         op1:   IN std_logic;   -- 1. operand
         op2:   IN std_logic;   -- 2. operand
         sum:   OUT std_logic;  -- result
         cout:  OUT std_logic); -- carry output
END full_adder;

ARCHITECTURE behavioral OF full_adder IS
    SIGNAL sel: std_logic_vector(1 TO 3);
    SIGNAL tmp: std_logic_vector(1 TO 2);
BEGIN
    sel <= cin & op1 & op2;
    WITH sel SELECT
        tmp <= "00" WHEN "000",
               "01" WHEN "001",
               "01" WHEN "010",
               "10" WHEN "011",
               "01" WHEN "100",
               "10" WHEN "101",
               "10" WHEN "110",
               "11" WHEN "111",
               "--" WHEN OTHERS;

    sum <= tmp(2);
    cout <= tmp(1);
END behavioral;