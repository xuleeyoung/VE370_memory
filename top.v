`timescale 1ns / 1ps
//
//
//
module top (
    input write,
    input [13:0] addr,
    input [31:0] W_data,
    output hit,
    output pg_fault,
    output [31:0] R_data
);
    
    wire write_to_mem;
    wire tlb_hit;
    // wire cache_hit;
    wire read_write;
    wire write_pg;
    wire pg_fault_tb;
    wire [1:0] dirty_ref;
    wire [5:0] read_vpn;
    wire [9:0] P_addr;
    wire [31:0] tlb_pg_tb;
    wire [9:0] addr_to_mem;
    wire [31:0] Write_to_mem;
    wire [31:0] Read_from_mem;
    wire done;

    // and(hit, cache_hit, tlb_hit);

    cache Cache(
        .done(done),
        .write_in(read_write),
        .addr_in(P_addr),
        .W_data_in(W_data),
        .R_data_in(Read_from_mem),
        .hit(hit),
        .write_out(write_to_mem),
        .addr_out(addr_to_mem),
        .W_data_out(Write_to_mem),
        .R_data_out(R_data)
    );

    main_memory Main_Memory(
        .write(write_to_mem),
        .addr(addr_to_mem),
        .W_data(Write_to_mem),
        .done(done),
        .R_data(Read_from_mem)
    );

    TLB tlb(
        .read_write(write),
        .V_addr(addr),
        .read_ppn(tlb_pg_tb),
        .pg_fault_tb(pg_fault_tb),
        .hit(tlb_hit),
        .read_write_tb(read_write),
        .write(write_pg),
        .pg_fault(pg_fault),
        .read_vpn(read_vpn),
        .P_addr(P_addr),
        .dirty_ref(dirty_ref)
    );


    page_tb Page_Table(
        .vpn(read_vpn),
        .dirty_ref(dirty_ref),
        .write(write_pg),
        .pg_fault(pg_fault_tb),
        .ppn(tlb_pg_tb)
    );

endmodule
