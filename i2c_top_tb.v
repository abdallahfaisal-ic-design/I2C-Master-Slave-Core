
`timescale 1ns / 1ps



module i2c_top_tb;



    // Parameters

    parameter CLK_PERIOD = 20; // 50 MHz Clock



    // Testbench Signals

    reg        clk;

    reg        reset;

    reg        start_en;

    reg  [6:0] target_addr;

    reg  [7:0] write_data;

    wire [7:0] rx_data;

    wire       rx_ready;

    wire       master_done;



    // Instantiate Unit Under Test (UUT)

    i2c_top uut (

        .clk(clk),

        .reset(reset),

        .start_en(start_en),

        .target_addr(target_addr),

        .write_data(write_data),

        .rx_data(rx_data),

        .rx_ready(rx_ready),

        .master_done(master_done)

    );



    // Clock Generation

    always begin

        #(CLK_PERIOD / 2) clk = ~clk;

    end



    // Main Test Stimulus

    initial begin

       

        clk         = 0;

        reset       = 1;

        start_en    = 0;

        target_addr = 7'h00;

        write_data  = 8'h00;




        #(CLK_PERIOD * 5);

        reset = 0;

        #(CLK_PERIOD * 2);

        $display("[TB] --- Starting I2C Write Transfer ---");

        

        @(posedge clk);

        target_addr = 7'h50;  

        write_data  = 8'hA5;  

        start_en    = 1'b1;   
        

        @(posedge clk);

        start_en    = 1'b0;   


        @(posedge master_done);

        

        #(CLK_PERIOD * 5); 




        $display("[TB] Checking I2C Results...");

        if (rx_ready && (rx_data == 8'hA5)) begin

            $display("[TB] SUCCESS: I2C Transfer Passed perfectly!");

            $display("[TB] Slave Successfully Received: 8'h%h", rx_data);

        end else begin

            $display("[TB] ERROR: Transfer Failed or Data Mismatch!");

            $display("[TB] Slave rx_ready status: %b", rx_ready);

            $display("[TB] Slave Data: 8'h%h (Expected: 8'hA5)", rx_data);

        end




        #(CLK_PERIOD * 20);

        $display("[TB] I2C Simulation Finished.");

        $stop;

    end



endmodule

