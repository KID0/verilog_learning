module fft (
	input clk,    // Clock
	input clk_en, // Clock Enable
	input rst_n,  // Asynchronous reset active low
	input [7:0] D_in,
	output [7:0] D_out
	
);
	// front half
	simple_ram_dual_clock ram1(

		);
	// latter half
	simple_ram_dual_clock ram2(

		);
	// the rom for Twiddle factor
	rom_case TF(

		);


endmodule

module simple_ram_dual_clock #(
  parameter DATA_WIDTH=8,                 //width of data bus
  parameter ADDR_WIDTH=8                  //width of addresses buses
)(
  input      [DATA_WIDTH-1:0] data,       //data to be written
  input      [ADDR_WIDTH-1:0] read_addr,  //address for read operation
  input      [ADDR_WIDTH-1:0] write_addr, //address for write operation
  input                       we,         //write enable signal
  input                       read_clk,   //clock signal for read operation
  input                       write_clk,  //clock signal for write operation
  output reg [DATA_WIDTH-1:0] q           //read data
);
    
  reg [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH-1:0]; // ** is exponentiation
    
  always @(posedge write_clk) begin //WRITE
    if (we) begin 
      ram[write_addr] <= data;
    end
  end
    
  always @(posedge read_clk) begin //READ
    q <= ram[read_addr];
  end
    
endmodule

module ROM_16bits(out, addr, CS); 

	output[15:0] out;
	input[3:0] addr;
	input CS;
	reg [15:0] out;
	reg [15:0] ROM[15:0];

	always @(negedge CS)
	begin
		// values set
		ROM[0]=16'h5601; ROM[1]=16'h3401;
		ROM[2]=16'h1801; ROM[3]=16'h0ac1;
		ROM[4]=16'h0521; ROM[5]=16'h0221;
		ROM[6]=16'h5601; ROM[7]=16'h5401;
		ROM[8]=16'h4801; ROM[9]=16'h3801;
		ROM[10]=16'h3001; ROM[11]=16'h2401;
		ROM[12]=16'h1c01; ROM[13]=16'h1601;
		ROM[14]=16'h5601; ROM[15]=16'h5401;
		// get value selected
		out=ROM[addr];

	end
endmodule



module rom_case (
    address , // Address input
    data    , // Data output
    read_en , // Read Enable 
    ce        // Chip Enable
);

    input [3:0] address;
    output [7:0] data;
    input read_en;
    input ce;

    reg [7:0] data ;
           
    always @ (ce or read_en or address)
    begin
      case (address)
        0 : data = 10;
        1 : data = 55;
        2 : data = 244;
        3 : data = 0;
        4 : data = 1;
        5 : data = 8'hff;
        6 : data = 8'h11;
        7 : data = 8'h1;
        8 : data = 8'h10;
        9 : data = 8'h0;
        10 : data = 8'h10;
        11 : data = 8'h15;
        12 : data = 8'h60;
        13 : data = 8'h90;
        14 : data = 8'h70;
        15 : data = 8'h90;
      endcase
    end

endmodule