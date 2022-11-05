`timescale 1 ps / 1 ps

module systolic
#
(
    parameter   D_W  = 8, //operand data width
    parameter   D_W_ACC = 16, //accumulator data width
    parameter   N   = 3,
    parameter   M   = 6
)
(
    input   wire                                        clk,
    input   wire                                        rst,
    input   wire                                        enable_row_count_A,
    output  wire    [$clog2(M)-1:0]                     pixel_cntr_A,
    output  wire    [($clog2(M/N)?$clog2(M/N):1)-1:0]   slice_cntr_A,
    output  wire    [($clog2(M/N)?$clog2(M/N):1)-1:0]   pixel_cntr_B,
    output  wire    [$clog2(M)-1:0]                     slice_cntr_B,
    output  wire    [$clog2((M*M)/N)-1:0]               rd_addr_A,
    output  wire    [$clog2((M*M)/N)-1:0]               rd_addr_B,
    input   wire    [D_W-1:0]                           A [N-1:0], //m0
    input   wire    [D_W-1:0]                           B [N-1:0], //m1
    output  wire    [D_W_ACC-1:0]                       D [N-1:0][N-1:0], //m2
    output  wire    [N-1:0]                             valid_D [N-1:0]
);


wire    [D_W-1:0]    out_a   [N-1:0][N-1:0];
wire    [D_W-1:0]    out_b   [N-1:0][N-1:0];
wire    [D_W-1:0]    in_a   [N-1:0][N-1:0];
wire    [D_W-1:0]    in_b   [N-1:0][N-1:0];

wire    [N-1:0] init_pe  [N-1:0];

control #
(
    .N        (N),
    .M        (M),
    .D_W      (D_W),
    .D_W_ACC  (D_W_ACC)
  )
  control_inst
  (

    .clk                  (clk),
    .rst                  (rst),
    .enable_row_count     (enable_row_count_A),

    .pixel_cntr_B         (pixel_cntr_B),
    .slice_cntr_B         (slice_cntr_B),

    .pixel_cntr_A         (pixel_cntr_A),
    .slice_cntr_A         (slice_cntr_A),

    .rd_addr_A            (rd_addr_A),
    .rd_addr_B            (rd_addr_B)
  );

// enter your RTL here

genvar i,j;

generate
    for (i=0; i<N; i=i+1) begin: row
        for (j=0; j<N; j=j+1) begin: col
            pe
            #(.D_W_ACC (D_W_ACC),
              .D_W (D_W)
                )
            PE_inst(
                .clk (clk),
                .rst (rst),
                .init (init_pe[i][j]),
                .in_a (in_a[i][j]),
                .in_b (in_b[i][j]),
                .out_sum (D[i][j]),
                .out_b (out_b[i][j]),
                .out_a (out_a[i][j]),
                .valid_D (valid_D[i][j]) //accessing 1 bit of possible N,N-bit valids...might be backwards? 
            );
            if (j>0) begin //i want to join current a_in to previous a_out in current working row
                assign in_a[i][j]=out_a[i][j-1];
                assign init_pe[i][j]=valid_D[i][j-1]; //cascade the init and valids of PEs in same row
            end
            if (i>0) begin //i want to join current b_in to previous b_out in above cell
                assign in_b[i][j]=out_b[i-1][j];
            end
            if (i>0 & j==0) begin //i want to join current init to valid of cell above...only for first column
                assign init_pe[i][j]=valid_D[i-1][0];
            end
            if (j==0) begin
                assign in_a[i][0]=A[i];
            end
            if (i==0) begin
                assign in_b[0][j]=B[j];
            end
                // movement of the init signal for diagonal wavefront
                // 1->2->3->4
                // |
                // v
                // 2->3->4->5
                // |
                // v
                // 3->4->5->6
                // |
                // v
                // 4->5->6->7
        end    
    end   
endgenerate

reg init_holder, init_holder_2; 
assign init_pe[0][0]=init_holder_2;
if (N==M) begin
    always @(posedge clk ) begin
        init_holder_2<=0;
        if (pixel_cntr_A==M-1 & slice_cntr_A==0)begin //if N=M then we propragate init once from [0][0]
            init_holder<= 1;
        end else begin
            init_holder<=0;  
        end

        if (init_holder==1) begin
            init_holder_2<=1;
        end 
    end
end else begin
    always @(posedge clk ) begin
        init_holder_2<=0;
        if (pixel_cntr_A==M-1)begin
            init_holder<= 1;
        end else begin
            init_holder<=0;  
        end

        if (init_holder==1) begin
            init_holder_2<=1;
        end 
     end
end



// module pe
// #(
//     parameter   D_W_ACC  = 64, //accumulator data width
//     parameter   D_W      = 32  //operand data width
// )
// (
//     input   wire                  clk,
//     input   wire                  rst,
//     input   wire                  init,
//     input   wire    [D_W-1:0]     in_a,
//     input   wire    [D_W-1:0]     in_b,
//     output  reg     [D_W_ACC-1:0] out_sum,
//     output  reg     [D_W-1:0]     out_b,
//     output  reg     [D_W-1:0]     out_a,
//     output  reg                   valid_D
// );


endmodule
