LIBRARY IEEE;
USE IEEE.numeric_bit.ALL;

ENTITY alucontrol IS
    PORT (
        aluop : IN bit_vector(1 DOWNTO 0);
        opcode : IN bit_vector(10 DOWNTO 0);
        aluCtrl : OUT bit_vector(3 DOWNTO 0)
    );
END ENTITY alucontrol;

ARCHITECTURE alucontrol_arc OF alucontrol IS
BEGIN
    aluCtrl <= "0010" WHEN (aluop = "00") ELSE
        "0111" WHEN (aluop(1) = '1') ELSE
        "0010" WHEN (aluop(0) = '1' AND opcode = "10001011000") ELSE
        "0110" WHEN (aluop(0) = '1' AND opcode = "11001011000") ELSE
        "0000" WHEN (aluop(0) = '1' AND opcode = "10001010000") ELSE
        "0001" WHEN (aluop(0) = '1' AND opcode = "10101010000") ELSE
        "0000";
END ARCHITECTURE alucontrol_arc;