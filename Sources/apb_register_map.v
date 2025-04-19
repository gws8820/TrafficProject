`timescale 1ns / 1ps

module apb_register_map(
    input pclk, presetn,
    input [31:0] paddr,
    input psel, penable,
    input pwrite,
    input [31:0] pwdata,
    output reg pready,
    output reg [31:0] prdata,
    output reg pslverr
);

    reg [7:0] memory [63:0];
    
    wire [31:0] prefix_addr; 
    wire [5:0] rel_addr;
    
    assign prefix_addr = { paddr[31:6], 6'b000000 };
    assign rel_addr = paddr[5:0];
    
    reg second_cycle;
    
    always@(posedge pclk) begin
        if(!presetn) begin
            pready <= 0;
            pslverr <= 0;
        
            memory[63] <= 0; memory[62] <= 0; memory[61] <= 0; memory[60] <= 0;
            memory[59] <= 0; memory[58] <= 0; memory[57] <= 0; memory[56] <= 0;
            memory[55] <= 0; memory[54] <= 0; memory[53] <= 0; memory[52] <= 0;
            memory[51] <= 0; memory[50] <= 0; memory[49] <= 0; memory[48] <= 0;
            memory[47] <= 0; memory[46] <= 0; memory[45] <= 0; memory[44] <= 0;
            memory[43] <= 0; memory[42] <= 0; memory[41] <= 0; memory[40] <= 0;
            memory[39] <= 0; memory[38] <= 0; memory[37] <= 0; memory[36] <= 0;
            memory[35] <= 0; memory[34] <= 0; memory[33] <= 0; memory[32] <= 0;
            memory[31] <= 0; memory[30] <= 0; memory[29] <= 0; memory[28] <= 0;
            memory[27] <= 0; memory[26] <= 0; memory[25] <= 0; memory[24] <= 0;
            memory[23] <= 0; memory[22] <= 0; memory[21] <= 0; memory[20] <= 0;
            memory[19] <= 0; memory[18] <= 0; memory[17] <= 0; memory[16] <= 0;
            memory[15] <= 0; memory[14] <= 0; memory[13] <= 0; memory[12] <= 0;
            memory[11] <= 0; memory[10] <= 0; memory[9] <= 0; memory[8] <= 0;
            memory[7] <= 0; memory[6] <= 0; memory[5] <= 0; memory[4] <= 0;
            memory[3] <= 0; memory[2] <= 0; memory[1] <= 0; memory[0] <= 0;
        end
        else begin
            if(psel && paddr) begin
                if(!penable) begin // First Cycle
                    if(prefix_addr != 32'h1000_2000) begin // Wrong Address
                        pready <= 1;
                        pslverr <= 1; // Error Signal
                    end
                    else pready <= 1;
                end
                
                else if (pready) begin // Second Cycle
                    if(pwrite) begin
                        if(pslverr) begin end
                        else begin
                            memory[rel_addr] <= pwdata[31:24];
                            memory[rel_addr + 1] <= pwdata[23:16];
                            memory[rel_addr + 2] <= pwdata[15:8];
                            memory[rel_addr + 3] <= pwdata[7:0];
                        end                         
                    end
                    else begin
                        prdata[31:24] <= memory[rel_addr];
                        prdata[23:16] <= memory[rel_addr + 1];
                        prdata[15:8] <= memory[rel_addr + 2];
                        prdata[7:0] <= memory[rel_addr + 3];
                    end
                    
                    pready <= 0;
                    pslverr <= 0;
                end
                
                else begin end
            end
            begin end
        end
    end
endmodule
