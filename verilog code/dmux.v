module demux_4(
	input en,d_in,
	input [1:0] sel,
	output reg [3:0] d_out
);
	always @(en or d_in or sel) begin
		if (!en) d_out<=4'b0000;
		else case(sel)
			2'b00:d_out<={3'b000,d_in};
			2'b01:d_out<={2'b00,d_in,1'b0};
			2'b10:d_out<={1'b0,d_in,2'b00};
			2'b11:d_out<={d_in,3'b000};
		endcase

	end



endmodule