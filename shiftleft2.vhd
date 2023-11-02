LIBRARY IEEE;
USE IEEE.numeric_bit.ALL;

ENTITY shiftleft2 IS
    GENERIC (
        ws : NATURAL := 64 -- Word size
    );
    PORT (
        i : IN bit_vector(ws - 1 DOWNTO 0); -- Input
        o : OUT bit_vector(ws - 1 DOWNTO 0) -- Output
    );
END shiftleft2;

ARCHITECTURE shiftleft2_arc OF shiftleft2 IS
BEGIN
    o <= i(ws - 3 DOWNTO 0) & "00";
END ARCHITECTURE shiftleft2_arc;