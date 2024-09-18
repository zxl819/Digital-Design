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
//门级电路
not iv0(iv0_o, B[0]),

    iv1(iv1_o, B[1]),

    iv2(iv2_o, B[2]),

    iv3(iv3_o, B[3]),

    iv4(iv4_o, A[0]),

    iv5(iv5_o, A[1]),

    iv6(iv6_o, A[2]),

    iv7(iv7_o, A[3]);

   

and ad0(ad0_o, iv0_o, A[0]),

    ad1(ad1_o, iv1_o, A[1]),

    ad2(ad2_o, iv2_o, A[2]),

    ad3(ad3_o, iv3_o, A[3]),

   

    ad4(ad4_o, ad0_o, xnr0_o, xnr1_o, xnr2_o),

    ad5(ad5_o, ad1_o, xnr1_o, xnr2_o),

    ad6(ad6_o, ad2_o, xnr2_o),

   

    ad7(ad7_o, iv4_o, B[0]),

    ad8(ad8_o, iv5_o, B[1]),

    ad9(ad9_o, iv6_o, B[2]),

    ad10(ad10_o, iv7_o, B[3]),

   

    ad11(ad11_o, ad7_o, xnr0_o, xnr1_o, xnr2_o),

    ad12(ad12_o, ad8_o, xnr1_o, xnr2_o),

    ad13(ad13_o, ad9_o, xnr2_o),

    ad14(Y1, xnr2_o, xnr1_o, xnr0_o, xnr3_o);

   

xnor xnr0(xnr0_o, A[1], B[1]), 

     xnr1(xnr1_o, A[2], B[2]),  

     xnr2(xnr2_o, A[3], B[3]),  

     xnr3(xnr3_o, A[0], B[0]); 


or or0(Y2, ad3_o, ad6_o, ad5_o, ad4_o),

   or1(Y0, ad10_o, ad13_o, ad12_o, ad11_o) ;   
endmodule