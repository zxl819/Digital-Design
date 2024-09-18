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
分析：直接得出的逻辑表达式
 assign Y2 = A[3]&~B[3] |
                     ~(A[3]^B[3])&(A[2]&~B[2]) |
                     ~(A[3]^B[3])&~(A[2]^B[2])&(A[1]&~B[1]) |
                     ~(A[3]^B[3])&~(A[2]^B[2])&~(A[1]^B[1])&(A[0]&~B[0]);
assign Y1 = ~(A[3]^B[3]) & ~(A[2]^B[2]) & ~(A[1]^B[1]) & ~(A[0]^B[0]);
assign Y0 = B[3]&~A[3] |
                     ~(B[3]^A[3])&(B[2]&~A[2]) |
                     ~(B[3]^A[3])&~(B[2]^A[2])&(B[1]&~A[1]) |
                     ~(B[3]^A[3])&~(B[2]^A[2])&~(B[1]^A[1])&(B[0]&~A[0]);
*/

endmodule