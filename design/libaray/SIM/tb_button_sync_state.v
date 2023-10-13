`timescale 1ns / 1fs
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2023 12:06:36 PM
// Design Name: 
// Module Name: tb_button_sync
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


module tb_button_sync();
    // clock
	reg clk;
	// asynchronous reset
	reg rst;
	reg a;
	wire s;
	
	// Clock generation
    always begin
        #5; // Assuming a 100MHz clock, adjust the delay accordingly
        clk = ~clk;
    end
    button_sync btnn_inst 
    (
	.clk(clk),    // Clock
	.rst(rst),  // Asynchronous reset active high
	.a(a) , 
	.s(s)
);
	
    initial begin
        clk = 0;
		rst = 1;
		a   = 0;
		#10
		rst = 0;
	    repeat(5)@(posedge clk);
	    a = 1;
	    repeat(5)@(posedge clk);
	    a=0;
	    repeat(5)@(posedge clk);
	    #2;
	    a = 1;
	    repeat(5)@(posedge clk);
	    a=0;
	    repeat(15)@(posedge clk);
	    $finish;
	end	
endmodule
