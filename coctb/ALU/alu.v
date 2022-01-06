module alu_8bit( input       i_clk,
                 input       i_rst, 
                 input [7:0] i_a,
                 input [7:0] i_b,
                 input       i_valid,
                 input [1:0] i_operand,
                 output reg [7:0]  o_result,
                 output reg        o_valid);
  
                 
                 
              always @(posedge i_clk or negedge i_rst) begin : proc_muxs
                  if(~i_rst) begin
                      o_result <=8'd0;
                  end 
                  else begin
                      if(i_valid ==1'b1) begin
                       case(i_operand)
                        2'd0 : o_result <= i_a + i_b;
                        2'd1 : o_result <= i_a ^ i_b;
                        2'd2 : o_result <= i_a | i_b;
                        2'd3 : o_result <= i_a & i_b;
                        default : o_result <= 8'hff;
                       endcase // o_operand
                       o_valid <=1'b1;
                     end
                     else
                       o_valid <=1'b0; 
                      
                  end
              end
`ifdef COCOTB_SIM
initial begin
  $dumpfile ("alu_8bit.vcd");
  $dumpvars (0, alu_8bit);
  #1;
end
`endif
endmodule // alu_8bit    