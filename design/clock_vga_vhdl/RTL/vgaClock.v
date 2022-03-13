module vgaClock(

	//////////// CLOCK //////////
	input 		          		CLOCK_50,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// VGA //////////
	output		          		VGA_BLANK_N,
	output		     [7:0]		VGA_B,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS
);

wire [2:0] blue;
wire [2:0] green;
wire [2:0] red;

assign VGA_B = {8{blue[0]}};
assign VGA_G = {8{green[0]}};
assign VGA_R = {8{red[0]}};


vgaClockMain uut(
	.clk100(CLOCK_50),
	.rst(SW[0]),
	.btnU(KEY[1]),
	.btnD(KEY[0]),
	.btnL(SW[3]),
	.btnR(SW[2]),
	.btnC(SW[1]),
	.hsync(VGA_HS),
	.vsync(VGA_VS),
	.red(red),
	.green(green),
	.blue(blue)
	);

endmodule
