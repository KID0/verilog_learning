`timescale 1ns/1ps
module MUX_tb;  
    reg [3:0] data;
    reg [1:0] sel;
    wire out;

    MUX U1(.data(data),.sel(sel),.out(out));
                  
    initial  
    begin  
        data = 4'b0101;
        dispaly_vars;
        #10
        sel = 4'b01;
        dispaly_vars;
        #10
        sel = 30;
        dispaly_vars;
        #10
        sel = 4'b11;
        dispaly_vars;        
    end
  
    task dispaly_vars;
      #1 $display("data:%b, sel:%b, out:%b",data, sel, out);
    endtask
  
endmodule


module MUX (
	input [3:0] data,
	input [1:0] sel,
	output reg out
);

	always @(data or sel)
		case(sel)
			2'b00:out<=data[0];
			2'b01:out<=data[1];
			2'b10:out<=data[2];
			2'b11:out<=data[3];
		endcase // sel

endmodule