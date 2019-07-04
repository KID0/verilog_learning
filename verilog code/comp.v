`timescale 1ns/1ps

module comp_1b_tb;
	reg a,b;
	wire agb,aeb,alb;

	comp_1b U0(
		.a(a),.b(b),.agb(agb),.aeb(aeb),.alb(alb)
	);

	initial begin
			a=1'b0;b=1'b0;
		display_vars;
		#10 a=1'b1;b=1'b0;
		display_vars;
		#10 a=1'b1;b=1'b1;
		display_vars;
		#10 a=1'b0;b=1'b1;
		display_vars;
	end

	task display_vars;
		$display("a:%b,b:%b,agb:%b,aeb:%b,alb:%b",a,b,agb,aeb,alb);
	endtask
endmodule




module comp_1b(
	input a,b,
	output wire agb,aeb,alb
);

	assign agb = a&(~b);
	assign aeb = a^(~b);
	assign alb = (~a)&b;

endmodule