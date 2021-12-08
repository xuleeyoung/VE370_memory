`timescale 1ns / 1ps


module TLB (
    input read_write,
    input [13:0] V_addr,
    input [31:0] read_ppn,
    input pg_fault_tb,
    output reg hit,
    output reg read_write_tb,
    output reg write,
    output pg_fault,
    output reg [5:0] read_vpn,
    output reg [9:0] P_addr,
    output reg [1:0] dirty_ref
);

reg [31:0] entry[3:0];
reg [1:0] index;
reg [1:0] left;
reg [1:0] right;
reg [5:0] tags[3:0];
reg [3:0] LRU[3:0];
reg [5:0] vpn;

integer i;
initial begin
    for(i=0;i<4;i=i+1) begin
        entry[i] = 32'b0;
        tags[i] = 6'b0;
        LRU[i] = 4'b0;
    end
end


assign pg_fault = pg_fault_tb;
// assign hit = ((entry[0][31] == 1'b1) && (tags[0] == vpn)) || 
//              ((entry[1][31] == 1'b1) && (tags[1] == vpn)) ||
//              ((entry[2][31] == 1'b1) && (tags[2] == vpn)) ||
//              ((entry[3][31] == 1'b1) && (tags[3] == vpn));


always @(*) begin
    vpn = V_addr[13:8];
    
    if(((entry[0][31] == 1'b1) && (tags[0] == V_addr[13:8])) || 
             ((entry[1][31] == 1'b1) && (tags[1] == V_addr[13:8])) ||
             ((entry[2][31] == 1'b1) && (tags[2] == V_addr[13:8])) ||
             ((entry[3][31] == 1'b1) && (tags[3] == V_addr[13:8]))) begin
        hit = 1'b1;
    end
    else begin
        hit = 1'b0;
    end
    #1
    // $display("addr_in = %b", V_addr);
    // $display("vpn = %b", vpn);
    // $display("hit = %b", hit);
    // $display("entry[2] = %b", entry[2]);
    // $display("tags[0] = %b", tags[0]);
    if(hit == 1'b0) begin
        // if(entry[0][31] == 1'b0) begin
        //     index = 2'b00;
        // end
        // else if(entry[1][31] == 1'b0) begin
        //     index = 2'b01;
        // end
        // else if(entry[2][31] == 1'b0) begin
        //     index = 2'b10;
        // end
        // else if(entry[3][31] == 1'b0) begin
        //     index = 2'b11;
        // end
        // else begin
        //     index = 2'b00;
        // end
        if(LRU[1] < LRU[0]) begin
            left = 2'b01;
        end
        else begin
            left = 2'b00;
        end
        if(LRU[3] < LRU[2]) begin
            right = 2'b11;
        end
        else begin
            right = 2'b10;
        end
        
        #1
        if(LRU[right] < LRU[left]) begin
            index = right;
        end
        else begin
            index = left;
        end
        #1
        $display("INDEX = %b", index);
        if(entry[index][30] == 1'b1) begin
            write = 1'b1;
            read_vpn = tags[index];
            dirty_ref = entry[index][30:29];
        end
        else ;
        // $display("HERE");
        #1
        write = 1'b0;
        read_vpn = vpn;
        // $display("READ_VPN = %b", read_vpn);
        #1
        // $display("READ_PPN = %b", read_ppn);
        entry[index][31:0] = read_ppn;
        tags[index] = vpn;
    end

    #1
    if(tags[0] == vpn) begin
        index = 2'b00;
    end
    else if(tags[1] == vpn) begin
        index = 2'b01;
    end
    else if(tags[2] == vpn) begin
        index = 2'b10;
    end
    else if(tags[3] == vpn) begin
        index = 2'b11;
    end
    else ;
    #1

    
    // $display("index = %b", index);
    entry[index][29] = 1'b1;
    if(entry[index][31] == 1'b1) begin
        LRU[index] = LRU[index] + 1;
    end
    if(read_write == 1'b1) begin
        entry[index][30] = 1'b1;
    end
    read_write_tb = read_write;
    P_addr = {entry[index][1:0], V_addr[7:0]};
    // $display("PADDR = %b", P_addr);
    

end
endmodule
