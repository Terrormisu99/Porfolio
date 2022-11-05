// Edit this file

module mac
  #(
    parameter D_W = 4,
    parameter D_W_ACC = 8
  )
  (
    input wire               clk,
    input wire               rst, //Synchronous active high reset 
    input wire [D_W-1:0]     a,
    input wire [D_W-1:0]     b,
    input wire               initialize, //When high, clear accu
    output reg [D_W_ACC-1:0] result
  );

  always @(posedge clk) begin 
	if (rst) begin
		result<= 0;
		//a<=0;
		//b<=0;	
	end else begin
			if (initialize) begin
					result<=a*b;
			end else begin
					result<=result+a*b;
      end
	end

end

          
endmodule

