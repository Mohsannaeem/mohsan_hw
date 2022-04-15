/***************************************************
Module name = axi_fifo.sv
project 	= axi_dma
Author 		= Mohsan Naeem
Version		= 0.1
Date 		= 16/04/2022
Description :


***************************************************/
`timescale 1ns/1ps
module tb_axi_fifo ();

logic clk;
logic rst; 
logic i_wr_en, i_rd_en;
logic [31:0] i_wr_data, o_rd_data;
initial begin 
	clk=0;
    forever begin
    #10 clk = ~clk;
    end
end
initial begin
	
	rst=0;
	#100;
	rst =1;
	i_wr_en   =1;
	i_wr_data = 123;
	#500;
	i_wr_en   =0;
	i_rd_en   =1;
end
initial begin
	$dumpfile("fifo.vcd");
	$dumpvars(0,fifo);
end
axi_fifo_top fifo (
	.i_clk 	  	(clk)			,      	// Clock
	.i_rst_n	(rst)			,	    // Asynchronous reset active low
	.i_wr_en	(i_wr_en)		,		
	.i_rd_en	(i_rd_en)		,		
	.i_wr_data  (i_wr_data)		,		// Write data to memory
	.o_rd_data 	(o_rd_data)				// Read data from memory
);


endmodule : tb_axi_fifo