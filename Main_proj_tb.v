module testbench();
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

    Main_project #(
        .A0REG(A0REG), .A1REG(A1REG), .B0REG(B0REG), .B1REG(B1REG), .CREG(CREG), .DREG(DREG),
        .MREG(MREG), .PREG(PREG), .CARRYINREG(CARRYINREG), .CARRYOUTREG(CARRYOUTREG),
        .OPMODEREG(OPMODEREG), .CARRYINSEL(CARRYINSEL), .B_INPUT(B_INPUT), .RSTTYPE(RSTTYPE)
    ) Main_proj_tb (
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

        // Test case 1
        RSTA = 0; RSTB = 0; RSTC = 0; RSTCARRYIN = 0;
        RSTD = 0; RSTM = 0; RSTOPMODE = 0; RSTP = 0; 
        A = 18'h3FFF; B = 18'h0001; D = 18'h0002; C = 48'h00000001; OPMODE = 8'b00101001; CARRYIN = 0;
        CEA = 1; CEB = 1; CEC = 1; CED = 1; CEM = 1; CEP = 1; BCIN = 18'h0004; PCIN = 48'h0000000025;
        repeat (10) @(negedge CLK); 

        // Test case 2
        A = 18'h0002; B = 18'h0003; D = 18'h0004;
        OPMODE = 8'b00000000; 
        CEA = 1; CEB = 1; CED = 1; CEM = 1; CEP = 1;       
        repeat (10) @(negedge CLK); 

        // Test case 3
        C = 48'h0000000005; CARRYIN = 1;
        OPMODE = 8'b10000000; 
        repeat (10) @(negedge CLK);

        // Test case 4
        A = 18'h0010; B = 18'h0020; D = 18'h0030; C = 48'h0000000040; OPMODE = 8'b00010010; CARRYIN = 0;
        repeat (10) @(negedge CLK);

        // Test case 5
        A = 18'h00FF; B = 18'h0100; D = 18'h0200; C = 48'h0000000300; OPMODE = 8'b00110100; CARRYIN = 1;
        repeat (10) @(negedge CLK);

        // Test case 6
        A = 18'h0A0A; B = 18'h0B0B; D = 18'h0C0C; C = 48'h0000000D0D; OPMODE = 8'b01010101; CARRYIN = 0;
        repeat (10) @(negedge CLK);

        // Test case 7
        A = 18'h0FFF; B = 18'h1FFF; D = 18'h2FFF; C = 48'h0000003FFF; OPMODE = 8'b01111000; CARRYIN = 1;
        repeat (10) @(negedge CLK);

        // Test case 8
        A = 18'h1000; B = 18'h2000; D = 18'h3000; C = 48'h000004000; OPMODE = 8'b10000001; CARRYIN = 0;
        repeat (10) @(negedge CLK);

        // Test case 9
        A = 18'h1234; B = 18'h5678; D = 18'h9ABC; C = 48'h00000DEF0; OPMODE = 8'b10010110; CARRYIN = 1;
        repeat (10) @(negedge CLK);

        // Test case 10
        A = 18'hAAAA; B = 18'hBBBB; D = 18'hCCCC; C = 48'h00000DDDD; OPMODE = 8'b10101010; CARRYIN = 0;
        repeat (10) @(negedge CLK);

        // Test case 11
        A = 18'h0; B = 18'h0; D = 18'h0; C = 48'h0; OPMODE = 8'b00000001; CARRYIN = 1;
        repeat (10) @(negedge CLK);

        // Test case 12
        A = 18'hFFFF; B = 18'hFFFF; D = 18'hFFFF; C = 48'hFFFFFFFF; OPMODE = 8'b11011011; CARRYIN = 0;
        repeat (10) @(negedge CLK);

        // Test case 13
        A = 18'hF0F0; B = 18'h0F0F; D = 18'h0FF0; C = 48'h0000FF00; OPMODE = 8'b11100100; CARRYIN = 1;
        repeat (10) @(negedge CLK);

        // Test case 14
        A = 18'h1; B = 18'h1; D = 18'h1; C = 48'h1; OPMODE = 8'b01111111; CARRYIN = 0;
        repeat (10) @(negedge CLK);

        // Test case 15
        A = 18'h2; B = 18'h2; D = 18'h2; C = 48'h2; OPMODE = 8'b11111111; CARRYIN = 1;
        repeat (10) @(negedge CLK);

        $stop; 
    end
endmodule
