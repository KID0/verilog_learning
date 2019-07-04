module code83p(
	input [7:0] din,
	input en,
	output reg [2:0] dout,
	output reg ys,yex
);
	always@(din or en) begin
		if (en) {dout,ys,yex}<={3'b111,1'b1,1'b1};
		else begin
			casex(din)
				8'b0???????:{dout,ys,yex}<={3'b000,1'b1,1'b0};
				8'b10??????:{dout,ys,yex}<={3'b001,1'b1,1'b0};
				8'b110?????:{dout,ys,yex}<={3'b010,1'b1,1'b0};
				8'b1110????:{dout,ys,yex}<={3'b011,1'b1,1'b0};
				8'b11110???:{dout,ys,yex}<={3'b100,1'b1,1'b0};
				8'b111110??:{dout,ys,yex}<={3'b101,1'b1,1'b0};
				8'b1111110?:{dout,ys,yex}<={3'b110,1'b1,1'b0};
				8'b11111110:{dout,ys,yex}<={3'b111,1'b1,1'b0};
				8'b11111111:{dout,ys,yex}<={3'b111,1'b0,1'b1};
			endcase
		end
	end

endmodule