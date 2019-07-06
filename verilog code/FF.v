module DFF(
	input clk,clr,rst,d,
	output reg q
);

	always @(posedge clk or posedge clr) begin
		if (clr==1'b1) q<=1'b0;
		else if (rst==1'b1) q<=1'b1;
		else q<=d;
	end

endmodule



module DFF_8 (
	input [7:0] d,
	input clk,
	output reg [7:0] q
);
	always @(posedge clk) q<=d;
endmodule