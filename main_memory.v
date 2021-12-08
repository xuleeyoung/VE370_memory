`timescale 1ns / 1ps
//
//
//
module main_memory (
    input write,
    input [9:0] addr,
    input [31:0] W_data,
    output reg done,
    output [31:0] R_data
);
    

    reg [31:0] memory[8'b11111111:0];

    integer i;
    initial begin
        memory[0] = 32'hffabffba;
        memory[1] = 32'hffccffcc;
        memory[2] = 32'hffcdffdc;
        memory[3] = 32'hffadffda;
        memory[4] = 32'h00ffaabb;
        memory[5] = 32'hff00ccdd;
        memory[6] = 32'h00cc2299;
        memory[7] = 32'hff00bbaa;
        for(i=8; i<256; i=i+1) begin
            memory[i] = 32'b0;
    end
        memory[104] = 32'habcdabcd;
        memory[105] = 32'hbcdebcde;
        memory[106] = 32'hcdefcdef;
        memory[107] = 32'h12345678;
    end
    wire [7:0] index;

    assign index = addr[9:2];

    assign R_data = (write) ? 32'h0 : memory[index];

    always @(*) begin
        // $display("Index = %d", index);
        if(write == 1'b1) begin
            memory[index] = W_data;
        end
        else ;
    end

endmodule