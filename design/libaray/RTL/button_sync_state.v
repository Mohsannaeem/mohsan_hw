`timescale 1ns / 1fs
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2023 11:55:19 AM
// Design Name: 
// Module Name: button_sync
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


module button_sync(
	input  		clk,    // Clock
	input  		rst,  // Asynchronous reset active high
	input       a , 
	output reg  s
);
 
 // --- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- -----
 // State Encoding
 // --- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- -----
 localparam WAITRISE = 2'h0,
  			PULSE    = 2'h1,
  			WAITFALL = 2'h2;
 // --- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- -----
 // Local Variables Declaration
 // --- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- -----
  reg [1:0] curr_state;
  reg [1:0] next_state;
// --- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- -----
// Current State Registers
// --- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- -----
always @(posedge clk or negedge rst) begin 
	if(rst == 1) begin
		curr_state <= WAITRISE;
	end else begin
		curr_state <= next_state ;
	end
end
// --- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- -----
// Next State Logic
// --- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- -----
 always @(*) begin
	case (curr_state)
		WAITRISE :
			if(a)
				next_state <= PULSE;
		PULSE :
			if(a) 
				next_state <= WAITFALL;
			else
			    next_state <= WAITRISE;
		WAITFALL : 
			if(~a)
				next_state <= WAITRISE;
	
		default : next_state <= WAITRISE;
	endcase
 end


// --- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- -----
// Output Logic
// --- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- -----
always @(*) begin
	case(curr_state)
		WAITRISE  : s <=0;
		PULSE     : s <=1;
		WAITFALL  : s <=0;
        default :  s <=0;
	endcase
end

endmodule