`timescale 1ns/1ps

module fpu_fma_tb;

    reg        clk;
    reg        rst_n;
    reg        valid_in;
    reg [31:0] A_in, B_in, C_in;

    wire       valid_out;
    wire [31:0] F_out;

    // Instantiate FPU-FMA
    fpu_fma_pipeline dut (
        .clk       (clk),
        .rst_n     (rst_n),
        .valid_in  (valid_in),
        .A_in      (A_in),
        .B_in      (B_in),
        .C_in      (C_in),
        .valid_out (valid_out),
        .F_out     (F_out)
    );

    // Clock gen
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Functions to create 32-bit floats from decimal (for quick tests)
    function [31:0] float2bits;
        input real val;
        reg [31:0] bits;
        begin
            bits = $realtobits(val);
            float2bits = bits;
        end
    endfunction

    // Convert bits to real (for printing)
    function real bits2float;
        input [31:0] bits;
        real r;
        begin
            // Same disclaimers as above
            r = $bitstoreal(bits);
            bits2float = r;
        end
    endfunction

    // Stimulus
    integer i;
    initial begin
        rst_n = 0;
        valid_in = 0;
        A_in = 0; B_in = 0; C_in = 0;

        #20; 
        rst_n = 1;

        // Example 1: (1.5 * 2.5) + 3.0 = 3.75 + 3.0 = 6.75
        @(posedge clk);
        valid_in <= 1;
        A_in     <= float2bits(1.5);
        B_in     <= float2bits(2.5);
        C_in     <= float2bits(3.0);

        // Example 2: (10.0 * -0.5) + 100.0 = -5 + 100 = 95
        @(posedge clk);
        A_in     <= float2bits(10.0);
        B_in     <= float2bits(-0.5);
        C_in     <= float2bits(100.0);

        // Example 3: (0.25 * 0.25) + 0.25 = 0.3125
        @(posedge clk);
        A_in     <= float2bits(0.25);
        B_in     <= float2bits(0.25);
        C_in     <= float2bits(0.25);

        // No more inputs
        @(posedge clk);
        valid_in <= 0;

        // Let pipeline flush
        repeat(10) @(posedge clk);

        $finish;
    end

    // Monitor the output
    always @(posedge clk) begin
        if(valid_out) begin
            $display("TIME=%t | F_out=%f (bits=%h)", 
               $time, bits2float(F_out), F_out);
        end
    end

    // Wave dump
    initial begin
        $dumpfile("fpu_fma.vcd");
        $dumpvars(0, fpu_fma_tb);
    end

endmodule
