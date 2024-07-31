The Spartan-6 family offers a high ratio of DSP48A1 slices to logic, making it ideal for math-
intensive applications. Design DSP48A1 slice of the spartan6 FPGAs. The testbench for this design can be challenging so use directed test patterns whenever needed to verify the design and either have expected value to compare with in the testbench or check the result from the waveforms. I used do file to run the Questasim flow and  Vivado to go through the design flow running elaboration, synthesis, and implementation making sure that there are no design check errors during the design flow. 


Note: opmode input has a register and mux pair in the design entry the same way as the input
A, D, or C.


Parameter (Attributes):
A0REG, A1REG, B0REG, and B1REG: The A0REG, A1REG, B0REG, and B1REG attributes can take values of 0 or 1. These values define the number of pipeline registers in the A
and B input paths. A0REG defaults to 0 (no register). A1REG defaults to 1 (register). B0REG defaults to 0 (no register) B1REG defaults to 1 (register). A0 and B0 are the first stages of the pipelines. A1 and B1 are the second stages of the pipelines


CREG, DREG, MREG, PREG, CARRYINREG, CARRYOUTREG, and OPMODEREG: These attributes can take a value of 0 or 1. The number defines the number of pipeline stages. Default: 1 (registered)


CARRYINSEL The CARRYINSEL attribute is used in the carry cascade input, either
the CARRYIN input will be considered or the value of opcode[5]. This attribute can be set to the string CARRYIN or OPMODE5. Default: OPMODE[5]. Tie the output of the mux to 0 if none of these string values exist.


B_INPUT The B_INPUT attribute defines whether the input to the B port is routed from the B input (attribute = DIRECT) or the cascaded input (BCIN) from the previous DSP48A1 slice (attribute = CASCADE). Default: DIRECT. Tie the output of the mux to 0 if none of these string
values exist.


RSTTYPE The RSTTYPE attribute selects whether all resets for the DSP48A1 slice should have a synchronous or asynchronous reset capability. This attribute can be set to ASYNC or SYNC. Default: SYNC.


Data Ports:


A: 18-bit data input to the multiplier, and optionally to post-adder/subtracter depending on the value of OPMODE[1:0].


B 18-bit data input to pre-adder/subtracter, to multiplier depending on OPMODE[4], or to post-adder/subtracter depending on OPMODE[1:0].


C 48-bit data input to post-adder/subtracter.
D 18-bit data input to pre-adder/subtracter. D[11:0] are concatenated with A and B and optionally sent to post-adder/subtracter depending on the value of OPMODE[1:0].


CARRYIN carry input to the post-adder/subtracter
M 36-bit buffered multiplier data output, routable to the FPGA logic. It is either the output of the M register (MREG = 1) or the direct output of the multiplier (MREG = 0).


P Primary data output from the post-adder/subtracter. It is either the output of the P register (PREG = 1) or the direct output of the post-adder/subtracter (PREG = 0).


CARRYOUT Cascade carry out signal from post-adder/subtracter. It can be registered in (CARRYOUTREG = 1) or unregistered (CARRYOUTREG = 0). This output is to be connected only to CARRYIN of adjacent DSP48A1 if multiple DSP blocks are used.


CARRYOUTF Carry out signal from post-adder/subtracter for use in the FPGA logic. It is a copy of the CARRYOUT signal that can be routed to the user logic.


Control Input Ports:


CLK DSP clock
OPMODE Control input to select the arithmetic operations of the DSP48A1 slice.


Clock Enable Input Ports:


CEA Clock enable for the A port registers: (A0REG & A1REG).
CEB Clock enable for the B port registers: (B0REG & B1REG).
CEC Clock enable for the C port registers (CREG).
CECARRYIN Clock enable for the carry-in register (CYI) and the carry-out register(CYO).


CED Clock enable for the D port register (DREG).
CEM Clock enable for the multiplier register (MREG).
CEOPMODE Clock enable for the opmode register (OPMODEREG).
CEP Clock enable for the P output port registers (PREG = 1).


Reset Input Ports: All the resets are active high reset. They are either sync or
async depending on the parameter RSTTYPE.


RSTA Reset for the A registers: (A0REG & A1REG).
RSTB Reset for the B registers: (B0REG & B1REG).
RSTC Reset for the C registers (CREG).
RSTCARRYIN Reset for the carry-in register (CYI) and the carry-out register (CYO).
RSTD Reset for the D register (DREG).
RSTM Reset for the multiplier register (MREG).
RSTOPMODE Reset for the opmode register (OPMODEREG).
RSTP Reset for the P output registers (PREG = 1).


Cascade Ports:
BCOUT Cascade output for Port B.
PCIN Cascade input for Port P.
PCOUT Cascade output for Port P.


OPMODE Pin Descriptions:
OPMODE[1:0] Specifies the source of the X input to the post-adder/subtracter
0-Specifies to place all zeros (disable the post-adder/subtracter and propagate the Z result to P)
1- Use the multiplier product
2-Use the P output signal (accumulator)
3-Use the concatenated D:A:B input signals


OPMODE[3:2]: Specifies the source of the Z input to the post-adder/subtracter
0-Specifies to place all zeros (disable the post-adder/subtracter and propagate the multiplier product or other X result to P)
1- Use the PCIN
2-Use the P output signal (accumulator)
3-Use the C port


OPMODE[4] 
0-Bypass the pre-adder supplying the data on port B directly to the multiplier 
1-Selects to use the pre-adder adding or subtracting the values on the B and D ports prior to the multiplier


OPMODE[5]
Forces a value on the carry input of the carry-in register (CYI) or direct to the CIN to the post-adder. Only applicable when CARRYINSEL = OPMODE5


OPMODE[6]
Specifies whether the pre-adder/subtracter is an adder or subtracter
 0-Specifies pre-adder/subtracter to perform an addition operation 1- Specifies pre-adder/subtracter to perform a subtraction operation (D-B)


OPMODE[7]
Specifies whether the post-adder/subtracter is an adder or subtracter 
0-Specifies post-adder/subtracter to perform an addition operation 
1- Specifies post-adder/subtracter to perform a subtraction operation (Z-(X+CIN))
