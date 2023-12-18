`timescale 1ps/1fs
module vending_state_machine (
	input  		clk,    // Clock
	input  		rst,  // Asynchronous reset active high
	input  		nickle,
	input  		dime,
	input  		quater,
	output 	reg	candy,
	output reg [5:0] number_c
);
 
 // --- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- -----
 // State Encoding
 // --- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- -----
 localparam IDLE 	 = 3'h0,
  			S_NICKLE = 3'h1,
  			S_DIME	 = 3'h2,
  			S_15	 = 3'h3,
  			S_20   	 = 3'h4,
  			S_QUATER = 3'h5;
 // --- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- -----
 // Local Variables Declaration
 // --- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- -----

  reg [2:0] curr_state;
  reg [2:0] next_state;
  reg [5:0] number_c; 
// --- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- -----
// Current State Registers
// --- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- -----
always @(posedge clk or posedge rst) begin 
	if(rst == 1) begin
		curr_state <= IDLE;
	end else begin
		curr_state <= next_state ;
	end
end
// --- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- -----
// Next State Logic
// --- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- -----
 always @(*) begin
	if(rst) next_state <= 0;
	case (curr_state)
		IDLE :  begin
			if(nickle) begin
				next_state <= S_NICKLE;
				number_c <= 6'd5;
			end	
			if(dime) begin
				next_state <= S_DIME;
				number_c <= 6'd10;
			end	
			if(quater) begin
				next_state <= S_QUATER;
				number_c <= 6'd0;
			end	
		end 
		S_NICKLE : begin
			if(nickle) begin
				next_state <= S_DIME;
				number_c <= 6'd10;
			end	
			if(dime) begin
				next_state <= S_15;
				number_c <= 6'd15;
			end	
			if(quater) begin
				next_state <= S_QUATER;
				number_c <= 6'd5;
			end	
		end

		S_DIME   :   begin
			if(nickle) begin
				next_state <= S_15;
				number_c <= 6'd15;
			end	
			if(dime) begin
				next_state <= S_20;
				number_c <= 6'd20;
			end	
			if(quater) begin
				next_state <= S_QUATER;
				number_c <= 6'd10;
			end	
		end 
		S_15  	 :   begin
			if(nickle) begin
				next_state <= S_20;
				number_c <= 6'd20;
			end	
			if(dime) begin
				next_state <= S_QUATER;
				number_c <= 6'd0;
			end	
			if(quater) begin
				next_state <= S_QUATER;
				number_c <= 6'd15;
			end	
		end 
		S_20     :   begin
			if(nickle) begin
				next_state <= S_QUATER;
				number_c <= 6'd0;
			end	
			if(dime) begin
				next_state <= S_QUATER;
				number_c <= 6'd5;
			end	
			if(quater) begin
				next_state <= S_QUATER;
				number_c <= 6'd20;
			end	
		end 
		S_QUATER   :   begin
			 next_state <= S_QUATER;
		end 	
		default : next_state <= IDLE;
	endcase
 end


// --- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- -----
// Output Logic
// --- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- ----- ---- ---- -----
always @(*) begin
	case(curr_state)
		IDLE    : candy <=0;
		S_NICKLE: candy <=0;
		S_DIME  : candy <=0;
		S_15    : candy <=0;
		S_20    : candy <=0;
		S_QUATER: candy <=1;
	endcase
end

endmodule