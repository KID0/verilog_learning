// my code
module traffic_light
#(parameter red=3'b001,green=3'b010,yellow=3'b100)
(
	input clk,rst,
	output reg [2:0] light
);
	reg [6:0] counter;
	
	always@(posedge clk, negedge rst) begin
		if(rst==1'b0) begin
			counter=0;
			light=3'b000;
		end
		else begin
			counter=counter+1;
			case(counter)
				0: begin
					light=red;
				end
				15: begin
					light=green;
				end
				30: begin
					light=yellow;
				end
				45: begin
					counter=0;
				end
				default:light=light;
			endcase
		end
	end


endmodule

// form https://blog.csdn.net/xunzhaotadeyingzi/article/details/80052902
// I do not like it


module signal_light(clk,rst,count,light1,light2);
       input clk,rst;
       input [5:0]count;
       output light1,light2;
       reg[2:0] light1,light2;
       reg[2:0]state;
       
       parameter Idle=3'b000,
                   S1=3'b001,
                   S2=3'b010,
                   S3=3'b011,
                   S4=3'b100;
                   
                                
       always@(posedge clk)
       begin
            if(!rst)
               begin
                 state<=Idle;
                 light1<=3'b010;
                 light2<=3'b010;
                 end
            else
                case(state)
                Idle: if(rst)
                       begin
                         state<=S1;
                         light1<=3'b100;
                         light2<=3'b001;
                       end
                  
                S1:  if(count=='d25)
                       begin
                         state<=S2;
                         light1<=3'b100;
                         light2<=3'b010;
                       end
               
                       
                S2:  if(count=='d30)
                       begin
                         state<=S3;
                         light1<=3'b001;
                         light2<=3'b100;
                       end
                S3:  if(count=='d55)
                       begin
                         state<=S4;
                         light1<=3'b010;
                         light2<=3'b100;
                       end   
                S4:  if(count=='d60)
                       begin
                         state<=S1;
                         light1<=3'b100;
                         light2<=3'b001;
                       end
                default:    state<=Idle;
                endcase
       end
endmodule

                   


module counter(clk,rst,count);
   output count; 
   input clk,rst; 
   reg[5:0] count;
   always@(posedge clk or negedge rst)
         begin
              if(!rst)
              count<='d0;    
              else if(count=='d60)        
              	count<='d0;    
              else          
              	count<=count+1;
      end  

  endmodule


module signal_light_top(count,clk,rst,light1,light2);
  input clk,rst;

  output[2:0] light1,light2；

  output[5:0]count;
  wire[5:0] count;   
  
  counter u2(clk,rst,count);
  signal_light u1(clk,rst,count,light1,light2);
  
    
 endmodule



// below is form https://www.stepfpga.com/doc/10._%E4%BA%A4%E9%80%9A%E7%81%AF

// 首先是时钟分频部分
module divide
(
	//INPUT
	clk			,
	rst_n			,
	//OUTPUT
	clkout			
);
	//*******************
	//DEFINE PARAMETER
	//*******************
	parameter			WIDTH	=	3;
	parameter			N		=	5;
 
	//*******************
	//DEFINE INPUT
	//*******************
	input 	clk,rst_n;     
 
    //*******************
	//DEFINE OUTPUT
	//*******************
	output	clkout;
 
	//********************
	//OUTPUT ATTRIBUTE
	//********************
	//REGS
	reg 	[WIDTH-1:0]		count_p,count_n;
	reg						clk_p,clk_n;
 
	assign clkout = (N==1)?clk:(N[0])?(clk_p&clk_n):clk_p;
 
	//Sequential logic style
	always @ (posedge clk)
		begin
			if(!rst_n)
				count_p<=0;
			else if (count_p==(N-1))
				count_p<=0;
			else count_p<=count_p+1;
		end
 
	always @ (negedge clk)
		begin
			if(!rst_n)
				count_n<=0;
			else if (count_n==(N-1))
				count_n<=0;
			else count_n<=count_n+1;
		end
 
	always @ (posedge clk)
		begin
			if(!rst_n)
				clk_p<=0;
			else if (count_p<(N>>1))  
				clk_p<=0;
			else 
				clk_p<=1;
		end
 
	always @ (negedge clk)
		begin
			if(!rst_n)
				clk_n<=0;
			else if (count_n<(N>>1))  
				clk_n<=0;
			else 
				clk_n<=1;
		end
endmodule     


 
 
module traffic
(
	clk		,    //时钟
	rst_n		,    //复位
	out		     //三色led代表交通灯
);
 
	input 	clk,rst_n;     
	output	reg[5:0]	out;
 
	parameter      	S1 = 4'b00,    //状态机状态编码
					S2 = 4'b01,
					S3 = 4'b10,
					S4 = 4'b11;
 
	parameter	time_s1 = 4'd15, //计时参数
				time_s2 = 4'd3,
				time_s3 = 4'd10,
				time_s4 = 4'd3;
	//交通灯的控制
	parameter	led_s1 = 6'b101011, // LED2 绿色 LED1 红色
				led_s2 = 6'b110011, // LED2 蓝色 LED1 红色
				led_s3 = 6'b011101, // LED2 红色 LED1 绿色
				led_s4 = 6'b011110; // LED2 红色 LED1 蓝色
 
	reg 	[3:0] 	timecont;
	reg 	[1:0] 	cur_state,next_state;  //现态、次态
 
	wire			clk1h;  //1Hz时钟
 
	//产生1秒的时钟周期
	divide #(.WIDTH(32),.N(12000000)) CLK1H (
					.clk(clk),
					.rst_n(rst_n),
					.clkout(clk1h));
	//第一段 同步逻辑 描述次态到现态的转移
	always @ (posedge clk1h or negedge rst_n)
	begin
		if(!rst_n) 
			cur_state <= S1;
        else 
			cur_state <= next_state;
	end
	//第二段 组合逻辑描述状态转移的判断
	always @ (cur_state or rst_n or timecont)
	begin
		if(!rst_n) begin
		        next_state = S1;
			end
		else begin
			case(cur_state)
				S1:begin
					if(timecont==1) 
						next_state = S2;
					else 
						next_state = S1;
				end
 
                S2:begin
					if(timecont==1) 
						next_state = S3;
					else 
						next_state = S2;
				end
 
                S3:begin
					if(timecont==1) 
						next_state = S4;
					else 
						next_state = S3;
				end
 
                S4:begin
					if(timecont==1) 
						next_state = S1;
					else 
						next_state = S4;
				end
 
				default: next_state = S1;
			endcase
		end
	end
	//第三段  同步逻辑 描述次态的输出动作
	always @ (posedge clk1h or negedge rst_n)
	begin
		if(!rst_n==1) begin
			out <= led_s1;
			timecont <= time_s1;
			end 
		else begin
			case(next_state)
				S1:begin
					out <= led_s1;
					if(timecont == 1) 
						timecont <= time_s1;
					else 
						timecont <= timecont - 1;
				end
 
				S2:begin
					out <= led_s2;
					if(timecont == 1) 
						timecont <= time_s2;
					else 
						timecont <= timecont - 1;
				end
 
				S3:begin
					out <= led_s3;
					if(timecont == 1) 
						timecont <= time_s3;
					else 
						timecont <= timecont - 1;
				end
 
				S4:begin
					out <= led_s4;
					if(timecont == 1) 
						timecont <= time_s4;
					else 
						timecont <= timecont - 1;
				end
 
				default:begin
					out <= led_s1;
					end
			endcase
		end
	end
endmodule