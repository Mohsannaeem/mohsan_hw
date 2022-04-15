/***************************************************
Module name = fifo_memory.sv
project 	= axi_dma
Author 		= Mohsan Naeem
Version		= 0.1
Date 		= 16/04/2022
Description :


***************************************************/
`timescale 1ns/1ps
module fifo_memory #(
	 parameter DATA_WIDTH = 32,    
	 parameter ADDR_WIDTH = 5
	)
	(
	//Reset and clocks
	input 	logic					  				i_w_clk   ,	// Write Clock
	input 	logic					  				i_r_clk   ,	// Read Clock
	input 	logic					  				i_rst_n   ,	// Asynchronous reset active low
  //Write signals
	input 	logic 				  				i_wr_en	 ,	// Write enable for fifo
   input 	logic [ADDR_WIDTH-1 :0] 		i_wr_addr ,	// Write addr to memory
	input 	logic [DATA_WIDTH-1 :0] 		i_wr_data ,	// Write data to memory
	//Read signals
	input 											i_rd_en   ,	// Read enable for fifo
	input 	logic [ADDR_WIDTH-1 :0] 		i_rd_addr ,	// Read addr from memory
	output 	logic [DATA_WIDTH-1 :0] 		o_rd_data  	// Read data from memory
);
   //packed array of memory which is contiguos memory and map to BRAM
	 logic [ADDR_WIDTH**2-1:0][DATA_WIDTH-1:0] memory;
   
   //reset and write data logic
   always @(posedge i_w_clk or negedge i_rst_n) begin : proc_memory_write
   	if(~i_rst_n) begin
   		memory <= 0;
   	end else if(i_wr_en) begin
   		memory[i_wr_addr] <= i_wr_data;
   	end
   end
   //read data logic
   always @(posedge i_w_clk or negedge i_rst_n) begin : proc_memory_read
   	if(~i_rst_n) begin
   		 o_rd_data<= 0;
   	end else if(i_rd_en) begin
   		 o_rd_data<=memory[i_rd_addr] ;
   	end
   end


endmodule : fifo_memory