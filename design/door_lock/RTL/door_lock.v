`timescale 1ns / 1ps
module door_lock (
  input  wire           clk     , // input clock 
  input  wire           rst     , // reset for
  input  wire     [7:0] key     , //input from Keys
  output      reg       locked  , //Led indicator to show door locked
  output      reg       unlocked, //Led indicator to show door unlocked
  output      reg       error     //Led indicator to show the error in sequence 
);

  localparam    //8 states of the FSM for detecting the 8 bit sequence
    zero  = 3'b000,
    one   = 3'b001,
    two   = 3'b010,
    three = 3'b011,
    four  = 3'b100,
    five  = 3'b101,
    six   = 3'b110,
    seven = 3'b111;

  wire match; //bit to check if its matched the code
  reg [2:0] cur_state,next_state; //current state and next state for State Machine

//sequential part of FSM
  always @(posedge clk or negedge rst) begin : proc_sequential
    if(~rst) begin  //negative reset
      cur_state <= zero; //goes to default state
    end else begin
      cur_state <= next_state ;
    end
  end

//FSM

  always @(key,cur_state) begin : proc_combinational
//    next_state= cur_state;
    case (cur_state)
      zero : begin
        if(key[7])  //checks key[3] and moves to next state accordingly
          next_state <= one;
        else
          next_state <= zero;
      end // zero  :
      one : begin
        if(key[6])   //changes states
          next_state <= two;
        else
          next_state <= zero;
      end // one   :
      two : begin
        if(~ key[5])
          next_state <= three;
        else
          next_state <= zero;
      end // two   :
      three : begin
        if(key[4])
          next_state <= four;
        else
          next_state <= zero;
      end // three :
      four : begin
        if(key[3])
          next_state <= five;
        else
          next_state <= zero;
      end // four :

      five : begin
        if(~key[2])
          next_state <= six;
        else
          next_state <= zero;
      end // five :

      six : begin
        if(~key[1])
          next_state <= seven;
        else
          next_state <= zero;
      end // six :

      seven : begin
        if(key[0])
          next_state <= zero;
        else
          next_state <= zero;
      end // seven :
      default : /* default */;
    endcase
  end

  assign match = key[0] && cur_state[0] && cur_state[1] && cur_state[2]; //match bit the state is three and last input is also 1


//OUTPUTS

  always@(posedge clk or negedge rst )begin : proc_lock   //lock output
    if(~rst)
      locked <= 1'b1; //reset condition is locked
    else
      locked <= (match==1'b1)? ~locked : 1'b1; //checks the match bit and works accordingly.
  end

  always@(posedge clk or negedge rst )begin : proc_unlock //unlocking procedure
    if(~rst)
      unlocked <= 1'b0; //locked
    else
      unlocked <= (match==1'b1)? ~unlocked : 1'b0; //changes the unlock signal accordingly
  end

  always@(posedge clk or negedge rst )begin : proc_error //procedure for error
    if(~rst)
      error <= 1'b0;
    else
      error <= (key !=8'b11011001)? 1'b1:1'b0; //error occurs if the input code doesn't match with unlocking combination
  end
endmodule
