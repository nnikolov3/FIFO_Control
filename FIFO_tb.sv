// Testbench for FIFO

`timescale 1ns/1ns

module fifo_tb;	// No need for Ports

  logic rst;
  logic clk;
  logic wr;
  logic rd;
  logic wr_en;
  logic rd_en;
  logic overflow;
  logic underflow;
  logic [5:0] rd_ptr;
  logic [5:0] wr_ptr;
  logic [5:0] check;
  logic emp;
  logic full;

//-------------- Instantiate the module to be tested
  fifo UUT(
    .rst(rst),
    .clk(clk),
    .wr(wr),
    .rd(rd),
    .rd_en(rd_en),
    .wr_en(wr_en),
    .rd_ptr(rd_ptr),
    .wr_ptr(wr_ptr),
    .emp(emp),
    .full(full),
    .overflow(overflow),
    .underflow(underflow),
    .check(check)
  );

  initial begin 
	clk <=0;
	forever #5 clk <= ~clk;
  end

initial begin
	$monitor("Empty=%d, Full= %d, Read Pointer = %d, Write Pointer = %d, Check = %b, Overflow = %b", emp, full, rd_ptr, wr_ptr,check,overflow);
end 

  initial begin
#5 rst <= 1;
for (int i = 0 ; i < 34 ; i++) begin
	#5 wr <= 1;
end
#50
//------------------    
for (int p = 0 ; p < 34 ; p++) begin
	#5 rd <= 1;
end
#50
for (int p = 0 ; p < 34 ; p++) begin
      #5 rd <= 1;
      #5 wr <= 1;
    end
#50
for (int i = 0 ; i < 10 ; i++) begin
        #5 wr = 1;
		
end
#50
//--------------------  
for (int p = 0 ; p < 15 ; p++) begin
     	 #5 rd <= 1;

end
#100 $finish;

end
endmodule