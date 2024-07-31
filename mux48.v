module mux48(A,B,C,D,SEL,OUT);
input [47:0] A,B,C,D;
input [1:0] SEL;
output reg[47:0] OUT;
always @(*) begin
    case(SEL)
        2'b00: OUT = A;
        2'b01: OUT = B;
        2'b10: OUT = C;
        2'b11: OUT = D;
    endcase
end

endmodule
