LIBRARY IEEE;
USE IEEE.numeric_bit.ALL;

ENTITY fulladder IS
    PORT (
        a, b, cin : IN BIT;
        s, cout : OUT BIT
    );
END ENTITY fulladder;

ARCHITECTURE fulladder_arc OF fulladder IS
    SIGNAL sum : BIT;
BEGIN
    sum <= a XOR b;
    s <= sum XOR cin;
    cout <= (a AND b) OR ((a OR b) AND cin);
END ARCHITECTURE fulladder_arc;