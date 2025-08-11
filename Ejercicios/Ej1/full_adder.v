/*Diseñe un módulo en Verilog que implemente un sumador completo de un bit con entradas a,b y
cin(carry in), y salidas sum y cout (carry out). Describir y simular con Icarus Verilog + GTKWave.*/

module full_adder(
  input a,
  input b,
  input cin,
  output sum,
  output carry
);

assign sum = a ^ b ^ cin;                         // suma: XOR de a, b y cin
assign carry = (a & b) | (b & cin) | (cin & a);  // carry: combinación de AND y OR

endmodule