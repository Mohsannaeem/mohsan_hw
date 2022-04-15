`timescale 1ns / 1ps
module door_lock_tb ();
  
  
  reg clk, rst;
  reg[7:0] key;
  
  wire locked;
  wire unlocked;
  wire error;

  door_lock i_door_lock (.clk(clk), .rst(rst), .key(key), .locked(locked), .unlocked(unlocked), .error(error));


  initial clk = 0;
  always #1 clk = ~clk;
initial
 begin
    $dumpfile("test.vcd");
    $dumpvars(1,door_lock_tb);
 end
  initial begin
    rst = 0;
    #10 rst = 1;
    key =8'b00000000;
    #10
    key =8'b01001000;
    #10
    key =8'b11011001;
    #10
    key =8'b11011001;
    #10
    key =8'b11000001;
    #10
    key =8'b11101101;
    $finish;
    
    
  end
  
  
endmodule