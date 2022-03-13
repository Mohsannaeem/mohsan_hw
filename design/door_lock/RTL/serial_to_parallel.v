// Description: This design implement parallel in serial out circuit for 32 bit value.
module par_o_ser_i (
  input            i_clk,
  input            i_reset,
  input            i_data,
  input            i_start,
  output reg       o_done,
  output     [7:0] o_data,
  output reg          timeout
);

  reg [15:0] reg_file; //register file
  reg [ 4:0] count;
  reg [ 6:0] timout_count;

  always@(posedge i_clk) begin
    if(i_reset == 1) begin //if(!rst_n)
      reg_file     <= 0;
      count        <= 0;
      o_done       <= 0;
    end
    else begin
      if(i_start && count <=7) begin
        count         <= count + 1;
        reg_file[7]   <= i_data;
        reg_file[6:0] <= reg_file[7:1];
        o_done        <= 0;
      end
      else if(count == 8) begin
        count  <= 0;
        o_done <= 1;
      end
    end
  end
  always @(posedge i_clk or negedge i_reset) begin : proc_timout
    if(~rst_n) begin
       timout_count <= 0;
       timeout      <= 1'b0;
    end else if(i_data == reg_file[]) begin
       timout_count<= timout_count + 1;
    end
    if(timout_count == 16)
      timeout <= 0;
  end
  assign o_data = reg_file;

endmodule