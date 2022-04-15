/***************************************************
Module name = axi_fifo.sv
project 	= axi_dma
Author 		= Mohsan Naeem
Version		= 0.1
Date 		= 16/04/2022
Description :


***************************************************/
`timescale 1ns/1ps
module axi_fifo_top (
	input  logic i_clk 					    	,	// Clock
	input  logic i_rst_n					    ,	// Asynchronous reset active low
	input  logic i_wr_en					    ,
	input  logic i_rd_en					    ,
	input  logic[DATA_WIDTH-1 :0] i_wr_data 	,	// Write data to memory
	output logic[DATA_WIDTH-1 :0] o_rd_data 		// Read data from memory
	
	
);
 localparam ADDR_WIDTH = 5;
 localparam DATA_WIDTH = 32; 
 logic [ADDR_WIDTH-1: 0] rd_addr;
 logic [ADDR_WIDTH-1: 0] wr_addr;


 addr_generator wr_addr_inst (
	.i_clk        (i_clk)		,
	.i_rst_n      (i_rst_n)		,
	.i_addr_en    (i_wr_en)		,
	.i_status     (1'b0)			,
	.o_addr       (wr_addr)		
);
 addr_generator rd_addr_inst (
	.i_clk        (i_clk)		,
	.i_rst_n      (i_rst_n)		,
	.i_addr_en    (i_rd_en)		,
	.i_status     (1'b0)			,
	.o_addr       (rd_addr)
);
fifo_memory memory(
	//Reset and clocks
	.i_w_clk     (i_clk)		,
	.i_r_clk     (i_clk)		,
	.i_rst_n     (i_rst_n)		,
    //Write signals
	.i_wr_en     (i_wr_en)		,
    .i_wr_addr   (wr_addr)		,
	.i_wr_data   (i_wr_data)	,
	//Read signals
	.i_rd_en     (i_rd_en)		,
	.i_rd_addr   (rd_addr)		,
	.o_rd_data   (o_rd_data) 
);

endmodule : axi_fifo_top