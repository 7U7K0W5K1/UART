library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity UART_ECHO is
port(
	RX  : in std_logic;
	CLK : in std_logic;
	RST : in std_logic;
	TX  : out std_logic;
	CLK96OUT : out std_logic
);
end entity UART_ECHO;

architecture BEHAVORIAL of UART_ECHO is
	signal CLKB,DR,DS,SS : std_logic;
	signal DATAI,DATAO : std_logic_vector(7 downto 0);
	signal counter 				: std_logic_vector(15 downto 0);
	
	component uart_tx is
	port(
		SS  : in std_logic;
		DA  : in std_logic_vector(7 downto 0);
		CLK : in std_logic;
		RST : in std_logic;
		DS	 : out std_logic;
		TX  : out std_logic
	);
	end component UART_TX;

	component uart_rx is
	port(
		RX  : in std_logic;
		CLK : in std_logic;
		RST : in std_logic;
		DR  : out std_logic;
		DA  : out std_logic_vector(7 downto 0)
	);
	end component UART_RX;
begin

		SLOWDOWN:process(CLK,RST)
		begin
			If (RST = '0') Then
				counter <= X"0000";
			Elsif rising_edge(CLK) Then
				If counter = X"1400" then
					counter <= X"0000";
				Else
					counter <= counter + 1;
				End If;
			End If;
			
			If (DS = '1' and DR = '1') Then
				DATAO <= DATAI;
			end if;
			
			If (DR = '0') Then
				SS <= '0';
			else
				SS <= '1';
			end if;
		end process;
		
		CLKB <= '1' when counter = X"1400" else
				'0';

		U0:uart_tx port map(SS,DATAO,CLKB,RST,DS,TX);
		U1:uart_rx port map(RX,CLKB,RST,DR,DATAI);
		
		CLK96OUT <= CLKB;
end architecture BEHAVORIAL;
