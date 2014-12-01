LIBRARY ieee;
LIBRARY unisim;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE unisim.vcomponents.ALL;

ENTITY multiplier_16x16 IS
    PORT(op1:   IN std_logic_vector(15 DOWNTO 0);       -- 1. operand
         op2:   IN std_logic_vector(15 DOWNTO 0);       -- 2. operand
         prod:  OUT std_logic_vector(35 DOWNTO 0));     -- resulting product
END multiplier_16x16;

ARCHITECTURE behavioral OF multiplier_16x16 IS

    COMPONENT MULT18X18
    PORT(P: OUT std_logic_vector (35 DOWNTO 0);
         A: IN std_logic_vector (17 DOWNTO 0);
         B: IN std_logic_vector (17 DOWNTO 0));
    END COMPONENT;
    
    SIGNAL op1_tmp: std_logic_vector(17 DOWNTO 0);
    SIGNAL op2_tmp: std_logic_vector(17 DOWNTO 0);
BEGIN
    op1_tmp <= std_logic_vector(resize(signed(op1), 18));
    op2_tmp <= std_logic_vector(resize(signed(op2), 18));

    mul1: MULT18X18
    PORT MAP(P => prod,
             A => op1_tmp,
             B => op2_tmp);

END behavioral;