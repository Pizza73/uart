`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/04 13:01:06
// Design Name: 
// Module Name: uart_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_tb(
);
    reg     clk;
    reg     rst;
    reg     pulse;
    wire    done;
    wire    signal;
    reg     enable;
    reg     pulse_in;
    wire    pulse_out;
    // wire    test;
    // wire [2:0] counter;
    // wire [8:0] counter;
    // wire [7:0]  char_in;
    
    initial begin
        clk = 1'b0;
        rst = 1'b1;
        pulse = 1'b0;
        // done = 1'b0;
        // signal = 1'b1;
        enable = 1'b1;
        pulse_in = 1'b0;
        // pulse_out = 1'b0;
    end

    always #1
    begin
        clk = ~clk;
        rst = 1'b0;
        pulse = 1'b0;
        // done = 1'b0;
        // signal = 1'b1;
        // enable = 1'b0;
        pulse_in = 1'b0;
        // pulse_out = 1'b0;
    end

    // always #50
    // begin
    //     // enable = 1'b1;
    // end

    always
    begin
        // pulse = 1'b0;
        // rst = 1'b0;
        // // done = 1'b0;
        // // signal = 1'b1;
        // enable = 1'b1;
        // pulse_in = 1'b0;
        // // pulse_out = 1'b0;
        #10
        $display("enable simulation\n");
        $display("initial data\n");
        $display("\"clk\" is %d\n", clk);
        $display("\"rst\" is %d\n", rst);
        $display("\"data\" is %02d\n", signal);
        // enable = 1'b1;
        
        #1
        rst = 1'b0;
        
        #5
        $display("\"clk\" is %d\n", clk);
        $display("\"rst\" is %d\n", rst);
        $display("\"data\" is %02d\n", signal);

        #10000000
        $finish;
    end

    
    
    gen_pulse   gen_pulse1(.clk(clk), .rst(rst), .pulse(pulse_out));  
    uart_send uart_send(
        .clk(clk), 
        .rst(rst), 
        .pulse(pulse_out),
        .character(8'b01100100),
        .enable(enable),
        .signal(signal),
        .done(done)
    );
    // test test1(.clk(clk), .rst(rst), .counter(counter));
    

endmodule