/****************************************************
Module Name = Address generator
Project 	= AXI DMA
Author 		= Mohsan Naeem
Version 	= 0.1
Date 		= 16/04/2022
Description:
****************************************************/
`timescale 1ns/1ps
module addr_generator #(
	parameter ADDR_WIDTH = 5
	)(
	input  logic						i_clk      ,	// Clock
	input  logic						i_rst_n    ,	// Asynchronous reset active low
	input  logic						i_addr_en  ,
	input  logic						i_status	  ,
	output logic [ADDR_WIDTH-1:0] o_addr
);
   //register to store the address
   logic  [ADDR_WIDTH-1:0] r_addr;

   //always block to make  register
   always @(posedge i_clk or negedge i_rst_n) begin : proc_addr
   	if(~i_rst_n) begin
   		r_addr <= 0;
   	end else if(~i_status && i_addr_en)begin
   		r_addr <= r_addr+1;
   	end
   	//Give one cycle delay to generate next address for transaction
   	o_addr <=r_addr;
   end
endmodule : addr_generator