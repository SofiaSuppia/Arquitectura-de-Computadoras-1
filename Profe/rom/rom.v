module rom_custom(
  input [3:0] addr,
  output reg [7:0] data_out
);

  reg [7:0] mem [0:15];

  initial begin
    mem[0] = 8'hAA;
    mem[1] = 8'hBB;
    mem[2] = 8'hCC;
    mem[3] = 8'hDD;
    mem[4] = 8'hEE;
    mem[5] = 8'hFF;
    mem[6] = 8'h11;
    mem[7] = 8'h22;
    mem[8] = 8'h33;
    mem[9] = 8'h44;
    mem[10] = 8'h55;
    mem[11] = 8'h66;
    mem[12] = 8'h77;
    mem[13] = 8'h88;
    mem[14] = 8'h99;
    mem[15] = 8'h00;
  end

  always @(*) begin
    data_out = mem[addr];
  end

endmodule
