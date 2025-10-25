//Flip flop d con reset asincrono activo en bajo
module flip_flop_D (
    input clk,
    input reset_n,
    input D,
    output reg Q
);  

    always @(posedge clk or negedge reset_n) begin  //Profe: always @(negedge clk or negedge reset_n) begin 
        if (!reset_n)       //Profe if (reset_n)
            Q <= 1'b0; 
        else
            Q <= D;

    end
endmodule