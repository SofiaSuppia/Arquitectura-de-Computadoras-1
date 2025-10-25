
`timescale 1ns/1ps
`include "io_interface.v"

module tb_io_interface;
    // Clock: 50 MHz -> 20 ns period
    reg clk = 0;
    always #10 clk = ~clk;

    reg rst_n = 0;
    reg [7:0] switches = 8'h00;
    reg       uart_start = 0;
    reg [7:0] uart_data  = 8'h00;
    wire [7:0] leds;
    wire       uart_tx;
    wire       uart_busy;

    // Use small CLKS_PER_BIT so sim runs quickly (1 bit = 16 clocks = 320 ns)
    localparam integer CLKS_PER_BIT = 16;

    io_interface #(.CLKS_PER_BIT(CLKS_PER_BIT)) dut (
        .clk        (clk),
        .rst_n      (rst_n),
        .switches   (switches),
        .leds       (leds),
        .uart_start (uart_start),
        .uart_data  (uart_data),
        .uart_tx    (uart_tx),
        .uart_busy  (uart_busy)
    );

    // VCD dump
    initial begin
        $dumpfile("io_interface.vcd");
        $dumpvars(0, tb_io_interface);
    end

    // Stimulus
    initial begin
        // Reset
        rst_n = 0;
        repeat (3) @(posedge clk);
        rst_n = 1;

        // Toggle switches (mapping to LEDs)
        switches = 8'b1010_1100;  // LEDs should mirror
        repeat (10) @(posedge clk);
        switches = 8'b0101_0011;
        repeat (10) @(posedge clk);

        // Transmit first byte 0x55 (0101_0101) pattern
        uart_data  = 8'h55;
        uart_start = 1'b1;
        @(posedge clk);
        uart_start = 1'b0;

        // Wait until UART not busy
        wait (uart_busy == 1'b0);

        // Second byte 0xA7
        repeat (5) @(posedge clk);
        uart_data  = 8'hA7;
        uart_start = 1'b1;
        @(posedge clk);
        uart_start = 1'b0;

        wait (uart_busy == 1'b0);
        repeat (20) @(posedge clk);

        $finish;
    end

endmodule
