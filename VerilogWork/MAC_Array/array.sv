// Edit this file

module array
  #(
    parameter D_W  = 8, //operand data width
    parameter D_W_ACC = 16, //accumulator data width
    parameter N   = 3
  )
  (
   input   wire                        clk,
   input   wire                        rst,
   input   wire    [D_W-1:0]           a [N-1:0],
   input   wire    [D_W-1:0]           b [N-1:0], 
   input   wire                        initialize,
   output  wire    [D_W_ACC-1:0]       result [N-1:0]
  );

  
  //using "port mapping by name" .portNameOfInstance maps to signal inside (...)
  
  genvar i;
  generate
    for (i=0; i<N; i=i+1) begin
      mac  #(.D_W(D_W), .D_W_ACC(D_W_ACC)) mac_inst (.clk(clk ), .rst(rst ), .a( a[i]), .b( b[i]), .initialize( initialize ), .result( result[i]) );
    end
  endgenerate
  
//  mac mac_inst0(.clk(clk ), .rst(rst ), .a( a[0]), .b( b[0]), .initialize( initialize ), .result( result) );
//  mac mac_inst1(.clk(clk ), .rst(rst ), .a( a[1]), .b( b[1]), .initialize( initialize ), .result( result) );
//  mac mac_inst2(.clk(clk ), .rst(rst ), .a( a[2]), .b( b[2]), .initialize( initialize ), .result( result) );
  
endmodule
