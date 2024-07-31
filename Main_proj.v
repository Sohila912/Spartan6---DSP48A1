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
output reg [35:0] M; 
output reg [47:0] P;
output reg CARRYOUT,CARRYOUTF;
input CLK,CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP;
input [7:0] OPMODE; 
input RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP;
output reg [17:0] BCOUT;
output reg [47:0] PCOUT;
input [47:0] PCIN;
wire [17:0] A0,A1,B0,B1,D0;
wire [47:0] P0;
wire [35:0] M0;
wire [7:0]Opmode0;
wire CARRYOUT0,CARRYIN0,CARRYIN_OUT;
wire [47:0] C0;
wire [17:0] valueB;
reg [17:0] preadderout,preadderout_mux;
reg [35:0] multiplier_out;
reg [47:0] postadderout;  
reg CARRYOUT0_IN;  
wire [47:0] x_out,z_out;
assign valueB = (B_INPUT == "DIRECT") ? B :
                   (B_INPUT == "CASCADE") ? BCIN :
                   18'b0;  
assign CARRYIN0 = (CARRYINSEL == "OPMODES") ? Opmode0[5] :
                   (CARRYINSEL == "CARRYIN") ? CARRYIN :
                   1'b0;

reg_mux #(.F_width(18), .RSTTYPE(RSTTYPE), .F_reg(A0REG)) A0_reg_mux (.F(A),.clk(CLK),.reset(RSTA),.f_mux_out(A0),.CE(CEA));
reg_mux #(.F_width(18), .RSTTYPE(RSTTYPE), .F_reg(A1REG)) A1_reg_mux (.F(A0),.clk(CLK),.reset(RSTA),.f_mux_out(A1),.CE(CEA));
reg_mux #(.F_width(18), .RSTTYPE(RSTTYPE), .F_reg(B0REG)) B0_reg_mux (.F(valueB),.clk(CLK),.reset(RSTB),.f_mux_out(B0),.CE(CEB));
reg_mux #(.F_width(18), .RSTTYPE(RSTTYPE), .F_reg(B1REG)) B1_reg_mux (.F(preadderout_mux),.clk(CLK),.reset(RSTB),.f_mux_out(B1),.CE(CEB));  //el F el mfrod ttla3 mn el adder
reg_mux #(.F_width(48), .RSTTYPE(RSTTYPE), .F_reg(CREG)) C_reg_mux (.F(C),.clk(CLK),.reset(RSTC),.f_mux_out(C0),.CE(CEC)); 
reg_mux #(.F_width(18), .RSTTYPE(RSTTYPE), .F_reg(DREG)) D_reg_mux (.F(D),.clk(CLK),.reset(RSTD),.f_mux_out(D0),.CE(CED)); 
reg_mux #(.F_width(36), .RSTTYPE(RSTTYPE), .F_reg(MREG)) M_reg_mux (.F(multiplier_out),.clk(CLK),.reset(RSTM),.f_mux_out(M0) ,.CE(CEM)); //el F el mfrod ttla3 mn el multiplier of A1,B1
reg_mux #(.F_width(1), .RSTTYPE(RSTTYPE), .F_reg(CARRYINREG)) CYI (.F(CARRYIN0),.clk(CLK),.reset(RSTCARRYIN),.f_mux_out(CARRYIN_OUT),.CE(CECARRYIN));
reg_mux #(.F_width(1), .RSTTYPE(RSTTYPE), .F_reg(CARRYOUTREG)) CYO (.F(CARRYOUT0_IN),.clk(CLK),.reset(RSTP),.f_mux_out(CARRYOUT0),.CE(CEP));
reg_mux #(.F_width(48), .RSTTYPE(RSTTYPE), .F_reg(PREG)) P_reg_mux (.F(postadderout),.clk(CLK),.reset(RSTP),.f_mux_out(P0),.CE(CEP));
reg_mux #(.F_width(8), .RSTTYPE(RSTTYPE), .F_reg(OPMODEREG)) Opmode_reg_mux (.F(OPMODE),.clk(CLK),.reset(RSTOPMODE),.f_mux_out(Opmode0),.CE(CEOPMODE));
mux48 x_mux(.A({36'b0,A0}),.B({18'b0,multiplier_out}),.C(P),.D({D,A,B}),.SEL(Opmode0[1:0]),.OUT(x_out));  //zero condition??
mux48 z_mux(.A({36'b0,A0}),.B(PCIN),.C(P),.D(C),.SEL(Opmode0[3:2]),.OUT(z_out));  //zero condition??

    // Synchronous reset logic
    generate
        if (RSTTYPE == "SYNC") begin : sync_reset
            always @(posedge CLK) begin
                //preadder
                if (Opmode0[6]) begin //subtraction
                   preadderout <= D0 - B0;
                    end
                else begin //addition
                    preadderout <= D0 + B0;
                end
                if(Opmode0[4])  //preadder value
                    preadderout_mux <= preadderout;
                else
                    preadderout_mux <= valueB;    
                
                BCOUT <= B1;
                multiplier_out <= A1 * B1;
                M <= M0;
               CARRYOUT <= CARRYOUT0;
               CARRYOUTF <= CARRYOUT0;  
                if(Opmode0[7]) //postadder - subtraction
                     {CARRYOUT0_IN,postadderout} <= z_out - (x_out + CARRYIN_OUT);    
                else //postadder - addition
                    {CARRYOUT0_IN,postadderout} <= z_out + (x_out + CARRYIN_OUT);  
                    P <= P0;
               PCOUT <= P0; 
            end
            end
    endgenerate

    //Asynchronous reset logic
    // generate
    //     if (RSTTYPE == "UNSYNC") begin : async_reset
    //         always @(posedge CLK or posedge RSTP) begin
    //             if(RSTP) begin
    //                 preadderout <= 0;
    //                 preadderout_mux <= 0;
    //                 BCOUT <= 0;
    //                 multiplier_out <= 0;
    //                 M <= 0;
    //                 postadderout <= 0;
    //                 CARRYOUT0_IN <= 0;
    //                 P <= 0;
    //                 PCOUT <= 0;
    //             end
    //             else begin
    //             if (Opmode0[6]) begin //subtraction
    //                preadderout <= D0 - B0;
    //                 end
    //             else begin //addition
    //                 preadderout <= D0 + B0;
    //             end
    //             if(Opmode0[4])  //preadder value
    //                 preadderout_mux <= preadderout;
    //             else
    //                 preadderout_mux <= valueB;    
                
    //             BCOUT <= B1;
    //             multiplier_out <= A1 * B1;
    //             M <= M0;
    //             if(Opmode0[7]) //postadder - subtraction
    //                  {CARRYOUT0_IN,postadderout} <= z_out - (x_out + CARRYIN_OUT);    
    //             else //postadder - addition
    //                 {CARRYOUT0_IN,postadderout} <= z_out + (x_out + CARRYIN_OUT);

    //            P <= P0;
    //            PCOUT <= P0; 
                
    //     end
    //         end
    //     end
    // endgenerate

 endmodule
