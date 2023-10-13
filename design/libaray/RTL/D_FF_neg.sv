module D_FF_neg(
	input logic D,Clkb,RSTb,
	output logic Q,Qb
);
 always_ff @(posedge Clkb or negedge RSTb) begin 
 	if(RSTb == 0) begin
 		Q  <= 0;
 		Qb <= 0;
 	end else begin
 		Q <= D ;
 		Qb <= ~D;
 	end
 end

endmodule : D_FF_neg