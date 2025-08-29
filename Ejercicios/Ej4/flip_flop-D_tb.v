`timescale 1ns / 1ps
`include "flip_flop-D.v"

module flip_flop_D_tb;

    reg clk;
    reg reset;
    reg D;
    wire Q;

    // Instanciación del flip-flop D
    flip_flop_D uut (
        .clk(clk),
        .reset(reset),
        .D(D),
        .Q(Q)
    );

    initial begin
        $dumpfile("flip_flop_D_test.vcd");
        $dumpvars(0, flip_flop_D_tb);

        // Inicializar señales
        clk = 0;
        reset = 0;
        D = 0;

        // Test 1: Sin reset
        #10;
        D = 1;
        #10;
        clk = 1;
        #10;
        clk = 0;

        // Test 2: Con reset
        #10;
        reset = 1;
        #10;
        reset = 0;
        D = 0;
        #10;
        clk = 1;
        #10;
        clk = 0;

        $finish;
    end

    // Generar señal de reloj
    always begin
        #5 clk = ~clk;
    end

endmodule
