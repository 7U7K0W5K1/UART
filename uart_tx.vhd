library ieee;
use ieee.std_logic_1164.all;

entity UART_TX is
port(
	SS  : in std_logic;
	DA  : in std_logic_vector(7 downto 0);
	CLK : in std_logic;
	RST : in std_logic;
	DS	 : out std_logic;
	TX  : out std_logic
);
end entity UART_TX;

architecture BEHAVORIAL of UART_TX is
	type STATES is (IDLE,START,DATA0,DATA1,DATA2,DATA3,DATA4,DATA5,DATA6,DATA7,STOP);
	signal Q, D : STATES;
begin

	SEND: process(DA,CLK,RST)
	begin
		if RST = '0' Then
			Q <= IDLE;
			DS <= '1';
		elsif rising_edge(CLK) then
			Q <= D;
		end if;
		
		case Q is
			when IDLE =>
				TX <= '1';
				if SS = '1' then
					D <= START;
				else
					D <= IDLE;
				end if;
			when START =>
				TX <= '0';
				D <= DATA0;
				DS <= '0';
			when DATA0 =>
				TX <= DA(0);
				D <= DATA1;
			when DATA1 =>
				TX <= DA(1);
				D <= DATA2;
			when DATA2 =>
				TX <= DA(2);
				D <= DATA3;
			when DATA3 =>
				TX <= DA(3);
				D <= DATA4;
			when DATA4 =>
				TX <= DA(4);
				D <= DATA5;
			when DATA5 =>
				TX <= DA(5);
				D <= DATA6;
			when DATA6 =>
				TX <= DA(6);
				D <= DATA7;
			when DATA7 =>
				TX <= DA(7);
				D <= STOP;
			when STOP =>
				TX <= '0';
				D <= IDLE;
				DS <= '1';
		end case;
	end process;
end architecture BEHAVORIAL;
