module register_right (
	input clk,
	input [15:0] din,
	output reg [15:0] dout
);
	always@(posedge clk)
		dout<={din[0],din[15:1]};

endmodule

assign  = ;

module register_left (
	input clk,
	input [15:0] din,
	output reg [15:0] dout
);
	always@(posedge clk)
		dout<={din[14:0],din[15]};

endmodule


module register_p2s(
	input [7:0] din,
	input clk,en,
	output reg dout
);
	reg [7:0] dtemp;

	always @(posedge clk) begin
		if (en==1'b1) dtemp<=din;
		else begin
			dout<=dtemp[0];
			dtemp<={1'b0,dtemp[7:1]};
		end
	end


endmodule


module register_s2p(
	input din,clk,
	output [7:0] dout
);
	reg [7:0] dtemp;
	always @(posedge clk) begin
		dtemp<={dtemp[6:0],din};
	end
	assign dout = dtemp;
endmodule
