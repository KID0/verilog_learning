module checker(
	input [8:0] din,
	output odd,even
);

	assign odd = ^din;
	assign even = !odd;

endmodule
