/*Diseña un flip-flop tipo D con reloj síncrono y señal de reset asíncrono activo alto. El flip-flop debe
almacenar el valor de la entrada D en el flanco positivo del reloj.*/

module flip_flop_D (
    input wire clk,      // Señal de reloj
    input wire reset,    // Señal de reset asíncrono
    input wire D,        // Entrada D
    output reg Q        // Salida Q
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 1'b0;  // Reset asíncrono
        end else begin
            Q <= D;     // Almacenar D en el flanco positivo del reloj
        end
    end

endmodule