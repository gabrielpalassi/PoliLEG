LIBRARY IEEE;
USE IEEE.numeric_bit.ALL;

ENTITY signextend IS
    PORT (
        i : IN bit_vector(31 DOWNTO 0); -- Input
        o : OUT bit_vector(63 DOWNTO 0)
    );
END signextend;

ARCHITECTURE signextend_arc OF signextend IS
    SIGNAL concatenateD : bit_vector(54 DOWNTO 0) := (OTHERS => '0');
    SIGNAL concatenateB : bit_vector(37 DOWNTO 0) := (OTHERS => '0');
    SIGNAL concatenateCB : bit_vector(44 DOWNTO 0) := (OTHERS => '0');
BEGIN
    o <= (concatenateD & i(20 DOWNTO 12)) WHEN (i(31 DOWNTO 27) = "11111" AND i(20) = '0') ELSE
        (NOT(concatenateD) & i(20 DOWNTO 12)) WHEN (i(31 DOWNTO 27) = "11111" AND i(20) = '1') ELSE
        (concatenateB & i(25 DOWNTO 0)) WHEN (i(31 DOWNTO 26) = "000101" AND i(25) = '0') ELSE
        (NOT(concatenateB) & i(25 DOWNTO 0)) WHEN (i(31 DOWNTO 26) = "000101" AND i(25) = '1') ELSE
        (concatenateCB & i(23 DOWNTO 5)) WHEN (i(31 DOWNTO 24) = "10110100" AND i(23) = '0') ELSE
        (NOT(concatenateCB) & i(23 DOWNTO 5)) WHEN (i(31 DOWNTO 24) = "10110100" AND i(23) = '1');
END ARCHITECTURE signextend_arc;