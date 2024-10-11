module uart_receiver(
    input wire clk,
    input wire rx,
    input wire rx_clk_en,
    input tx_over,
    output reg [7:0] data_out,
    output reg rdy_clr
);

    parameter START = 2'b00;
    parameter DATA = 2'b01;
    parameter STOP = 2'b10;

    reg [2:0] state = START;
    reg [3:0] bitpos = 0;
    reg [3:0] samples = 0;
    reg [7:0] data;
    // Initialize data_out
    initial begin
        data_out = 8'b0; // Initialize data_out to a known state
    end

    always @(posedge clk) begin
        case(state)
            START: begin
                rdy_clr <= 0;
                if(tx_over) begin
                   if (rx == 0 && rx_clk_en) begin 
                      samples <= samples + 1;
                      if (samples == 7) begin
                        state <= DATA;      // Move to DATA state after 7 samples
                        samples <= 0;       // Reset sample count
                        bitpos <= 0;        // Reset bit position
                      end
                   end
                end
            end
            
            DATA: begin
                if (rx_clk_en) begin
                    samples <= samples + 1;
                    if (samples == 15) begin
                        data[bitpos] <= rx;  // Capture the data bit
                        bitpos <= bitpos + 1;     // Move to the next bit
                        samples <= 0;            // Reset sample count
                        if (bitpos == 8) begin
                           state <= STOP;
                           bitpos<=0;  
                           data_out<=data;         // Move to STOP state after 8 bits
                      end
                    end
                end
            end
            
            STOP: begin
                if(rx_clk_en) begin
                   samples <= samples + 1;
                   if (samples == 15 ) begin
                       if (rx == 1) begin 
                          rdy_clr <= 0;       // Move to NEXT state if stop bit is valid
                       end
                   end
                   if(!tx_over) begin
                       state <= START;
                       data_out<=0;
                       bitpos<=0;
                       samples<=0;
                   end
                end
                end
            default: begin
                state <= START;          // Return to START state
                rdy_clr <= 0;            // Clear rdy_clr in default case
                data_out <= 8'b0;        // Reset data_out to avoid unknown state
            end
        endcase
    end
endmodule
