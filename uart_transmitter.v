module uart_transmitter(
   input wire clk,
   input wire write_enable,
   input wire [7:0] data_in,
   input wire tx_clk_en,
   output reg tx,
   output wire tx_busy
   );
   parameter START=2'b00;
   parameter DATA=2'b01;
   parameter STOP=2'b10;
   parameter NEXT=2'b11;
   reg [7:0] data;
   reg [2:0] state=START;
   reg [2:0] bitpos=0;
   
   always @(posedge clk) begin
      case(state) 
         START:begin
              if(tx_clk_en) begin 
                 if(write_enable) begin
                    state<=DATA;
                    data<=data_in;
                    bitpos<=0;
                    tx<=0;
                 end
              end
              end
         DATA:begin
              if(tx_clk_en) begin
                 if(bitpos==7)
                    state<=STOP;
                 else
                    bitpos<=bitpos+1;
                 tx<=data[bitpos];
              end
              end
         STOP:begin
                 if(tx_clk_en) begin
                    tx<=1;
                    state<=NEXT;
                 end
                 end
         NEXT:begin
                 if(tx_clk_en) begin
                    tx<=0;
                    state<=START;
                 end
                 end
         default:state<=START;
      endcase
   end   
   assign tx_busy=(state!=START);
   endmodule  
