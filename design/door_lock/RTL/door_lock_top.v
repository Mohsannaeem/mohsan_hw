module door_lock_top (
  input  wire           clk     , // input clock 
  input  wire           rst     , // reset for
  input  wire           key     , //input from Keys
  output      reg       locked  , //Led indicator to show door locked
  output      reg       unlocked, //Led indicator to show door unlocked
  output      reg       error     //Led indicator to show the error in sequence 
  output      reg       timeout     //Led indicator to show the error in sequence 
); 
  wire o_done; 
  wire [7:0] o_data,key;

  door_lock door_lock (.clk(clk),
                       .rst(rst),
                       .key(key),
                       .locked(locked),
                       .unlocked(unlocked),
                       .error(error));
  par_o_ser_i par_o_ser_i (
                        .i_clk  (clk),
                        .i_reset(rst),
                        .i_data (key),
                        .i_start(rst),
                        .o_done (o_done),
                        .o_data (o_data),
                        .timeout(timout));
  assign key =(o_done) ? o_data:8'b0;


endmodule