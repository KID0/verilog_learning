`timescale 1ns/1ps

module mux2to1_tb;
	reg [1:0] d_in;
	reg sel;
	wire d_out;

	mux2to1 U0(
		.d_in(d_in),
		.sel(sel),
		.d_out(d_out)
	);


	initial begin
		d_in=2'b10; sel=1'b1;
		display_vars;
		#10
		d_in=2'b01; sel=1'b0;
		display_vars;

		
	end

	task display_vars;
	#1	$display("%b,%b,%b",d_in,sel,d_out);
	endtask

endmodule


module mux2to1(
	input [1:0] d_in,
	input sel,
	output d_out
);

	assign d_out =sel?d_in[1]:d_in[0];

endmodule


module mux2to1_1(
	input [1:0] d_in,
	input sel,
	output reg d_out
);

	always @(d_in or sel) begin
		if (sel) begin
			d_out = d_in[1];
		end
		else begin
			d_out = d_in[0];
		end
	end
endmodule


module mux2to1_2(
	input [3:0] d_in,
	input [1:0] sel,
	output reg d_out
);
	always @(d_in or sel) begin
		case(sel)
			2'b00:d_out<=d_in[0];
			2'b01:d_out<=d_in[1];
			2'b10:d_out<=d_in[2];
			2'b11:d_out<=d_in[3];
			default:d_out<=1'b0;
		endcase
	end

endmodule