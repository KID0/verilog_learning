module counter10(
	input clk,rst_n,en,
	output reg [3:0] dout,
	output co
);
	always @(posedge clk or negedge rst_n) begin
		if (rst_n==1'b0) dout<=4'b0000;
		else if (en==1'b1) begin
			if(dout==4'b1001) dout<=4'b0000;
			else dout<=dout+1'b1;
		end
		else dout<=dout;
	end
	assign co = dout[0]&&dout[3];

endmodule


module counter6(
	input clk,rst_n,en,
	output reg [3:0] dout,
	output co
);
	always @(posedge clk or negedge rst_n) begin
		if (rst_n==1'b0) dout<=4'b0000;
		else if (en==1'b1) begin
			if(dout==4'b0101) dout<=4'b0000;
			else dout<=dout+1'b1;
		end
		else dout<=dout;
	end
	assign co = dout[0]&&dout[2];

endmodule