`timescale 1ns/1ps
`include "mux4a1.v"

module mux4a1_tb;

    reg [7:0] d0, d1, d2, d3;
    reg [1:0] sel;
    wire [7:0] y;

    mux4a1 uut (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .sel(sel),
        .y(y)
    );

    initial begin
    $dumpfile("mux_test.vcd");  // Archivo VCD para GTKWave
    $dumpvars(0, mux4a1_tb);
    
    // Test case 1
    d0 = 8'h01; // 0x01
    d1 = 8'hA5; // 0xA5
    d2 = 8'h3C; // 0x3C
    d3 = 8'hF0; // 0xF0
    sel = 2'b00;
    #10;
    $display("Test case 1: sel=%b, y=%h", sel, y);

    // Test case 2
    sel = 2'b01;
    #10;
    $display("Test case 2: sel=%b, y=%h", sel, y);

    // Test case 3
    sel = 2'b10;
    #10;
    $display("Test case 3: sel=%b, y=%h", sel, y);

    // Test case 4
    sel = 2'b11;
    #10;
    $display("Test case 4: sel=%b, y=%h", sel, y);

    $finish;
    end

endmodule