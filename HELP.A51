#TMOD
G | C/T | M1 | M0 | G | C/T | M1 | M0 
{TIMER 1}         |    {TIMER 0}

#TCON
TF1, TR1, TF0, TR0, IT1, IT1, IE0, IT0


#INTRUPT
INT0
TF0
INT1
TF1
SERIAL


#IE ->  [EA, - , - , ES, ET1, EX1, ET0, EX0]
TCON.0 -> IT0
TCON.1 -> IT1