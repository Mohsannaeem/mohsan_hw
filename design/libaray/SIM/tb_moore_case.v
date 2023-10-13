`timescale 1ps/1fs
module tb_vending_state_machine (); /* this is automatically generated */

	// clock
	reg clk;
	// asynchronous reset
	reg rst;
	reg       nickle;
	reg       dime;
	reg       quater;
	wire       candy;
	wire [5:0] number;

	vending_state_machine inst_vending_state_machine
		(
			.clk    (clk),
			.rst    (rst),
			.nickle (nickle),
			.dime   (dime),
			.quater (quater),
			.candy  (candy),
			.number_c (number)
		);
    // Clock generation
    always begin
        #5; // Assuming a 200MHz clock, adjust the delay accordingly
        clk = ~clk;
    end

	
    initial begin
        clk = 0;
		rst = 1;
		#10
		rst = 0;
	
	   //No coin Test Case 
		nickle = 0;
		dime   = 0;
		quater = 0;
        repeat(5)@(posedge clk);
        //Exact 25 Cent
        nickle = 1;
		dime   = 0;
		quater = 0;
        
		repeat(5)@(posedge clk);
        //No reset Cycles
        repeat(5)@(posedge clk);
        // Reset Asserted Deassert 
        rst    = 1;
		nickle = 0;
		dime   = 0;
		quater = 0;
        repeat(2)@(posedge clk);
        rst    = 0;
        repeat(1)@(posedge clk);
		//Sum of 30 Cents 
		nickle = 0;
		dime   = 1;
		quater = 0;
        repeat(3)@(posedge clk);
		
		// Reset Asserted Deassert 
        rst    = 1;
		nickle = 0;
		dime   = 0;
		quater = 0;
        repeat(2)@(posedge clk);
        rst    = 0;
		repeat(1)@(posedge clk);
		//Sum of 35 Cents
		nickle = 0;
		dime   = 1;
		quater = 0 ;
		repeat(1)@(posedge clk);
		nickle = 0;
		dime   = 0;
		quater = 1;
        repeat(1)@(posedge clk);
		
		// Reset Asserted Deassert 
        rst    = 1;
		nickle = 0;
		dime   = 0;
		quater = 0;
        repeat(2)@(posedge clk);
        rst    = 0;
		repeat(1)@(posedge clk);
		//Sum of 40 Cents
		nickle = 1;
		dime   = 0;
		quater = 0;
        repeat(1)@(posedge clk);
		nickle = 0;
		dime   = 1;
		quater = 0;
        repeat(1)@(posedge clk);
		nickle = 0;
		dime   = 0;
		quater = 1;
        repeat(1)@(posedge clk);
		// Reset Asserted Deassert 
        rst    = 1;
		nickle = 0;
		dime   = 0;
		quater = 0;
        repeat(2)@(posedge clk);
        rst    = 0;
		repeat(1)@(posedge clk);
		//Sum of 45 Cents
		nickle = 0;
		dime   = 1;
		quater = 0;
        repeat(1)@(posedge clk);
		nickle = 0;
		dime   = 1;
		quater = 0;
        repeat(1)@(posedge clk);
		nickle = 0;
		dime   = 0;
		quater = 1;
        repeat(10)@(posedge clk);
		
		$finish;
	end
endmodule
