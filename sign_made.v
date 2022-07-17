module sign_made(
	sys_clk,
	IRF,
	IRF_sign);

	//---Ports declearation: generated by Robei---
	input sys_clk;
	input IRF;
	output IRF_sign;

	wire sys_clk;
	wire IRF;
	reg IRF_sign;

	//----Code starts here: integrated by Robei-----
	//parameter       MADE1 = 800000000;
	parameter       MADEFZ = 800000000;
	
	reg         [31:0]      made_cnt = 0;
	
	reg                         IRF_m_sign;
	
	always@(posedge sys_clk) begin
	         if(IRF_m_sign) begin
	                  if(made_cnt < MADEFZ) begin
	                         IRF_sign <= 1;
	                        made_cnt = made_cnt + 1; 
	                  end
	                  else begin
	                        made_cnt = made_cnt + 1; 
	                  end
	         end
	        else begin
	                  made_cnt <= 0;
	                  IRF_sign <= 0;
	        end
	
	end
	
	always@(posedge sys_clk) begin
	        if(!IRF) begin
	             IRF_m_sign <= 1;
	        end
	        else if(made_cnt == MADEFZ) begin
	             IRF_m_sign <= 0;
	        end
	        else begin
	             IRF_m_sign <= IRF_m_sign;
	        end
	
	end
	
	
	
endmodule    //sign_made
