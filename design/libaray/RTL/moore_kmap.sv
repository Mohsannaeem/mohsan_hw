module top (
	input       Clkb   , // Clock
	input       RSTb   , // Asynchronous reset active low
	input [1:0] enc_inp,
	output[4:0] cur_state
);

	logic [3:0] next_state;
	logic [3:0] Qb        ;
	logic cmn1, cmn2, cmn3, cmn4;
	//*****************************************************************************************
	// NEXT State Logic
	//*****************************************************************************************
	//  CDE  => cmn1 =  CDE
	assign cmn1 = cur_state[1] & cur_state[0] & enc_inp[1];
	//  E'F'  => cmn2 = E'F'
	assign cmn2 = ~enc_inp[1] & ~enc_inp[0];
	//  BC'  => cmn3 = BC'
	assign cmn3 = cur_state[2] & ~cur_state[1];
	//  EF'  => cmn4 = EF'
	assign cmn4 = enc_inp[1] & ~enc_inp[0];
	//S3' = AE'F' + BC'DEF + BCD'EF'
	//S3' = A cmn2 + cmn3 &DEF + BCD'& cmn4
	assign next_state[3] = (cur_state[3] & cmn2) |
		(cmn3 & cur_state[0] & enc_inp[1] & enc_inp[1])|
			(cur_state[2] &cur_state[1]& ~cur_state[0] & cmn4 ) ;

	//S2' = B'CE + CDE + BC'D' + BC'E' + BD'E' + BC'F' + B'DEF
	//S2' = B'CE + cmn1 + cmn3 & D' + cmn3 & E' + BD'E' + cmn3 & F' + B'DEF
	assign next_state[2] = (~cur_state[2] & cur_state[1] & enc_inp[1])|
		(cmn1) |
			(cmn3 & ~cur_state[0]) |(cmn3 & ~enc_inp[1])|
				(cur_state[2]& ~cur_state[0] & ~enc_inp[1])|
					(cmn3 & ~ enc_inp[0])|
						(~cur_state[2]& cur_state[0]& enc_inp[1] & enc_inp[0] );

	//S1' = C'D'E + C'EF' +CE'F' +C'DE'F + CDEF
	//S1' = C'D'E + C'cmn4 +C & cmn2 +C'DE'F + cmn1 & F
	assign next_state[1] = (~cur_state[1] & ~cur_state[0]& enc_inp[1])|
		(~cur_state[1]& cmn4) |
			( cur_state[1] & cmn2)|
				(~cur_state[1] & cur_state[0] &~ enc_inp[1]& enc_inp[0] )|
					(cmn1 & enc_inp[0]);
	//S0' = D'F + DF'
	//S0' = D'F + DF'
	assign next_state[0] = (~cur_state[0] &enc_inp[0])|
		(cur_state[0]& ~enc_inp[0]) ;
	
	//*****************************************************************************************
	// State register
	//*****************************************************************************************
	

	D_FF_neg D_FF_neg_inst0 (.D(next_state[0]), .Clkb(Clkb), .RSTb(RSTb), .Q(cur_state[0]), .Qb(Qb[0]));
	D_FF_neg D_FF_neg_inst1 (.D(next_state[1]), .Clkb(Clkb), .RSTb(RSTb), .Q(cur_state[1]), .Qb(Qb[1]));
	D_FF_neg D_FF_neg_inst2 (.D(next_state[2]), .Clkb(Clkb), .RSTb(RSTb), .Q(cur_state[2]), .Qb(Qb[2]));
	D_FF_neg D_FF_neg_inst3 (.D(next_state[3]), .Clkb(Clkb), .RSTb(RSTb), .Q(cur_state[3]), .Qb(Qb[2]));

	//*****************************************************************************************
	// Output Logic  current state(K-MAP) dependent 
	//*****************************************************************************************


endmodule