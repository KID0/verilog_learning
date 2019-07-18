module FIFO_buffer(
	input clk,rst,
	input write_to_stack,read_from_stack,
	input [7:0] Data_in,
	output [7:0] Data_out
);
	wire stack_full,stack_empty;
	wire [2:0] addr_in,addr_out;

	ram_dual inst_ram_dual
		(
			.q        (q),
			.d        (d),
			.addr_in  (addr_in),
			.addr_out (addr_out),
			.we       (we),
			.rd       (rd),
			.clk1     (clk1),
			.clk2     (clk2)
		);
		
	FIFO_control #(
			.stack_width(stack_width),
			.stack_height(stack_height),
			.stack_ptr_width(stack_ptr_width)
		) inst_FIFO_control (
			.write_to_stack  (write_to_stack),
			.read_from_stack (read_from_stack),
			.clk             (clk),
			.rst             (rst),
			.stack_full      (stack_full),
			.stack_empty     (stack_empty),
			.read_ptr        (read_ptr),
			.write_ptr       (write_ptr)
		);


module FIFO_control
#(parameter stack_width=8,stack_height=8,stack_ptr_width=3)
(
	input write_to_stack,read_from_stack,
	input clk,rst,
	output stack_full,stack_empty,
	output reg [stack_ptr_width-1:0] read_ptr,write_ptr
);
	reg [stack_ptr_width:0] ptr_gap;
	reg [stack_ptr_width-1:0] data_out;
	reg [stack_ptr_width-1:0] stack [stack_ptr_width-1:0];

	assign stack_full = (ptr_gap==stack_height);
	assign stack_empty = (ptr_gap==0);

	always@(posedge clk,posedge rst) begin
		if(rst) begin
			data_out<=0;
			read_ptr<=0;
			write_ptr<=0;
			ptr_gap<=0;
		end
		else if ((write_to_stack)&&(!stack_full)&&(!read_from_stack))begin
			write_ptr<=write_ptr+1;
			ptr_gap<=ptr_gap+1;
		end
		else if ((!write_to_stack)&&(!stack_full)&&(read_from_stack))begin
			read_ptr<=read_ptr+1;
			ptr_gap<=ptr_gap-1;
		end
		else if ((write_to_stack)&&(stack_empty)&&(read_from_stack))begin
			write_ptr<=write_ptr+1;
			ptr_gap<=ptr_gap+1;
		end
		else if ((write_to_stack)&&(stack_full)&&(read_from_stack))begin
			read_ptr<=read_ptr+1;
			ptr_gap<=ptr_gap-1;
		end
		else if ((write_to_stack)&&(!stack_full)&&(!stack_empty)&&(read_from_stack))begin
			read_ptr<=read_ptr+1;
			write_ptr<=write_ptr+1;
		end

	end

endmodule


module ram_dual(
	output reg [7:0] q,
	input [7:0] d,
	input [2:0] addr_in,addr_out,
	input we,rd,clk1,clk2
);
	reg [7:0] mem [7:0];
	always @(posedge clk1) begin
		if(we) mem[addr_in]<=d;
	end
	always @(posedge clk2) begin
		if(rd) q<=mem[addr_out];
	end
endmodule

