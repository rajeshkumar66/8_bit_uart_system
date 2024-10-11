`timescale 1ns/1ps  // 1ns time unit, 1ps time precision

module uart_tb;

  // Testbench signals
  reg clk;
  reg write_enable;
  reg [7:0] din;
  wire tx;
  wire tx_busy;
  wire [7:0] data_out;

  // Clock generation (50 MHz)
  initial begin
    clk = 0;
    forever #10 clk = ~clk;  // 50 MHz clock
  end

  // Instantiate the UART Top module
  uart_top dut (
    .clk(clk),
    .din(din),
    .write_enable(write_enable),
    .tx(tx),
    .tx_busy(tx_busy),
    .data_out(data_out)
  );

  // Task to transmit data
  task transmit(input [7:0] data);
    begin
      din = data;          // Load data into din
      write_enable = 1;    // Enable write
      #1000;                 // Wait for a short period to simulate transmission
      write_enable = 0;    // Disable write

      // Wait for transmission to complete
      wait(!tx_busy);
      #200000;                 // Allow some time for the data to be processed
    end
  endtask

  // Test procedure
  initial begin
    // Initial setup
    write_enable = 0;
    din = 8'h00;
    transmit(8'hA5);  // Test byte 0xA5
    transmit(8'h3C);  // Test byte 0x3C
    transmit(8'h7E);  // Test byte 0x7E
    transmit(8'hFF); 
    transmit(8'hC0);  // Test byte 0x7E
    transmit(8'hD5);
    transmit(8'h7B);  // Test byte 0x7E
    transmit(8'hFA);
     // Test byte 0xFF

    // Finish the simulation
    $finish;
  end

endmodule
