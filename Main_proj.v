module Main_project(A,B,C,D,CARRYIN,M,P,CARRYOUT,CARRYOUTF,CLK,OPMODE,CEA,CEB,CEC,CECARRYIN,
CED,CEM,CEOPMODE,CEP,RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP,BCIN,BCOUT,PCIN,PCOUT);
parameter A0REG = 1;
parameter A1REG = 1;
parameter B0REG = 1;
parameter B1REG = 1;
parameter CREG = 1;
parameter DREG = 1;
parameter MREG = 1;
parameter PREG = 1;
parameter CARRYINREG = 1;
parameter CARRYOUTREG = 1;
parameter OPMODEREG = 1;
parameter CARRYINSEL = "OPMODES"; // "OPMODES" for OPMODES, "CARRYIN" for CARRYIN
parameter B_INPUT = "DIRECT"; // "DIRECT" for direct input, "CASCADE" for BCIN input
parameter RSTTYPE = "SYNC"; // "SYNC" for synchronous reset, "UNSYNC" for asynchronous reset

input [17:0] A,B,D,BCIN;
input [47:0] C;
input CARRYIN; //post adder/subtractor carry in
output wire [35:0] M; 
output wire [47:0] P;
output wire CARRYOUT,CARRYOUTF;
input CLK,CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP;
input [7:0] OPMODE; 
input RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP;
output wire [17:0] BCOUT;
output wire [47:0] PCOUT;
input [47:0] PCIN;
wire [17:0] A0,A1,B0,B1,D0;
wire [47:0] P0;
wire [35:0] M0;
wire [7:0]Opmode0;
wire CARRYOUT0,CarryInValue,CarryIn0;
wire [47:0] C0;
wire [17:0] valueB;
wire [17:0] preadderout,preadderout_mux;
wire [35:0] multiplier_out;
wire [47:0] postadderout;  
wire CARRYOUT0_IN;  
wire [47:0] x_out,z_out;
assign valueB = (B_INPUT   == "DIRECT") ? B :
                   (B_INPUT == "CASCADE") ? BCIN :
                   18'b0;  
assign CarryInValue = (CARRYINSEL == "OPMODES") ? Opmode0[5] :
                   (CARRYINSEL == "CARRYIN") ? CARRYIN :
                   1'b0;

reg_mux #(.F_width(18), .RSTTYPE(RSTTYPE), .F_reg(A0REG)) A0_reg_mux (.F(A),.clk(CLK),.reset(RSTA),.f_mux_out(A0),.CE(CEA));
reg_mux #(.F_width(18), .RSTTYPE(RSTTYPE), .F_reg(B0REG)) B0_reg_mux (.F(valueB),.clk(CLK),.reset(RSTB),.f_mux_out(B0),.CE(CEB));
reg_mux #(.F_width(48), .RSTTYPE(RSTTYPE), .F_reg(CREG)) C_reg_mux (.F(C),.clk(CLK),.reset(RSTC),.f_mux_out(C0),.CE(CEC)); 
reg_mux #(.F_width(18), .RSTTYPE(RSTTYPE), .F_reg(DREG)) D_reg_mux (.F(D),.clk(CLK),.reset(RSTD),.f_mux_out(D0),.CE(CED)); 
reg_mux #(.F_width(8), .RSTTYPE(RSTTYPE), .F_reg(OPMODEREG)) Opmode_reg_mux (.F(OPMODE),.clk(CLK),.reset(RSTOPMODE),.f_mux_out(Opmode0),.CE(CEOPMODE));

//pre adder/subtractor
assign preadderout = (Opmode0[6]) ? D0 - B0 : D0 + B0;
assign preadderout_mux = (Opmode0[4]) ? preadderout : valueB;

reg_mux #(.F_width(18), .RSTTYPE(RSTTYPE), .F_reg(A1REG)) A1_reg_mux (.F(A0),.clk(CLK),.reset(RSTA),.f_mux_out(A1),.CE(CEA));
reg_mux #(.F_width(18), .RSTTYPE(RSTTYPE), .F_reg(B1REG)) B1_reg_mux (.F(preadderout_mux),.clk(CLK),.reset(RSTB),.f_mux_out(B1),.CE(CEB));  

assign BCOUT = B1;
assign multiplier_out = A1 * B1;

reg_mux #(.F_width(36), .RSTTYPE(RSTTYPE), .F_reg(MREG)) M_reg_mux (.F(multiplier_out),.clk(CLK),.reset(RSTM),.f_mux_out(M0) ,.CE(CEM)); 

assign M = M0;

reg_mux #(.F_width(1), .RSTTYPE(RSTTYPE), .F_reg(CARRYINREG)) CYI (.F(CarryInValue),.clk(CLK),.reset(RSTCARRYIN),.f_mux_out(CarryIn0),.CE(CECARRYIN));

//x and z mux
mux48 x_mux(.A({48'b0}),.B({18'b0,multiplier_out}),.C(P),.D({D,A,B}),.SEL(Opmode0[1:0]),.OUT(x_out));   
mux48 z_mux(.A({48'b0}),.B(PCIN),.C(P),.D(C),.SEL(Opmode0[3:2]),.OUT(z_out)); 

//post adder/subtractor
assign {CARRYOUT0_IN,postadderout} = (Opmode0[7]) ? z_out - (x_out + CarryIn0) : z_out + (x_out + CarryIn0);

reg_mux #(.F_width(48), .RSTTYPE(RSTTYPE), .F_reg(PREG)) P_reg_mux (.F(postadderout),.clk(CLK),.reset(RSTP),.f_mux_out(P0),.CE(CEP));
reg_mux #(.F_width(1), .RSTTYPE(RSTTYPE), .F_reg(CARRYOUTREG)) CYO (.F(CARRYOUT0_IN),.clk(CLK),.reset(RSTP),.f_mux_out(CARRYOUT0),.CE(CEP));

assign P = P0;
assign PCOUT = P0;
assign CARRYOUT = CARRYOUT0;
assign CARRYOUTF = CARRYOUT0;

 endmodule
