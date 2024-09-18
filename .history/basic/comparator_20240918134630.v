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

endmodule