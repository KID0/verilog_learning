module tb_top;
	reg clk,rst_n;
	wire co;
	wire [3:0] dout;

	counter_12 inst_counter_12 (.clk(clk), .rst_n(rst_n), .co(co), .dout(dout));

	always begin
		#10 clk=1'b1;
		display_var;
		#10 clk=1'b0;
		display_var;
	end

	initial begin
		clk=1'b0;
		rst_n=1'b0;
		#20 rst_n=1'b1;
		#500 $finish;
	end

	task display_var;
		#1 $display("clk:%b,dout:%b,rst_n:%b", clk,dout,rst_n);
	endtask
endmodule


module counter_12(
	input clk,rst_n,
	output co,
	output reg [3:0] dout
);
	always @(posedge clk) begin
		if (rst_n==1'b0) dout<=4'b0000;
		else if(dout==4'b1001) dout<=4'b0000;
		else dout<=dout+1'b1;
	end
	assign co = dout[3]&&dout[1]&&dout[0];

endmodule


// *************new module********************

module counter60 (
	input clk,rst_n,en,
	output reg [7:0] dout,
	output co
);
	wire co10,co10_1,co6;
	wire [3:0] dout10,dout6;

	counter10 u1 (.clk(clk), .rst_n(rst_n), .en(en), .dout(dout10), .co(co10_1));
	counter6 u2 (.clk(clk), .rst_n(rst_n), .en(co10), .dout(dout6), .co(co6));
	and u3(co,co10,co6);
	and u4(co10,en,co10_1);
	assign dout ={dout6,dout10} ;

endmodule

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
