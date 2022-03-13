`timescale 1ns / 1ps
module door_lock_tb ();
  
  
  reg clk, rst;
  reg[3:0] key;
  
  wire locked;
  wire unlocked;
  wire error;

  door_lock i_door_lock (.clk(clk), .rst(rst), .key(key), .locked(locked), .unlocked(unlocked), .error(error));


  initial clk = 0;
  always #1 clk = ~clk;
  
  initial begin
    rst = 0;
    #10 rst = 1;
    key =4'b0000;
    #10
    key =4'b0100;
    #10
    key =4'b1101;
    #10
    key =4'b1101;
    #10
    key =4'b1100;
    #10
    key =4'b1110;
    $finish;
    
    
  end
  
  
endmodule