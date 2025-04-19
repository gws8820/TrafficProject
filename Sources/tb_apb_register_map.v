`timescale 1ns / 1ps

module tb_apb_register_map();
    reg pclk, presetn;
    reg [31:0] paddr;
    reg psel, penable;
    reg pwrite;
    reg [31:0] pwdata;
    wire pready;
    wire [31:0] prdata;
    wire pslverr;
    
    apb_register_map register(
        .pclk(pclk), .presetn(presetn),
        .paddr(paddr),
        .psel(psel), .penable(penable),
        .pwrite(pwrite),
        .pwdata(pwdata),
        .pready(pready),
        .prdata(prdata),
        .pslverr(pslverr)
    );
    
    parameter CLK_PERIOD = 10; // 100MHz
    always #(CLK_PERIOD/2) pclk = ~pclk;
    
    initial begin
        pclk = 0;
        presetn = 0;
        
        #(CLK_PERIOD * 20)
        presetn = 1;
        
        
        // Write Operation
        #(CLK_PERIOD * 10)
        psel = 1;
        pwrite = 1;
        paddr = 32'h1000_2008;
        pwdata = 32'h17_ae_05_06;
        penable = 0;
        #(CLK_PERIOD)
        penable = 1;
        
        #(CLK_PERIOD * 10)
        paddr = 32'h1000_2019;
        pwdata = 32'h0d_0a_40_11;
        penable = 0;
        #(CLK_PERIOD)
        penable = 1;
        
        #(CLK_PERIOD * 10)
        paddr = 32'h1000_201a;
        pwdata = 32'h32_15_00_08;
        penable = 0;
        #(CLK_PERIOD)
        penable = 1;
        
        #(CLK_PERIOD * 10)
        paddr = 32'h1000_202c;
        pwdata = 32'h07_11_1b_25;
        penable = 0;
        #(CLK_PERIOD)
        penable = 1;
        
        #(CLK_PERIOD * 10)
        paddr = 32'h1000_202c;
        pwdata = 32'h08_12_1c_26;
        penable = 0;
        #(CLK_PERIOD)
        penable = 1;
        
        #(CLK_PERIOD * 10)
        paddr = 32'h1000_2048;
        pwdata = 32'h0a_0a_0a_0a;
        penable = 0;
        #(CLK_PERIOD)
        penable = 1;
        
        
        // Read Operation
        #(CLK_PERIOD * 10)
        psel = 0;
        
        #(CLK_PERIOD * 10)
        psel = 1;
        pwrite = 0;
        paddr = 32'h1000_2000;
        penable = 0;
        #(CLK_PERIOD)
        penable = 1;
        
        #(CLK_PERIOD * 10)
        paddr = 32'h1000_2008;
        penable = 0;
        #(CLK_PERIOD)
        penable = 1;
        
        #(CLK_PERIOD * 10)
        paddr = 32'h1000_2006;
        penable = 0;
        #(CLK_PERIOD)
        penable = 1;
        
        #(CLK_PERIOD * 10)
        paddr = 32'h1000_2019;
        penable = 0;
        #(CLK_PERIOD)
        penable = 1;
        
        #(CLK_PERIOD * 10)
        paddr = 32'h1000_202c;
        penable = 0;
        #(CLK_PERIOD)
        penable = 1;
        
        #(CLK_PERIOD * 10)
        paddr = 32'h1000_2048;
        penable = 0;
        #(CLK_PERIOD)
        penable = 1;
        
        #(CLK_PERIOD * 20)
        $finish;
    end
    
endmodule
