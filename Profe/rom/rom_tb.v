`timescale 1ns / 1ps
`include "rom.v"
module tb_rom_custom;
  reg [3:0] addr;
  wire [7:0] data_out;

  rom_custom rom_inst(addr, data_out);

  initial begin
    $dumpfile("rom_custom.vcd");
    $dumpvars(0, tb_rom_custom);

    addr = 0; #10;
    addr = 1; #10;
    addr = 2; #10;
    addr = 3; #10;
    addr = 4; #10;
    addr = 5; #10;
    addr = 6; #10;
    addr = 7; #10;

    $finish;
  end

endmodule
