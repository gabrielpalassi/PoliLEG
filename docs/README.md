# 🖥️ PoliLEG

Um processador pode ser visto como um projeto que utiliza o paradigma de unidade de controle e fluxo de dados. A unidade de controle é responsável pelo ciclo de busca, decodificação, execução e gravação dos dados, ciclo este que rege o funcionamento de um computador de uso geral pela sua característica programável. Já o fluxo de dados é composto por elementos de memória (e.g. banco de registradores), componentes de controle de fluxo (quase sempre combinatórios) e unidades funcionais.

Especificado em VHDL, o PoliLEG é um processador de arquitetura Harvard de ciclo único, projetado para executar uma única instrução em um único ciclo de clock. Ele possui um subconjunto das instruções do ARMv8 (LEGv8 do Hennessy e Patterson).

## Instruções Suportadas

O PoliLEG suporta as seguintes instruções:

<img src="./images/instrucoes.png" width=612.5>

### Formato das Instruções

   - Formato-D para LDUR e STUR
   - Formato-R para ADD, SUB, AND e ORR
   - Formato-CB para CBZ
   - Formato-B para B

<img src="./images/formatos.png" width=612.5>

## Unidades Funcionais

O PoliLEG é composto por várias unidades funcionais:

1. **Memórias**:
   - Memória de Instrução (IM) para armazenar instruções.
   - Memória de Dados (DM) para armazenar dados.

2. **Registrador**:
   - PC (Contador de Programa).

3. **Banco de Registradores**:
   - Armazena os registros utilizados pelas instruções.

4. **ULA (Unidade Lógico-Aritmética)**:
   - Executa operações aritméticas e lógicas.

5. **Multiplexadores**:
   - Direcionam os dados para as unidades corretas.

6. **Sign-Extension**:
   - Realiza a extensão de sinal quando necessário.

<img src="./images/arquitetura.png" width=612.5>

## Programa na ROM

O programa armazenado na ROM (arquivo `rom.dat`) é uma solução para o Máximo Divisor Comum (MDC). Os parâmetros para o algoritmo MDC estão na RAM (arquivo `ram.dat`):

- Endereço 0: Valor constante correspondente ao maior valor negativo em complemento de dois.
- Endereço 1: Primeiro parâmetro (A) para o algoritmo MDC.
- Endereço 2: Segundo parâmetro (B) para o algoritmo MDC.

O programa lê os valores de A e B, calcula o MDC entre eles e armazena o resultado no endereço 0, onde está a constante.

*Obs: A RAM e a ROM finais não seguem a descrição exata do [enunciado](./Enunciado.pdf) a fim de manter a compatibilidade com o processador desenvolvido (tamanho de palavra, endereço, etc.)
