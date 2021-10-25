
// /*******************
//  * Author : MN ,SS
//  * Data :Oct/25/2021
//  * Description : Simple 15 bit Adder 
//  * /
module adder( 
	input [15:0] a,
	input [15:0] b,
	output [16:0] sum);

	assign sum = a + b; 
	initial begin 
        $dumpfile("adder_intf.vcd");
        $dumpvars(0,adder); 
	end

endmodule