
`timescale 1ns/1ps
`include "uart_tx_module.v"

// -----------------------------------------------------------------------------
// I/O interface: maps switches->leds and exposes a simple UART TX
// -----------------------------------------------------------------------------
module io_interface
#(
    parameter integer CLKS_PER_BIT = 16
)
(
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  switches,   // Entradas (switches)
    output wire [7:0]  leds,       // Salidas (LEDs)
    input  wire        uart_start, // Pulso de inicio de transmisión
    input  wire [7:0]  uart_data,  // Byte a transmitir
    output wire        uart_tx,    // TX serial
    output wire        uart_busy   // Señal de ocupado (útil para test/síntesis)
);

    // Mapeo directo de entradas a salidas
    assign leds = switches;

    // UART TX
    uart_tx_module #(.CLKS_PER_BIT(CLKS_PER_BIT)) uart_tx_i (
        .clk   (clk),
        .rst_n (rst_n),
        .start (uart_start),
        .data  (uart_data),
        .tx    (uart_tx),
        .busy  (uart_busy)
    );

endmodule
