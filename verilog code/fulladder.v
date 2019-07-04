module fulladder1_1_tb;
	reg A,B,C_IN;
	wire SUM,C_OUT;

	fulladder1_1 U0(
		.A(A),.B(B),.C_IN(C_IN),.SUM(SUM),.C_OUT(C_OUT)
	);

	initial begin
			A=1'b0;B=1'b0;C_IN=1'b0;
		#10 A=1'b0;B=1'b1;C_IN=1'b0;
		#10 A=1'b1;B=1'b1;C_IN=1'b0;
		#10 A=1'b1;B=1'b1;C_IN=1'b1;
		#100 $finish;
	end

endmodule




module fulladder1_1 (
	input A,B,C_IN,
	output SUM,C_OUT
);
	assign SUM = (A^B)^C_IN;
	assign C_OUT = (A&B)|((A^B)&C_IN);

endmodule


module fulladder2_1 (
	input A,B,C_IN,
	output SUM,C_OUT
);
	assign {C_OUT,SUM} = A+B+C_IN;

endmodule

module adder_8 (
	input [7:0] A,B,
	input C_IN,
	output [7:0] SUM,
	output C_OUT
);

	assign {C_OUT,SUM} = A+B+C_IN;

endmodule

