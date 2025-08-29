/*Realiza un módulo que implemente un multiplexor 4 a 1 con entradas de datos de 8 bits (data0 a
data3 ), señal de selección sel de 2 bits y salida y de 8 bits, usando descripción en nivel comporta-
miento.*/
module mux4a1 (
    input wire [7:0] d0,
    input wire [7:0] d1,
    input wire [7:0] d2,
    input wire [7:0] d3,
    input wire [1:0] sel,
    output reg [7:0] y
);

    always @(*) begin
        case (sel)
            2'b00: y = d0;
            2'b01: y = d1;
            2'b10: y = d2;
            2'b11: y = d3;
            default: y = 8'b0;
        endcase
    end
endmodule