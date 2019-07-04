`timescale 1ns/1ps  
module complex_tb;  
    reg [3:0] a,b,c,d;  
    wire [8:0] out_real;  
    wire [8:0] out_im;  
    complex U1(.a(a),.b(b),.c(c),.d(d),.out_real(out_real), 
                .out_im(out_im));  
                  
    initial  
    begin  
        a = 2; b = 2; c = 5; d = 4;
        dispaly_vars;
        #10  
        a = 4; b = 3; c = 2; d = 1;
        dispaly_vars;
        #10  
        a = 3; b = 2; c = 3; d = 4;  
        dispaly_vars;
    end
  
    task dispaly_vars;
      #1 $display("a:%0b, b:%0b, c:%0b, d:%0b, out_real:%0b, out_im:%0b",a, b, c, d,out_real,out_im);
    endtask
  
endmodule



  
module complex(a,b,c,d,out_real,out_im);  
    input [3:0] a,b,c,d;  
    output [8:0] out_real,out_im;  
    wire [7:0] sub1,sub2,add1,add2;  
      
    wallace U1(.x(a),.y(c),.out(sub1));  
    wallace U2(.x(b),.y(d),.out(sub2));  
    wallace U3(.x(a),.y(d),.out(add1));  
    wallace U4(.x(b),.y(c),.out(add2));  
  
    assign out_real = sub1 - sub2;  
    assign out_im = add1 + add2;  
      
endmodule  
  

module wallace(x,y,out);
	parameter size = 4;
	input [size - 1 : 0] x,y;
	output [2*size - 1 : 0] out;
	
    wire [size*size - 1 : 0] a;
    wire [1 : 0] b0,b1; 
    wire [1 : 0] c0,c1,c2,c3; 
    wire [5 : 0] add_a,add_b;  
    wire [6 : 0] add_out; 
    wire [2*size - 1 : 0] out;

    assign a = {x[3],x[2],x[3],x[1],x[2],x[3],x[0],x[1], 
                x[2],x[3],x[0],x[1],x[2],x[0],x[1],x[0]}  
                &{y[3],y[3],y[2],y[3],y[2],y[1],y[3],y[2]  
                ,y[1],y[0],y[2],y[1],y[0],y[1],y[0],y[0]}; 
    hadd U1(.x(a[8]),.y(a[9]),.out(b0)); 
    hadd U2(.x(a[11]),.y(a[12]),.out(b1));
    hadd U3(.x(a[4]),.y(a[5]),.out(c0)); 
    fadd U4(.x(a[6]),.y(a[7]),.z(b0[0]),.out(c1)); 
    fadd U5(.x(b1[0]),.y(a[10]),.z(b0[1]),.out(c2));
    fadd U6(.x(a[13]),.y(a[14]),.z(b1[1]),.out(c3));
      
      
    assign add_a = {c3[1],c2[1],c1[1],c0[1],c0[0],a[2]};  
    assign add_b = {a[15],c3[0],c2[0],c1[0],a[3],a[1]};  
    assign add_out = add_a + add_b;  
    assign out = {add_out,a[0]};  
  
endmodule  
  
module fadd(x,y,z,out);  
    input x,y,z;  
    output [1 : 0] out;  
    assign out = x + y + z;   
endmodule  
  
module hadd(x,y,out);  
    input x,y;  
    output [1 : 0] out;  
    assign out = x + y;  
endmodule



 
  

