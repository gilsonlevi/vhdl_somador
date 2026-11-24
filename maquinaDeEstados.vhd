library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Representa o bloco da maquina que recebe o clock (CLK), o reset (RESET) e a entrada S e tem como saída o LED

entity maquinaDeEstados is
    Port (
        CLK    : in  STD_LOGIC;
        RESET  : in  STD_LOGIC;
        S  	   : in  STD_LOGIC;
        LED    : out STD_LOGIC
    );
end maquinaDeEstados;

architecture comportamento of maquinaDeEstados is

type estado is (DESLIGADO, LIGADO);

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

PROCESS (estado_atual, S)
BEGIN

	CASE estado_atual IS
	
		WHEN DESLIGADO =>
			IF S = '1' THEN
				proximo_estado <= LIGADO;
			ELSE 
				proximo_estado  <= DESLIGADO;
			END IF;
			
		WHEN LIGADO =>
			IF S = '1' THEN
				proximo_estado <= DESLIGADO;
			ELSE
				proximo_estado <= LIGADO;
			END IF;
			
	END CASE;
END PROCESS;

 LED <= '1' WHEN estado_atual = LIGADO ELSE '0';
 
end comportamento;




