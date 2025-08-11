`timescale 1ns/1ps
`include "shift_register.v"
module shift_register_tb;

	reg clk;
	reg serial_in;
	wire [3:0] q;

	// Instanciar el módulo bajo prueba (UUT)
	shift_register uut (
		.clk(clk),
		.serial_in(serial_in),
		.q(q)
	);

	// Generar reloj
	initial begin
        $dumpfile("shift_register.vcd");
        $dumpvars(0,shift_register_tb);
		clk = 0;
		forever #5 clk = ~clk; // Periodo de 10ns

        $monitor("%0dns: serial_in=%b, q=%b", $time, serial_in, q); // Monitor para ver los cambios

        // Proceso de prueba
        serial_in = 0;
		// Esperar un ciclo de reloj
		#10;
		serial_in = 1; #10;
		serial_in = 0; #10;
		serial_in = 1; #10;
		serial_in = 1; #10;
		serial_in = 0; #10;
		serial_in = 0; #10;
		serial_in = 1; #10;
		serial_in = 0; #10;
		$finish;
	end

endmodule
