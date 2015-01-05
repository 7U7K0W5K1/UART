library ieee;
use ieee.std_logic_1164.all;

entity UART_RX is
port(
	RX  : in std_logic;
	CLK : in std_logic;
	RST : in std_logic;
	DR  : out std_logic;
	DA  : out std_logic_vector(7 downto 0)
);
end entity UART_RX;

architecture BEHAVORIAL of UART_RX is
	type STATES is (IDLE,START,DATA0,DATA1,DATA2,DATA3,DATA4,DATA5,DATA6,DATA7,STOP);
	signal Q, D : STATES;
begin

	SEND: process(RX,CLK,RST)
	begin
		if RST = '0' Then
			Q <= IDLE;
			DR <= '0';
		elsif rising_edge(CLK) then
			Q <= D;
		end if;
		
		case Q is
			when IDLE =>
				If RX = '0' then
					D <= START;
				Else
					D <= IDLE;
				End if;
				
				DR <= '0';
			when START =>
				D <= DATA0;
				DR <= '0';
			when DATA0 =>
				DA(0) <= RX;
				D <= DATA1;
				DR <= '0';
			when DATA1 =>
				DA(1) <= RX;
				D <= DATA2;
				DR <= '0';
			when DATA2 =>
				DA(2) <= RX;
				D <= DATA3;
				DR <= '0';
			when DATA3 =>
				DA(3) <= RX;
				D <= DATA4;
				DR <= '0';
			when DATA4 =>
				DA(4) <= RX;
				D <= DATA5;
				DR <= '0';
			when DATA5 =>
				DA(5) <= RX;
				D <= DATA6;
				DR <= '0';
			when DATA6 =>
				DA(6) <= RX;
				D <= DATA7;
				DR <= '0';
			when DATA7 =>
				DA(7) <= RX;
				D <= STOP;
				DR <= '0';
			when STOP =>
				D <= IDLE;
				DR <= '1';
		end case;
	end process;
end architecture BEHAVORIAL;
