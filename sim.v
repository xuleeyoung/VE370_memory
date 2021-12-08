//
//
//
module testbench (
);

    reg write;
    reg [9:0] addr;
    reg [31:0] W_data;

    wire [31:0] R_data;
    wire hit;

    top UUT(write, addr, W_data, hit, R_data);

    initial begin
        #0 write = 0; addr = 10'b0000011100;
        // Load word at 0000_01_11_00:  should miss
        // cache block: 01       word number: 11
        // Read block[1] (word[4-7]) from main memory to cache block 1
        // Read cache[1] word[3] back to CPU
        #20 $display("============================================");
            $display("hit = %b", hit);
            $display("cache[1]:");
            $display("Tag: %b", UUT.Cache.tags[1]);
            $display("word[0] = 0x%h   word[1] = 0x%h", UUT.Cache.word[0][1], UUT.Cache.word[1][1]);
            $display("word[2] = 0x%h   word[3] = 0x%h", UUT.Cache.word[2][1], UUT.Cache.word[3][1]);
            $display("--------------------------------------------");
            $display("Read_data_out = 0x%h", R_data);
            $display("============================================");


        #20 write = 1; addr = 10'b0000011000; W_data = 32'hffffffff;
        // Store word at 0000_01_10_00:  should hit
        // cache block: 01         word number: 10
        // Overwrite cache[1] word[2] in cache
        // Notice that now main memory [4-7] not changed
        #20 $display("============================================");
            $display("hit = %b", hit);
            $display("cache[1]:");
            $display("Tag: %b", UUT.Cache.tags[1]);
            $display("word[0] = 0x%h   word[1] = 0x%h", UUT.Cache.word[0][1], UUT.Cache.word[1][1]);
            $display("word[2] = 0x%h   word[3] = 0x%h", UUT.Cache.word[2][1], UUT.Cache.word[3][1]);
            $display("--------------------------------------------");
            $display("main memory:");
            $display("memory[4] = 0x%h   memory[5] = 0x%h", UUT.Main_Memory.memory[4], UUT.Main_Memory.memory[5]);
            $display("memory[6] = 0x%h   memory[7] = 0x%h", UUT.Main_Memory.memory[6], UUT.Main_Memory.memory[7]);
            $display("============================================");


        #20 write = 0; addr = 10'b1100011101;
        // Load word at 1100_01_11_01:  should miss (tag not match)
        // cache block: 01          word number: 11
        // Write cache[1] word[4-7] back to main memory: main memory [4-7] changed now
        // Read block[49] (word[196-199]) from main memory to cache block 1
        // Read cache[1] word[3] back to CPU
        #20 $display("============================================");
            $display("hit = %b", hit);
            $display("cache[1]:");
            $display("Tag: %b", UUT.Cache.tags[1]);
            $display("word[0] = 0x%h   word[1] = 0x%h", UUT.Cache.word[0][1], UUT.Cache.word[1][1]);
            $display("word[2] = 0x%h   word[3] = 0x%h", UUT.Cache.word[2][1], UUT.Cache.word[3][1]);
            $display("--------------------------------------------");
            $display("main memory:");
            $display("memory[4] = 0x%h   memory[5] = 0x%h", UUT.Main_Memory.memory[4], UUT.Main_Memory.memory[5]);
            $display("memory[6] = 0x%h   memory[7] = 0x%h", UUT.Main_Memory.memory[6], UUT.Main_Memory.memory[7]);
            $display("--------------------------------------------");
            $display("Read_data_out = 0x%h", R_data);
            $display("============================================");


        #20 write = 1; addr = 10'b0000001000; W_data = 32'h00000000;
        // Store word at 0000_00_10_00:  should miss (Not Valid)
        // cache block: 00         word number: 10
        // Read block[0] (word[0-3]) from main memory to cache block 0
        // Overwrite cache[0] word[2] in cache
        // Notice that now main memory [0-3] not changed
        #20 $display("============================================");
            $display("hit = %b", hit);
            $display("cache[0]:");
            $display("Tag: %b", UUT.Cache.tags[0]);
            $display("word[0] = 0x%h   word[1] = 0x%h", UUT.Cache.word[0][0], UUT.Cache.word[1][0]);
            $display("word[2] = 0x%h   word[3] = 0x%h", UUT.Cache.word[2][0], UUT.Cache.word[3][0]);
            $display("--------------------------------------------");
            $display("main memory:");
            $display("memory[0] = 0x%h   memory[1] = 0x%h", UUT.Main_Memory.memory[0], UUT.Main_Memory.memory[1]);
            $display("memory[2] = 0x%h   memory[3] = 0x%h", UUT.Main_Memory.memory[2], UUT.Main_Memory.memory[3]);
            $display("============================================");


        #20 write = 1; addr = 10'b0000010010; W_data = 32'h66666666;
        // Store word at 0000_01_00_10:  should miss (Tag not match)
        // cache block: 01          word number: 00
        // Read block[1] (word[4-7]) from main memory to cache directly (Not dirty)
        // Overwrite cache[1] word[0] in cache
        // Notice that now main memory [4-7] not changed
        #20 $display("============================================");
            $display("hit = %b", hit);
            $display("cache[1]:");
            $display("Tag: %b", UUT.Cache.tags[1]);
            $display("word[0] = 0x%h   word[1] = 0x%h", UUT.Cache.word[0][1], UUT.Cache.word[1][1]);
            $display("word[2] = 0x%h   word[3] = 0x%h", UUT.Cache.word[2][1], UUT.Cache.word[3][1]);
            $display("--------------------------------------------");
            $display("main memory:");
            $display("memory[196] = 0x%h   memory[197] = 0x%h", UUT.Main_Memory.memory[196], UUT.Main_Memory.memory[197]);
            $display("memory[198] = 0x%h   memory[199] = 0x%h", UUT.Main_Memory.memory[198], UUT.Main_Memory.memory[199]);
            $display("memory[4] = 0x%h   memory[5] = 0x%h", UUT.Main_Memory.memory[4], UUT.Main_Memory.memory[5]);
            $display("memory[6] = 0x%h   memory[7] = 0x%h", UUT.Main_Memory.memory[6], UUT.Main_Memory.memory[7]);
            $display("============================================");
        
        
        
        // #20 $display("Read_data_out = 0x%h", R_data);

        // #20 $display("=========================");
        //     $display("cache[0]: word[0] = 0x%h, word[1] = 0x%h, word[2] = 0x%h, word[3] = 0x%h, tags[0] = 0x%b", UUT.Cache.word[0][0], UUT.Cache.word[1][0], UUT.Cache.word[2][0], UUT.Cache.word[3][0], UUT.Cache.tags[0]);
        //     $display("=========================");
        //     $display("main memory[0] = 0x%h, memory[1] = 0x%h, memory[2] = 0x%h, memory[3] = 0x%h", UUT.Main_Memory.memory[0], UUT.Main_Memory.memory[1], UUT.Main_Memory.memory[2], UUT.Main_Memory.memory[3]);
        //     $display("=========================");


        // #20 write = 1; addr = 10'b1100001100; W_data = 32'haaaabbbb;
        // #20 $display("=========================");
        //     $display("cache[0]: word[0] = 0x%h, word[1] = 0x%h, word[2] = 0x%h, word[3] = 0x%h, tags[0] = 0x%b", UUT.Cache.word[0][0], UUT.Cache.word[1][0], UUT.Cache.word[2][0], UUT.Cache.word[3][0], UUT.Cache.tags[0]);
        //     $display("=========================");
        //     $display("main memory[0] = 0x%h, memory[1] = 0x%h, memory[2] = 0x%h, memory[3] = 0x%h", UUT.Main_Memory.memory[0], UUT.Main_Memory.memory[1], UUT.Main_Memory.memory[2], UUT.Main_Memory.memory[3]);
        //     $display("=========================");
        #20 $stop;
    end 

endmodule