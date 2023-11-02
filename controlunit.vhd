LIBRARY IEEE;
USE IEEE.numeric_bit.ALL;

ENTITY controlunit IS
    PORT (
        --To Datapath
        reg2loc : OUT BIT;
        uncondBranch : OUT BIT;
        branch : OUT BIT;
        memRead : OUT BIT;
        memToReg : OUT BIT;
        aluOp : OUT bit_vector(1 DOWNTO 0);
        memWrite : OUT BIT;
        aluSrc : OUT BIT;
        regWrite : OUT BIT;
        -- From Datapath
        opcode : IN bit_vector(10 DOWNTO 0)
    );
END ENTITY controlunit;

ARCHITECTURE controlunit_arc OF controlunit IS
BEGIN
    reg2loc <= '0' WHEN opcode = "10001011000" ELSE
        '0' WHEN opcode = "11001011000" ELSE
        '0' WHEN opcode = "10001010000" ELSE
        '0' WHEN opcode = "10101010000" ELSE
        '1';
    branch <= '0' WHEN opcode = "10001011000" ELSE
        '0' WHEN opcode = "11001011000" ELSE
        '0' WHEN opcode = "10001010000" ELSE
        '0' WHEN opcode = "10101010000" ELSE
        '0' WHEN opcode = "11111000010" ELSE
        '0' WHEN opcode = "11111000000" ELSE
        '1';
    memRead <= '1' WHEN opcode = "11111000010" ELSE
        '0';
    memToReg <= '1' WHEN opcode = "11111000010" ELSE
        '0';
    aluOp <= "00" WHEN opcode = "11111000010" ELSE
        "00" WHEN opcode = "11111000000" ELSE
        "10" WHEN opcode = "10001011000" ELSE
        "10" WHEN opcode = "11001011000" ELSE
        "10" WHEN opcode = "10001010000" ELSE
        "10" WHEN opcode = "10101010000" ELSE
        "01";
    memWrite <= '1' WHEN opcode = "11111000000" ELSE
        '0';
    alusrc <= '1' WHEN opcode = "11111000010" ELSE
        '1' WHEN opcode = "11111000000" ELSE
        '0';
    regWrite <= '1' WHEN opcode = "10001011000" ELSE
        '1' WHEN opcode = "11001011000" ELSE
        '1' WHEN opcode = "10001010000" ELSE
        '1' WHEN opcode = "10101010000" ELSE
        '1' WHEN opcode = "11111000010" ELSE
        '0';
END ARCHITECTURE controlunit_arc;