`timescale 1ns / 1ps

module CPU (
    input  hit_miss,
    input  clock,
    output read_write,
    output [13:0] address,
    output [31:0] write_data
);
    parameter  request_total = 12; // change this number to how many requests you want in your testbench
    reg [4:0]  request_num;
    reg        read_write_test[request_total-1:0];
    reg [13:0]  address_test[request_total-1:0];
    reg [31:0] write_data_test[request_total-1:0]; 
    initial begin
        #10 request_num = 0;
        read_write_test[0] = 0; address_test[0] = 14'b00000110101001; write_data_test[0] = 0;
        // read at 106(read byte 1), miss, load from main mem
        read_write_test[1] = 1; address_test[1] = 14'b00000110100001; write_data_test[1] = 32'h000000ac;
        // write at 105(write byte 1), hit
        read_write_test[2] = 1; address_test[2] = 14'b00000110101100; write_data_test[2] = 32'hffffffac;
        // write at 107(write word), hit

        read_write_test[3] = 1; address_test[3] = 14'b00001111100100; write_data_test[3] = 32'hffffffac;
        // read at 01111001(read word), miss, load from main mem


        read_write_test[4] = 0; address_test[4] = 14'b00000111001000; write_data_test[4] = 0;
        // read at 01011001(read word), miss, load from main mem, replace tag(01101)(LRU)

        read_write_test[5] = 0; address_test[5] = 14'b00001010100101; write_data_test[5] = 0;
        // read at 104(read byte 1), miss, load from main mem, replace tag(01111)(LRU)

        read_write_test[6] = 0; address_test[6] = 14'b00000010100101; write_data_test[6] = 0;


        read_write_test[7] = 1; address_test[7] = 14'b00000110100101; write_data_test[7] = 32'haabbccdd;

        read_write_test[8] = 1; address_test[8] = 14'b00010010100100; write_data_test[8] = 32'haabbccdd;

        read_write_test[9] = 1; address_test[9] = 14'b00000010101111; write_data_test[9] = 32'haabbccaa;

        read_write_test[10] = 0; address_test[10] = 14'b00001111001000; write_data_test[10] = 0;

        read_write_test[11] = 0; address_test[11] = 14'b10000111001000; write_data_test[11] = 0;

        
        

        // read_write_test[6] = 1; address_test[6] = 10'b0110100001; write_data_test[6] = 32'haabbccdd;
        // // write at 104, hit, dirty
        // read_write_test[7] = 0; address_test[7] = 10'b1110101001; write_data_test[7] = 0;
        // // read at 11101010, write back, replace

        /* add lines if necessary */
        
        
    end
    always @(posedge clock) begin
        if (hit_miss == 1) request_num = request_num + 1;
        else request_num = request_num;
    end
    assign address      = address_test[request_num];
    assign read_write   = read_write_test[request_num];
    assign write_data   = write_data_test[request_num]; 
endmodule
