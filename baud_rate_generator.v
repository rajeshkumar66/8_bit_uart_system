module baud_rate_generator(
  input wire clk,
  input wire write_enable,
  output wire rx_clk_en,
  output wire tx_clk_en
);
  parameter RX_ACC_MAX = (50000000)/(115200*16);
  parameter TX_ACC_MAX = (50000000)/115200;
  parameter tx_bits = $clog2(TX_ACC_MAX);
  parameter rx_bits = $clog2(RX_ACC_MAX);
  
  reg [rx_bits-1:0] rx_count = 0;
  reg [tx_bits-1:0] tx_count = 0;

  always @(posedge clk) begin
     if (write_enable) begin
        // Reset both counters when write_enable is high
        rx_count <= 0;
        tx_count <= 0;
     end else begin
        // Normal baud rate generation continues when write_enable is low
        if (rx_count == RX_ACC_MAX[rx_bits-1:0])
          rx_count <= 0;
        else
          rx_count <= rx_count + 1;

        if (tx_count == TX_ACC_MAX[tx_bits-1:0])
          tx_count <= 0;
        else
          tx_count <= tx_count + 1;
     end
  end

  assign rx_clk_en = (rx_count == 0);
  assign tx_clk_en = (tx_count == 0);

endmodule
