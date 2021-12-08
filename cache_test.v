`timescale 1ns / 1ps

module tb_cache;
    reg          clock;
    
    // interface between cache and CPU
    wire         read_write_cache; /* 1 if write, 0 if read */
    wire [13:0]   address_cache;
    wire [31:0]  write_data_cache;
    // interface between cache and main memory
    wire [31:0]  read_data_cache_db;
    wire pg_fault;
    
    top   cache_db(read_write_cache, address_cache, write_data_cache, hit_miss_db, pg_fault, read_data_cache_db);
    CPU                 CPU_db(hit_miss_db, clock, read_write_cache, address_cache, write_data_cache);
    always #5 clock = ~clock;
    

    always @(negedge clock) begin
        $display("============================================");
        $display("Request Number: %d", CPU_db.request_num);
        $display("addr = 0x%b", address_cache);
        $display("addr = 0x%b", cache_db.P_addr);
        $display("hit = %b", hit_miss_db);
        $display("Read_data = 0x%h", read_data_cache_db);
        $display("pg_fault = %b", pg_fault);
        $display("--------------------------------------------");
        $display("TLB:");
        $display("TLB[0]: tags:%b  V: %b  D: %b  R: %b  P.addr = %b", cache_db.tlb.tags[0], cache_db.tlb.entry[0][31], cache_db.tlb.entry[0][30], cache_db.tlb.entry[0][29], cache_db.tlb.entry[0][1:0]);
        $display("TLB[1]: tags:%b  V: %b  D: %b  R: %b  P.addr = %b", cache_db.tlb.tags[1], cache_db.tlb.entry[1][31], cache_db.tlb.entry[1][30], cache_db.tlb.entry[1][29], cache_db.tlb.entry[1][1:0]);
        $display("TLB[2]: tags:%b  V: %b  D: %b  R: %b  P.addr = %b", cache_db.tlb.tags[2], cache_db.tlb.entry[2][31], cache_db.tlb.entry[2][30], cache_db.tlb.entry[2][29], cache_db.tlb.entry[2][1:0]);
        $display("TLB[3]: tags:%b  V: %b  D: %b  R: %b  P.addr = %b", cache_db.tlb.tags[3], cache_db.tlb.entry[3][31], cache_db.tlb.entry[3][30], cache_db.tlb.entry[3][29], cache_db.tlb.entry[3][1:0]);
        $display("--------------------------------------------");
        $display("--------------------------------------------");
        $display("cache[1]:");
        $display("Tag: %b", cache_db.Cache.tags[0]);
        $display("word[0] = 0x%h   word[1] = 0x%h", cache_db.Cache.word[0][0], cache_db.Cache.word[1][0]);
        $display("word[2] = 0x%h   word[3] = 0x%h", cache_db.Cache.word[2][0], cache_db.Cache.word[3][0]);
        $display("--------------------------------------------");
        $display("cache[2]:");
        $display("Tag: %b", cache_db.Cache.tags[1]);
        $display("word[0] = 0x%h   word[1] = 0x%h", cache_db.Cache.word[0][1], cache_db.Cache.word[1][1]);
        $display("word[2] = 0x%h   word[3] = 0x%h", cache_db.Cache.word[2][1], cache_db.Cache.word[3][1]);
        $display("--------------------------------------------");
        // $display("cache[3]:");
        // $display("Tag: %b", cache_db.Cache.tags[2]);
        // $display("word[0] = 0x%h   word[1] = 0x%h", cache_db.Cache.word[0][2], cache_db.Cache.word[1][2]);
        // $display("word[2] = 0x%h   word[3] = 0x%h", cache_db.Cache.word[2][2], cache_db.Cache.word[3][2]);
        // $display("--------------------------------------------");
        // $display("cache[4]:");
        // $display("Tag: %b", cache_db.Cache.tags[3]);
        // $display("word[0] = 0x%h   word[1] = 0x%h", cache_db.Cache.word[0][3], cache_db.Cache.word[1][3]);
        // $display("word[2] = 0x%h   word[3] = 0x%h", cache_db.Cache.word[2][3], cache_db.Cache.word[3][3]);
        // $display("--------------------------------------------");
        $display("Main Memory:");
        $display("memo[104] = 0x%h   memo[105] = 0x%h", cache_db.Main_Memory.memory[104], cache_db.Main_Memory.memory[105]);
        $display("memo[106] = 0x%h   memo[107] = 0x%h", cache_db.Main_Memory.memory[106], cache_db.Main_Memory.memory[107]);
        $display("============================================");
    end

    initial begin
        clock = 0;
        #300 $stop;
    end
endmodule
