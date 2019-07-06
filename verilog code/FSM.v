
module counter_fsm #(
	parameter w=8
)
(
	input [w-1:0] test,
	input clk,
	output reg Z
);
	reg [2:0] pre_state,next_state;
	parameter s0=3'b000,s1=3'b001,s2=3'b010,s3=3'b011,s4=3'b100;
	always@(posedge clk)
		pre_state<=next_state;
	always@(pre_state)
		case(pre_state)
			s0:begin next_state=s1;Z=1'b0; end
			s0:begin next_state=s2;Z=1'b0; end
			s0:begin next_state=s3;Z=1'b0; end
			s0:begin next_state=s4;Z=1'b0; end
			s0:begin next_state=s0;Z=1'b1; end
			default:begin next_state=s0; Z=1'b1; end
		endcase
endmodule


module counter_fsm_behavoir (
	input clk,
	output reg Z
);
	reg [2:0] state;
	always @(posedge clk) begin
		if (state==3'b100) begin
			state=3'b000;
			Z=1'b1;
		end
		else begin
			state=state+1'b1;
			Z=1'b0;
		end
	end
endmodule


module signal_fsm
	#(parameter s0=3'b000,s1=3'b001,s2=3'b010,s3=3'b011,s4=3'b100,s5=3'b101)
(
	input clk,rst_n,
	output reg dout
);
	reg [2:0] pre_state,next_state;
	always@(pre_state)
		case(pre_state)
			s0:begin
				dout=1'b0;
				next_state=s1;
			end
			s1:begin
				dout=1'b0;
				next_state=s2;
			end
			s2:begin
				dout=1'b1;
				next_state=s3;
			end
			s3:begin
				dout=1'b0;
				next_state=s4;
			end
			s4:begin
				dout=1'b1;
				next_state=s5;
			end
			s5:begin
				dout=1'b1;
				next_state=s0;
			end
			default next_state=s0;
		endcase
endmodule


module signal_generator
(
	input clk,rst_n,
	input [5:0] din,
	output reg dout
);
	reg [5:0] temp;
	always@(posedge clk) begin
		if (rst_n==1'b1) begin
			temp<=din;
		end
		else begin
			dout<=temp[5];
			temp<={temp[4:0],temp[5]};
		end
	end
endmodule

module detector_Moore
#(parameter s0=3'b000,s1=3'b001,s2=3'b010,s3=3'b011,s4=3'b100)
(
	input clk,rst_n,din,
	output reg dout
);
	reg [2:0] pre_state,next_state;
	always @(posedge clk or negedge rst_n) begin
		if (rst_n==1'b0) pre_state<=s0;
		else pre_state<=next_state;
	end
	always@(pre_state,din) begin
		next_state=2'bxx;
		dout=1'b0;
		case(pre_state)
			s0:begin
				dout=1'b0;
				if (din==1'b1) next_state=s0;
				else next_state=s1;
			end
			s1:begin
				dout=1'b0;
				if (din==1'b1) next_state=s2;
				else next_state=s1;
			end
			s2:begin
				dout=1'b0;
				if (din==1'b1) next_state=s0;
				else next_state=s3;
			end
			s3:begin
				dout=1'b0;
				if (din==1'b1) next_state=s4;
				else next_state=s1;
			end
			s4:begin
				dout=1'b1;
				if (din==1'b1) next_state=s0;
				else next_state=s3;
			end
		endcase
	end

endmodule