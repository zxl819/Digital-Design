`timescale 1ns/1ns

module comparator_4(
	input		[3:0]       A   	,
	input	   [3:0]		B   	,
 
 	output	 wire		Y2    , //A>B
	output   wire        Y1    , //A=B
    output   wire        Y0      //A<B
);
reg [1:0]A3,A2,A1,A0,B3,B2,B1,B0;
assign A3 = A[3];
assign A2 = A[2];
assign A1 = A[1];
assign A0 = A[0];
assign B3 = B[3];
assign B2 = B[2];
assign B1 = B[1];
assign B0 = B[0];
if A3 > B3
    assign Y2 =1;
else if A3 < B3
    assign Y0 =1;
else if A2 > B2
    assign Y2 =1;
else if A2 < B2
    assign Y0 =1;
else if A1 > B1
    assign Y2 =1;
else if A1 < B1
    assign Y0 =1;
else if A0 > B0
    assign Y2 =1;
else if A0 < B0
    assign Y0 =1;
else
    assign Y1 =1;

endmodule