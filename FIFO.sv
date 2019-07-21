//**********************************
//-----------FIFO in System Verilog
//**********************************
/************************************
-------------*/
module fifo (

	clk, // controller clock
	rst, // Asynch global reset
	wr, // From external device wanting to write data into FIFO
	rd, // From external device wanting to read data from FIFO
	wr_en, // to FIFO as write signal
	rd_en, // to FIFO as read signal
	rd_ptr,// read address bus to FIFO
	wr_ptr, // write address bus to FIFO
	emp, // FIFO is empty
	full, // FIFO is full
	overflow,
	underflow,
	check
	);

//---------------------FIFO constants
parameter addr_width = 8;// data bus width
parameter buf_size = 32;// address size of the RAM

//---------------------input output port declaration 
input  logic rst, clk, wr, rd;
output logic wr_en, rd_en, overflow;
output logic [5:0] rd_ptr;
output logic [5:0] wr_ptr;
output logic [5:0] check;
output logic underflow;
//--------------------- Empty, Full
output logic emp, full;
  
//*********************************************************
//----------------------At reset
//*********************************************************
always_ff @(posedge rst)
	begin
	if (rst)// at reset
          begin
		emp  <= 1; // empty is high
		full <= 0;// full is low
		wr_ptr <= 0; // reset the write pointer
		rd_ptr <= 0; // reser the read pointer
		rd_en <= 1 ;
		wr_en <= 1;
          end 

end
//************************************************************
//----------------------wr & wr_en
//**********************************************************
always_ff @(posedge clk)
	begin
      if (wr)// if attrmpting to write
          begin
                	if (~full) begin
				wr_en <= 1; // if not full then write
			end
			else if (full)  wr_en <= 0; // else disenable write
          end
end

//********************************************************** 
//-----------------------rd & rd_en
//**********************************************************
always_ff @(posedge clk)
		begin
			if (rd) // If an external device wishes to read data
          			begin
            		if (~emp) rd_en <= 1;// if it is not empty then read
			else if (emp) rd_en <= 0;// controller asserts rd_en only if emp is deasserted
          		end
end

//********************************************************** 
//-----------------------Setting rd_ptr
//**********************************************************
always_ff @(posedge clk )
  		begin
			if ( emp == 1 && full == 1) // reset when gets empty after reading
			begin
				emp  <= 1; // empty is high
				full <= 0;// full is low
				wr_ptr <= 0; // reset the write pointer
				rd_ptr <= 0; // reser the read pointer
				rd_en <= 1 ;
				wr_en <= 1;
			end 
        	  	if (rd_en) begin
			rd_ptr <= rd_ptr + 1; // increment pointer for read
			check <= (rd_ptr ^ wr_ptr );// check if empty  and then proceed
      			if (check == 6'b000000)begin
				emp <= 1;
				rd_en <= 0;
				$display("EMPTY!!");
				end
			end
end  
//********************************************************** 
//-----------------------Setting wr_ptr
//**********************************************************
always_ff @(posedge clk)
  		begin
      			if (wr_en) begin
			wr_ptr <= wr_ptr + 1; // increment pointer for write
			emp <= 0;
			check <= (rd_ptr ^ wr_ptr);// check if full and then proceed
      			overflow <= (check >> 5);
      			if (overflow == 1) begin
				full <= 1; // it is full 
				wr_en <= 0;
				$display("FULL!!!!!!!!!");
			end
				
			end
			
end


endmodule