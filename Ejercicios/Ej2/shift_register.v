/*
Shift Register Module
Diseña un registro de desplazamiento de 4 bits con entrada serial serial_in, señal de reloj clk, y
salida en paralelo q[3:0]. En cada flanco positivo de clk debe desplazarse el dato serial hacia la
derecha
*/

module shift_register (
    input wire clk,          // Clock signal
    input wire serial_in,   // Serial input data
    output reg [3:0] q      // 4-bit parallel output
);

    // On each positive edge of the clock, shift the register
    always @(posedge clk) begin
        q <= {serial_in, q[3:1]}; // Shift right and insert serial_in at the leftmost bit
    end