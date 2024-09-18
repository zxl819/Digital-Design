`timescale 1ns/1ns

module comparator_4(
	input		[3:0]       A   	,
	input	   [3:0]		B   	,
 
 	output	 wire		Y2    , //A>B
	output   wire        Y1    , //A=B
    output   wire        Y0      //A<B
);
/*
1bit: F(A>B) = A & ~B;
F(A==B) = ~(A^B);
F(A<B) = ~A & B;
*/
/*
    assign Y2 = A[3]&~B[3];
    assign Y1 = A == B;
    assign Y0 = A < B; 
*/

endmodule