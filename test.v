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
    output  wire    pulse
);
    reg         [$clog2(CNT_ONE_BPS)-1:0]  ctr_500_bps_reg = 0;
    reg         pulse_reg = 0;
    
    always@(posedge clk)begin
        case(rst)
            1'b0: begin
                ctr_500_bps_reg = ctr_500_bps_reg + 1;
            end 
            1'b1: begin
                ctr_500_bps_reg = 0;
            end
            default: ctr_500_bps_reg = ctr_500_bps_reg + 1; 
        endcase

        if(ctr_500_bps_reg == 10'b0000001000)begin
        // if(ctr_500_bps_reg == 10'b1101100100)begin
            pulse_reg = 1;
            ctr_500_bps_reg = 0;
        end
        else begin
            pulse_reg = 0;
        end

        // pulse_reg = (ctr_500_bps_reg == CNT_ONE_BPS)? 1 : 0;
    end
    
    assign pulse = pulse_reg;
endmodule

module uart_send (
    input   wire            clk, 
    input   wire            rst, 
    input   wire            pulse,
    input   wire    [7:0]   character,
    input   wire            start,
    output  wire            signal,
    output  reg             done, 
// 
    output  wire    [8:0]   counter,
    output  wire    [7:0]   char_in
);
    reg         signal_reg = 1'b1;
    reg [8:0]   word_counter = 9'b000000001;
    
    always@(posedge clk)begin
        case(rst)
            // 1'b0: begin
            //     signal_reg = character[word_counter]; 
            // end
            1'b1: begin
                signal_reg = 1'b1;
                word_counter = 9'b000000001;
                done = 1'b0;
            end
            default: signal_reg = (character & word_counter) ? 1'b1: 1'b0;
        endcase
        
        if (pulse) begin
            word_counter = word_counter << 1;
        end

        case(word_counter)
            9'b100000000: begin
                word_counter = 9'b000000001;
                done = 1'b1;
            end
            default:begin
                 word_counter = word_counter;
                 done = 1'b0;
            end
        endcase
    end

    assign signal = signal_reg;
    assign counter = word_counter;
    assign char_in = character;
endmodule 

module test(
    input   wire            clk, 
    input   wire            rst, 
    output  wire  [2:0]     counter
);
    reg [2:0]   counter_reg = 0;
    always@(posedge clk)begin
        if(rst)begin
            counter_reg = 0;
        end
        else begin
            counter_reg = counter_reg + 1;
        end
    end

    assign counter = counter_reg;
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