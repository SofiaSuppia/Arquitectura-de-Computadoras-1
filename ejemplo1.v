module or_gate (
    input wire A, //entrada a
    input wire B, //entrada b
    output wire Y, //salida y
);

assign Y = A | B;  //implementacion de la compuerta

endmodule