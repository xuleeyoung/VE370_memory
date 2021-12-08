`timescale 1ns / 1ps
//
//
//
module cache (
    input done,
    input write_in,
    input [9:0] addr_in,
    input [31:0] W_data_in,
    input [31:0] R_data_in,
    output hit,
    output reg write_out,
    output reg [9:0] addr_out,
    output reg [31:0] W_data_out,
    output reg [31:0] R_data_out
);

reg [31:0] word[3:0][3:0];

reg [4:0] tags[3:0];
reg [3:0] Valid;
reg [3:0] Dirty;
reg [1:0] ref;

reg [1:0] index;
wire set_index;
wire [1:0] word_index;
wire [1:0] byte;

integer i;
initial begin
    for(i = 0; i < 3; i = i + 1) begin
        tags[i] = 5'b0;
        Valid[i] = 1'b0;
        Dirty[i] = 1'b0;
    end
    ref = 2'b0;
end


assign set_index = addr_in[4];        // set index in cache
assign word_index = addr_in[3:2];      // word index in a block
assign hit = ((set_index == 0) && (Valid[0] == 1) && (tags[0] == addr_in[9:5])) ||
             ((set_index == 0) && (Valid[1] == 1) && (tags[1] == addr_in[9:5])) ||
             ((set_index == 1) && (Valid[2] == 1) && (tags[2] == addr_in[9:5])) ||
             ((set_index == 1) && (Valid[3] == 1) && (tags[3] == addr_in[9:5]));
assign byte = addr_in[1:0];


always @(addr_in or write_in) begin
    $display("CACHE_ADDR_IN = %b", addr_in);
    #1
    $display("CACHE_ADDR_IN = %b", addr_in);
    $display("CACHE_HIT = %b", hit);
    
    if(hit == 1'b0) begin                             // cache miss
        if(set_index == 0) begin
            if(Valid[0] == 1'b0) begin
                index = 2'b00;
            end
            else if(Valid[1] == 1'b0) begin
                index = 2'b01;
            end
            else if(ref[0] == 1'b0) begin
                index = 2'b00;
            end
            else if(ref[0] == 1'b1) begin
                index = 2'b01;
            end
            else ;
        end
        else if(set_index == 1) begin
            if(Valid[2] == 1'b0) begin
                index = 2'b10;
            end
            else if(Valid[3] == 1'b0) begin
                index = 2'b11;
            end
            else if(ref[1] == 1'b0) begin
                index = 2'b10;
            end
            else if(ref[1] == 1'b1) begin
                index = 2'b11;
            end
            else ;
        end
        else ;
        #1
            // hit = 1'b0;
            if(Dirty[index] == 1'b1) begin     // if dirty
                // Write its previous data back to main memory
                #1
                addr_out = {tags[index], set_index, 2'b00, 2'b00};
                write_out = 1'b1;
                W_data_out = word[0][index];
                #1 
                addr_out = {tags[index], set_index, 2'b01, 2'b00};
                write_out = 1'b1;
                W_data_out = word[1][index];
                #1
                addr_out = {tags[index], set_index, 2'b10, 2'b00};
                write_out = 1'b1;
                W_data_out = word[2][index];
                #1
                addr_out = {tags[index], set_index, 2'b11, 2'b00};
                write_out = 1'b1;
                W_data_out = word[3][index];
            end
            else ;
            // Read data from main memory to cache block
            #1
            // $display("ADDR = 0x%h", addr_in);
            addr_out = {addr_in[9:5], set_index, 2'b00, 2'b00};
            // $display("addr_out = 0x%b", addr_out);
            write_out = 1'b0;
            // word[0][index] = R_data_in;
            #1
            // $display("read = 0x%h", R_data_in);
            word[0][index] = R_data_in;
            addr_out = {addr_in[9:5], set_index, 2'b01, 2'b00};
            // $display("addr_out = 0x%d", addr_out);
            write_out = 1'b0;
            // word[1][index] = R_data_in;
            // $display("read = 0x%h", R_data_in);
            #1
            word[1][index] = R_data_in;
            addr_out = {addr_in[9:5], set_index, 2'b10, 2'b00};
            write_out = 1'b0;
            // word[2][index] = R_data_in;
            #1
            word[2][index] = R_data_in;
            addr_out = {addr_in[9:5], set_index, 2'b11, 2'b00};
            write_out = 1'b0;
            // word[3][index] = R_data_in;
            #1
            word[3][index] = R_data_in;
            // hit = 1'b1;
            #1
            tags[index] = addr_in[9:5];
            // hit = 1'b1;
            Valid[index] = 1'b1;
            Dirty[index] = 1'b0;  // Mark dirty bit as "not dirty"
    end


    #1
    if(set_index == 1'b0) begin
        if(tags[0] == addr_in[9:5]) begin
            index = 2'b00;
            ref[0] = 1'b1;
        end
        else if(tags[1] == addr_in[9:5]) begin
            index = 2'b01;
            ref[0] = 1'b0;
        end
        else ;
    end
    else if(set_index == 1'b1) begin
        if(tags[2] == addr_in[9:5]) begin
            index = 2'b10;
            ref[1] = 1'b1;
        end
        else if(tags[3] == addr_in[9:5]) begin
            index = 2'b11;
            ref[1] = 1'b0;
        end
        else ;
    end
    else ;


    #1
    if(write_in == 1'b0) begin
        if(byte == 2'b00) begin 
            R_data_out = (write_in) ? 32'bx : word[word_index][index];
        end
        else if(byte == 2'b01) begin
            R_data_out = (write_in) ? 32'bx : {{24{word[word_index][index][23]}}, word[word_index][index][23:16]};
        end
        else if(byte == 2'b10) begin
            R_data_out = (write_in) ? 32'bx : {{24{word[word_index][index][15]}}, word[word_index][index][15:8]};
        end
        else begin
            R_data_out = (write_in) ? 32'bx : {{24{word[word_index][index][7]}}, word[word_index][index][7:0]};
        end


    end
    else begin
        Dirty[index] = 1'b1;
        
        
        if(byte == 2'b00) begin 
            word[word_index][index] = W_data_in;
        end
        else if(byte == 2'b01) begin
            word[word_index][index][23:16] = W_data_in[7:0];
        end
        else if(byte == 2'b10) begin
            word[word_index][index][15:8] = W_data_in[7:0];
        end
        else begin
            word[word_index][index][7:0] = W_data_in[7:0];
        end
    end
end


    
endmodule
