module testbench;
    reg [17:0] A, B, D, BCIN;
    reg [47:0] C;
    reg CARRYIN;
    reg CLK, CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP;
    reg [7:0] OPMODE;
    reg RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP;
    wire [35:0] M;
    wire [47:0] P;
    wire CARRYOUT, CARRYOUTF;
    wire [17:0] BCOUT;
    wire [47:0] PCOUT;
    reg [47:0] PCIN;

    Main_project uut (
        .A(A), .B(B), .C(C), .D(D), .CARRYIN(CARRYIN), .M(M), .P(P),
        .CARRYOUT(CARRYOUT), .CARRYOUTF(CARRYOUTF), .CLK(CLK), .OPMODE(OPMODE),
        .CEA(CEA), .CEB(CEB), .CEC(CEC), .CECARRYIN(CECARRYIN), .CED(CED),
        .CEM(CEM), .CEOPMODE(CEOPMODE), .CEP(CEP), .RSTA(RSTA), .RSTB(RSTB),
        .RSTC(RSTC), .RSTCARRYIN(RSTCARRYIN), .RSTD(RSTD), .RSTM(RSTM),
        .RSTOPMODE(RSTOPMODE), .RSTP(RSTP), .BCIN(BCIN), .BCOUT(BCOUT),
        .PCIN(PCIN), .PCOUT(PCOUT)
    );
initial begin
    CLK = 0;
    forever begin 
        #10 CLK = ~CLK;
end
end
    initial begin
       
        CLK = 0;
        RSTA = 1; RSTB = 1; RSTC = 1; RSTCARRYIN = 1;
        RSTD = 1; RSTM = 1; RSTOPMODE = 1; RSTP = 1;
        A = 18'b0; B = 18'b0; D = 18'b0; BCIN = 18'b0;
        C = 48'b0; CARRYIN = 0; OPMODE = 8'b0;
        CEA = 0; CEB = 0; CEC = 0; CECARRYIN = 0;
        CED = 0; CEM = 0; CEOPMODE = 0; CEP = 0;
        PCIN = 48'b0;
        repeat (2) @(negedge CLK);

    
         RSTA = 0; RSTB = 0; RSTC = 0; RSTCARRYIN = 0;
            RSTD = 0; RSTM = 0; RSTOPMODE = 0; RSTP = 0;
            repeat (15) @(negedge CLK); 

         A = 18'h3FFF; B = 18'h0001; D = 18'h0002; C = 48'h00000001;
            CEA = 1; CEB = 1; CEC = 1; CED = 1; CEM = 1; CEP = 1;
            repeat (15) @(negedge CLK); 

        A = 18'h0002; B = 18'h0003; D = 18'h0004;
            OPMODE = 8'b00000000; 
            CEA = 1; CEB = 1; CED = 1; CEM = 1; CEP = 1;       
        repeat (10) @(negedge CLK); 

       
         C = 48'h0000000005; CARRYIN = 1;
            OPMODE = 8'b10000000; 
                    repeat (10) @(negedge CLK); 
            $stop; 
    end
endmodule

