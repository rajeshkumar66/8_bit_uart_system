module uart_top(
   input wire clk,
   input wire [7:0] din,
   input write_enable,
   output wire tx,
   output wire tx_busy,
   output wire [7:0] data_out  
   );
   wire tx_clk_en,rx_clk_en,rdy_clr,tx_over;
   baud_rate_generator uart_baud(
      .clk(clk),
      .tx_clk_en(tx_clk_en),
      .rx_clk_en(rx_clk_en)
      );
   uart_transmitter uart_transmit(
      .clk(clk),
      .data_in(din),
      .write_enable(write_enable),
      .tx_clk_en(tx_clk_en),
      .tx(tx),
      .tx_busy(tx_busy)
      );
   uart_receiver uart_receive(
      .clk(clk),
      .rx(tx),
      .rx_clk_en(rx_clk_en),
      .data_out(data_out),
      .rdy_clr(rdy_clr),
      .tx_over(tx_busy)
      );
   endmodule 
