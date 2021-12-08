`timescale 1ns / 1ps


module page_tb (
    input [5:0] vpn,
    input [1:0] dirty_ref,
    input write,
    output pg_fault,
    output [31:0] ppn
);


// 6-bit virtual page number
// 2^6 = 64 lines of page table
reg [31:0] line[63:0];

// reg [15:0] valid;     // valid bit
// reg [15:0] dirty;     // dirty bit
// reg [15:0] ref;       // ref bit


integer i;
initial begin
    for(i = 0; i < 64; i = i + 1) begin
        line[i] = 32'h00000000;
    end
    line[0][31] = 1'b1;
    line[0][30] = 1'b0;
    line[0][1:0] = 2'b00;

    line[1][31] = 1'b1;
    line[1][30] = 1'b0;
    line[1][1:0] = 2'b01;


    line[2][31] = 1'b1;
    line[2][30] = 1'b0;
    line[2][1:0] = 2'b10;

    line[3][31] = 1'b1;
    line[3][30] = 1'b0;
    line[3][1:0] = 2'b11;

    line[4][31] = 1'b1;
    line[4][30] = 1'b0;
    line[4][1:0] = 2'b00;

    line[5][31] = 1'b1;
    line[5][30] = 1'b0;
    line[5][1:0] = 2'b01;

end

assign pg_fault = (line[vpn][31] == 1'b0);

assign ppn = (^vpn !== 1'bx) ? line[vpn][31:0] : 32'b0;

always @(*) begin
    if(write == 1'b1) begin
        line[vpn][30:29] = dirty_ref;
    end
    else ;
end
    
endmodule
