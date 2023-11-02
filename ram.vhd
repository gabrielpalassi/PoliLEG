LIBRARY IEEE;
USE IEEE.numeric_bit.ALL;
USE std.textio.ALL;

ENTITY ram IS
    GENERIC (
        addr_s : NATURAL := 64; -- Size in bits
        word_s : NATURAL := 64; -- Width in bits
        init_f : STRING := "ram.dat"
    );
    PORT (
        ck : IN BIT;
        rd, wr : IN BIT; -- Enables (read and write)
        addr : IN bit_vector(addr_s - 1 DOWNTO 0);
        data_i : IN bit_vector(word_s - 1 DOWNTO 0);
        data_o : OUT bit_vector(word_s - 1 DOWNTO 0)
    );
END ram;

ARCHITECTURE ram_arc OF ram IS
    TYPE mem_type IS ARRAY (0 TO (2 ** addr_s - 1)) OF bit_vector(word_s - 1 DOWNTO 0);
    -- Reading memory's initial content
    IMPURE FUNCTION ram_init RETURN mem_type IS
        FILE archive : text OPEN read_mode IS init_f;
        VARIABLE line_read : line;
        VARIABLE ram_data : mem_type;
    BEGIN
        FOR i IN 0 TO (2 ** addr_s - 1) LOOP
            readline(archive, line_read);
            read(line_read, ram_data(i));
        END LOOP;
        RETURN ram_data;
    END;
    -- End of reading initial content
    SIGNAL ram_chip : mem_type := ram_init;
BEGIN
    PROCESS (ck, wr, rd, addr) IS
    BEGIN
        IF (rising_edge(ck) AND wr = '1') THEN
            ram_chip(to_integer(unsigned(addr))) <= data_i;
        ELSE
            IF (wr = '0') THEN
                data_o <= ram_chip(to_integer(unsigned(addr)));
            END IF;
        END IF;
        IF (rd = '1') THEN
            data_o <= ram_chip(to_integer(unsigned(addr)));
        END IF;
    END PROCESS;
END ARCHITECTURE ram_arc;