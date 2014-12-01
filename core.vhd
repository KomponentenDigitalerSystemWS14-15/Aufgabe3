LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY core IS
   GENERIC(RSTDEF: std_logic := '0');
   PORT(rst:   IN  std_logic;                      -- reset,          RSTDEF active
        clk:   IN  std_logic;                      -- clock,          rising edge
        swrst: IN  std_logic;                      -- software reset, RSTDEF active
        strt:  IN  std_logic;                      -- start,          high active
        sw:    IN  std_logic_vector( 7 DOWNTO 0);  -- length counter, input
        res:   OUT std_logic_vector(43 DOWNTO 0);  -- result
        done:  OUT std_logic);                     -- done,           high active
END core;

ARCHITECTURE behavioral OF core IS
    
    COMPONENT ram_block IS
    PORT (addra: IN std_logic_VECTOR(9 DOWNTO 0); -- addressbus port a, selects memory cell for read/write
          addrb: IN std_logic_VECTOR(9 DOWNTO 0); -- addressbus port b, selects memory cell for read/write
          clka:  IN std_logic;
          clkb:  IN std_logic;
          douta: OUT std_logic_VECTOR(15 DOWNTO 0); -- data out bus port a
          doutb: OUT std_logic_VECTOR(15 DOWNTO 0); -- data out bus port b
          ena:   IN std_logic;
          enb:   IN std_logic);
    END COMPONENT;
    
    COMPONENT multiplier_16x16 IS
    PORT(op1:   IN std_logic_vector(15 DOWNTO 0);       -- 1. operand
         op2:   IN std_logic_vector(15 DOWNTO 0);       -- 2. operand
         prod:  OUT std_logic_vector(35 DOWNTO 0));     -- resulting product
    END COMPONENT;
    
    COMPONENT accumulator IS
    GENERIC(N: natural;
            RSTDEF: std_logic);
    PORT(rst:   IN std_logic;                           -- reset, RSTDEF active
         clk:   IN std_logic;                           -- clock, rising edge
         swrst: IN std_logic;                           -- software reset, RSTDEF active
         en:    IN std_logic;                           -- enable, high active
         cin:   IN std_logic;                           -- carry input
         op:    IN std_logic_vector(N-1 DOWNTO 0);      -- operand
         sum:   OUT std_logic_vector(N-1 DOWNTO 0);     -- result
         cout:  OUT std_logic);
    END COMPONENT;
    
    CONSTANT ACC_LEN: natural := 44;
    
    SIGNAL vala: std_logic_vector(15 DOWNTO 0);
    SIGNAL valb: std_logic_vector(15 DOWNTO 0);
    SIGNAL prod: std_logic_vector(35 DOWNTO 0);
    SIGNAL prod_padded: std_logic_vector(ACC_LEN-1 DOWNTO 0);
    
    SIGNAL addr_offset: std_logic_vector(7 DOWNTO 0);
    SIGNAL addra: std_logic_vector(9 DOWNTO 0);
    SIGNAL addrb: std_logic_vector(9 DOWNTO 0);
    
    SIGNAL en_ram: std_logic := '0';
    SIGNAL en_acc: std_logic := '0';
    SIGNAL run: std_logic := '0';
    
    SIGNAL l_done: std_logic := '0';
    SIGNAL swrst_acc: std_logic := '0';
BEGIN
    addra <= "00" & addr_offset;
    addrb <= "01" & addr_offset;

    rb1: ram_block
    PORT MAP(addra => addra,
             addrb => addrb,
             clka => clk,
             clkb => clk,
             douta => vala,
             doutb => valb,
             ena => en_ram,
             enb => en_ram);
             
    mul1: multiplier_16x16
    PORT MAP(op1 => vala,
             op2 => valb,
             prod => prod);
    
    -- pad product with zeros or ones
    prod_padded <= std_logic_vector(resize(signed(prod), ACC_LEN));
    
    acc1: accumulator
    GENERIC MAP(N => ACC_LEN,
                RSTDEF => RSTDEF)
    PORT MAP(rst => rst,
             clk => clk,
             swrst => swrst_acc,
             en => en_acc,
             cin => '0',
             op => prod_padded,
             sum => res,
             cout => OPEN);
    
    done <= l_done;
    swrst_acc <= swrst WHEN swrst = RSTDEF ELSE swrst_acc;
    
    PROCESS(rst, clk)
    BEGIN
        IF rst = RSTDEF THEN
            l_done <= '0';
            addr_offset <= (OTHERS => '0');
            en_acc <= '0';
            en_ram <= '0';
            run <= '0';
        ELSIF rising_edge(clk) THEN
            IF swrst = RSTDEF THEN
                l_done <= '0';
                addr_offset <= (OTHERS => '0');
                en_acc <= '0';
                en_ram <= '0';
                run <= '0';
            ELSE
                l_done <= '0';
                swrst_acc <= NOT RSTDEF;
                en_acc <= '0';
                
                IF run = '0' THEN
                    IF strt = '1' THEN
                        run <= '1';
                        swrst_acc <= RSTDEF;
                        IF sw /= "00000000" THEN
                            addr_offset <= sw - 1;
                            en_ram <= '1';
                        END IF;
                    END IF;
                ELSE
                    IF swrst_acc /= RSTDEF THEN
                        IF en_ram = '1' THEN
                            en_acc <= '1';
                            IF addr_offset = "00000000" THEN
                                en_ram <= '0';
                            ELSE
                                addr_offset <= addr_offset - 1;
                            END IF;
                        ELSE
                            IF strt = '0' THEN
                                run <= '0';
                                l_done <= '1';
                            END IF;
                        END IF;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;

END behavioral;
