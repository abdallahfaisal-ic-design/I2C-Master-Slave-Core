module i2c_top (

    input  wire       clk, reset, start_en,

    input  wire [6:0] target_addr,

    input  wire [7:0] write_data,

    output wire [7:0] rx_data,

    output wire       rx_ready,

    output wire       master_done

);



     tri1 scl_bus;

    tri1 sda_bus;




    i2c_master master (

        .clk(clk),

        .reset(reset),

        .enable(start_en),

        .addr(target_addr),

        .data(write_data),

        .scl(scl_bus),

        .sda(sda_bus),

        .done(master_done)

    );



    i2c_slave slave (

        .clk(clk),

        .reset(reset),

        .scl(scl_bus),

        .sda(sda_bus),

        .my_addr(7'h50), 

        .data_rx(rx_data),

        .data_ready(rx_ready)

    );



endmodule

