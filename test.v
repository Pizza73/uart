`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/07 06:22:28
// Design Name: 
// Module Name: test
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

module gen_pulse#(parameter CNT_ONE_BPS = 868 - 1)(
    input   wire    clk,
    input   wire    rst, 
    output  wire    pulse,
    output  wire    test, 
    output  wire [9:0]  counter
);
    // reg         [$clog2(CNT_ONE_BPS)-1:0]  ctr_500_bps_reg = 0;
    reg         [9:0]  ctr_500_bps_reg = 0;
    // wire        [$clog2(CNT_ONE_BPS)-1:0]  ctr_500_bps_in;
    
    reg         pulse_reg = 0;
    reg         test_reg = 0;
    
    always@(posedge clk)begin
        case(rst)
            1'b0: begin
                ctr_500_bps_reg = ctr_500_bps_reg + 1;
                test_reg = ~test_reg;
            end 
            1'b1: begin
                test_reg = 0;
                ctr_500_bps_reg = 0;
            end
            default: ctr_500_bps_reg = ctr_500_bps_reg + 1; 
        endcase
        // if(rst)begin
        //     ctr_500_bps_reg = 0;
        // end
        // else begin
        //     ctr_500_bps_reg = ctr_500_bps_reg + 1;
        // end

        // if(ctr_500_bps_reg == 10'b1101100100)begin
        if(ctr_500_bps_reg == 10'b0000100000)begin
            pulse_reg = 1;
            ctr_500_bps_reg = 0;
        end
        else begin
            pulse_reg = 0;
        end

        // pulse_reg = (ctr_500_bps_reg == CNT_ONE_BPS)? 1 : 0;
        // pulse_reg = (ctr_500_bps_reg == 868)? 1 : 0;
    end
    
    assign pulse = pulse_reg;
    assign test = test_reg;
    assign counter = ctr_500_bps_reg;
endmodule

module uart_send (
    input   wire            clk, 
    input   wire            rst, 
    input   wire            pulse,
    input   wire    [7:0]   character,
    input   wire            start,
    output  wire            signal,
    output  wire            done
);
    reg         signal_reg;
    reg [2:0]   word_counter;
    
    always@(posedge clk)begin
        case(rst)
            1'b0: begin
                signal_reg = character; 
            end
            1'b1: begin
                signal_reg = 1;
                word_counter <= 3'b0; 
            end
            default: signal_reg = character[word_counter];
        endcase
        
        case(pulse)
//        1'b0: begin
//            signal_reg = signal_reg;
//        end
        1'b1: begin
             signal_reg = signal_reg;
             word_counter = (word_counter + 1) & 3'b111;
        end
        endcase 
    end
    assign signal = signal_reg;
endmodule 



module top(
    input                   CLK100MHZ,
    input                   CPU_RESETN,
    output                  UART_TXD_IN,
    output                  UART_RXD_OUT
);
    wire    pulse;
    wire    done;
    wire    start;
    
    gen_pulse   gen_pulse1(.clk(CLK100MHZ), .rst(CPU_RESETN), .pulse(pulse));  
    // uart_send (.clk(CLK100MHZ), .rst(CPU_RESETN), .pulse(pulse), .signal(LED[0]), .done(done));
    uart_send uart_send1(
        .clk(CLK100MHZ), 
        .rst(CPU_RESETN), 
        .pulse(pulse),
        .character(8'b01100100),
        .start(start),
        .signal(UART_TXD_IN),
        .done(done)
    );
    
endmodule