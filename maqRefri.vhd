library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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

type estado is (ESPERA, VERIFICA_COMPRA, MOEDA_COLETADA, LIBERA_DOCE );

SIGNAL estado_atual : estado;
SIGNAL proximo_estado : estado;

begin

PROCESS (CLK, RESET)
BEGIN
-- Faz com que se o RESET seja igual a 1, a máquina reinicia para estado DESLIGADO
    IF RESET = '1' THEN
        estado_atual <= DESLIGADO;

    ELSIF rising_edge(CLK) THEN
        estado_atual <= proximo_estado;
    END IF;
END PROCESS;


 
end comportamento;




