`timescale 1 ps / 1 ps

module pe
#(
    parameter   D_W_ACC  = 64, //accumulator data width
    parameter   D_W      = 32  //operand data width
)
(
    input   wire                  clk,
    input   wire                  rst,
    input   wire                  init,
    input   wire    [D_W-1:0]     in_a,
    input   wire    [D_W-1:0]     in_b,
    output  reg     [D_W_ACC-1:0] out_sum,
    output  reg     [D_W-1:0]     out_b,
    output  reg     [D_W-1:0]     out_a,
    output  reg                   valid_D
);

// enter your RTL here
reg [D_W_ACC-1:0] temp_out =0; //IS THERE A BETTER WAY? SEEM TO LOSE SUM WHEN INIT ASSERTED

  always @(posedge clk) begin 
        if (rst) begin
            out_sum<= 0;

            out_a<=0;
            out_b<=0; 
        end else begin
                out_a<=in_a;
                out_b<=in_b;
                valid_D<=init;
                if (init) begin
                     temp_out<= in_a*in_b;
                     out_sum<=temp_out;
                end else begin
                    temp_out<=temp_out+in_a*in_b;
                    out_sum<=temp_out;

          end
        end
   end

  // always @(posedge clk) begin 
  //       if (rst) begin
  //           out_sum<= 0;

  //           out_a<=0;
  //           out_b<=0; 
  //       end else begin
  //               out_a<=in_a;
  //               out_b<=in_b;
  //               valid_D<=init;
  //               if (init) begin
  //                    out_sum<= out_a*out_b;
                     
  //               end else begin
  //                   out_sum<=out_sum+in_a*in_b;
                    

  //         end
  //       end
  //  end


endmodule
