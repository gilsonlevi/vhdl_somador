library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Representa o bloco da maquina que recebe o clock (CLK), o reset (RESET) e a entrada S e tem como saída o LED

-- C1C0 = 00 , NENHUMA MOEDA INSERIDA
-- C1C0 = 01 , UMA MOEDA DE 5 CENTAVOS FOIINSERIDA
-- C1C0 = 10 , UMA MOEDA DE 10 CENTAVOS FOI INSERIDA
-- C1C0 = 11 , UMA MOEDA DE 25 CENTAVOS FOI INSERIDA

-- O DOCE CUSTA 80 CENTAVOS

entity maqRefri is
    Port (
-- Clock, o estado só pode mudar se aparecer a borda de subida do clock
		CLK   : in STD_LOGIC;

-- Reseta a maquina fazendo voltar para o inicio
		RESET	: in STD_LOGIC;

-- Quais moedas foram colocadas
        C1    : in  STD_LOGIC;
        C0    : in  STD_LOGIC;

-- Aciona o recebimento da moeda colocada
        Cin   : in  STD_LOGIC; 

-- Mostra o quanto de dinheiro tem guardado
       	D  	  : out STD_LOGIC_VECTOR(7 DOWNTO 0);

-- Libera o doce se tiver moedas o suficiente
		S     : in	STD_LOGIC;

-- Mostra se houve a retirada do doce
		R     : out STD_LOGIC
    );
end maqRefri;

architecture comportamento of maqRefri is

-- ESTADOS
-- I - INICIAL/ESPERA
-- VERIFICA_COMPRA
-- MOEDA_COLETADA
-- LIBERA_DOCE 

type estado is (ESPERA, MOEDA_COLETADA , VERIFICA_COMPRA, LIBERA_DOCE );

SIGNAL estado_atual : estado;
SIGNAL proximo_estado : estado;

SIGNAL saldo : UNSIGNED(7 DOWNTO 0);
SIGNAL valor_moeda : UNSIGNED(7 DOWNTO 0);

SIGNAL Cin_anterior : STD_LOGIC;
SIGNAL moeda_detectada : STD_LOGIC;

begin

	-- MOSTRA A QUANTIDADE DE DINHEIRO COLOCADA ATÉ AGORA
	D <= STD_LOGIC_VECTOR(saldo);

PROCESS (CLK, RESET)
BEGIN
-- Faz com que se o RESET seja igual a 1, a máquina reinicia para estado ESPERA
-- Resetar o valor de D
	IF RESET = '1' THEN
        estado_atual <= ESPERA;
    ELSIF rising_edge(CLK) THEN
        estado_atual <= proximo_estado;
    END IF;
END PROCESS;

PROCESS (estado_atual, C1, C0, Cin, S)
BEGIN 

	CASE C1 & C0 IS
        WHEN "00" => valor_moeda <= TO_UNSIGNED(0, 8);
        WHEN "01" => valor_moeda <= TO_UNSIGNED(5, 8);
        WHEN "10" => valor_moeda <= TO_UNSIGNED(10, 8);
        WHEN "11" => valor_moeda <= TO_UNSIGNED(25, 8);
        WHEN OTHERS => valor_moeda <= TO_UNSIGNED(0, 8);

	CASE estado_atual IS

		WHEN ESPERA =>
			R <= '0';
			IF Cin = '1' AND S = '0' THEN
				proximo_estado <= MOEDA_COLETADA;
			ELSIF S = '1' THEN
				proximo_estado <= VERIFICA_COMPRA;
			ELSE 
				proximo_estado <= estado_atual;
			END IF;

		WHEN MOEDA_COLETADA =>
			saldo <= saldo + valor_moeda;

-- Registrar o valor de C1C0 em D

			proximo_estado <= ESPERA;

		WHEN VERIFICA_COMPRA =>
			IF saldo >= TO_UNSIGNED(80, 8) THEN
				proximo_estado <= LIBERA_DOCE;
			ELSE
				proximo_estado <= ESPERA;
			END IF;
-- Comparar o vetor D com o valor 80
-- Se vetor D for igual ou maior que 80 ir para LIBERA_DOCE

		WHEN LIBERA_DOCE =>
-- Descontar 80 do vetor 
			saldo <= saldo - TO_UNSIGNED(80, 8);
			R <= '1';
			proximo_estado <= ESPERA;
	END CASE;

END PROCESS;

end comportamento;




