`timescale 1ns / 1ps

module siso (
    input clk, rst, din,
    output reg dout
);
    reg [3:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            shift_reg <= 4'b0000;
        else
            shift_reg <= {shift_reg[2:0], din};
    end

    always @(*) begin
        dout = shift_reg[3];
    end
endmodule
`timescale 1ns / 1ps

module siso_tb;

    reg clk, rst, din;
    wire dout;

    // Instantiate the SISO module
    siso uut (
        .clk(clk),
        .rst(rst),
        .din(din),
        .dout(dout)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        din = 0;

        // Reset pulse
        #10 rst = 0;

        // Apply serial input bits: 1, 0, 1, 1
        #10 din = 1;
        #10 din = 0;
        #10 din = 1;
        #10 din = 1;

        // Hold the input to 0 afterward
        #10 din = 0;

        // Wait to observe dout shift
        #50;

        $finish;
    end

endmodule
