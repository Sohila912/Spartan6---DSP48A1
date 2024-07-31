module reg_mux #(parameter F_width = 18, parameter RSTTYPE = "SYNC", parameter F_reg = 1) (
    input [F_width-1:0] F,
    input clk,CE,
    input reset,
    output reg [F_width-1:0] f_mux_out
);
    reg [F_width-1:0] F_reg1;

    // Synchronous reset logic
    generate
        if (RSTTYPE == "SYNC") begin : sync_reset
            always @(posedge clk) begin
                if (reset) begin
                    F_reg1 <= 0;
                end else if (F_reg == 1) begin
                    F_reg1 <= F;
                end
            end
        end
    endgenerate

    // Asynchronous reset logic
    generate
        if (RSTTYPE == "UNSYNC") begin : async_reset
            always @(posedge clk or posedge reset) begin
                if (reset) begin
                    F_reg1 <= 0;
                end else if (F_reg == 1) begin
                    F_reg1 <= F;
                end
            end
        end
    endgenerate

    // Multiplexer logic
    always @(posedge clk) begin
        if (F_reg == 1 && CE) begin
            f_mux_out <= F_reg1;
        end else begin
            f_mux_out <= F;
        end
    end
endmodule
