module i2c_slave (

    input  wire       clk, reset, scl,

    inout  wire       sda,

    input  wire [6:0] my_addr,

    output reg  [7:0] data_rx,

    output reg        data_ready

);

    parameter IDLE      = 3'b000;

    parameter GET_ADDR  = 3'b001;

    parameter SEND_ACK1 = 3'b010;

    parameter GET_DATA  = 3'b011;

    parameter SEND_ACK2 = 3'b100;



    reg [2:0] state;

    reg [3:0] bit_cnt;

    reg [7:0] addr_buffer;

    reg [7:0] data_buffer;

    reg       sda_out;

    reg       sda_en;



    reg scl_delayed, sda_delayed;

    wire scl_rising, scl_falling, start_detected;



    assign sda = (sda_en) ? sda_out : 1'bz;



    always @(posedge clk or posedge reset) begin

        if (reset) begin

            scl_delayed <= 1'b1;

            sda_delayed <= 1'b1;

        end else begin

            scl_delayed <= scl;

            sda_delayed <= sda;

        end

    end



    assign scl_rising     = (scl && !scl_delayed);

    assign scl_falling    = (!scl && scl_delayed);

    assign start_detected = (sda_delayed && !sda && scl);



    always @(posedge clk or posedge reset) begin

        if (reset) begin

            state       <= IDLE;

            bit_cnt     <= 0;

            data_rx     <= 8'h00;

            data_buffer <= 8'h00;

            addr_buffer <= 8'h00;

            sda_en      <= 1'b0;

            sda_out     <= 1'b1;

            data_ready  <= 1'b0;

        end else if (start_detected) begin

            state       <= GET_ADDR;

            bit_cnt     <= 7;

            data_ready  <= 1'b0;

            sda_en      <= 1'b0;

        end else begin

            case (state)

                IDLE: begin

                    sda_en     <= 1'b0;

                    data_ready <= 1'b0;

                end



                GET_ADDR: begin

                    if (scl_rising) begin

                        addr_buffer[bit_cnt] <= sda;

                        if (bit_cnt == 0) begin

                            state <= SEND_ACK1;

                        end else begin

                            bit_cnt <= bit_cnt - 1;

                        end

                    end

                end



                SEND_ACK1: begin

                                       if (scl_falling && (sda_en == 1'b0)) begin

                        if (addr_buffer[7:1] == my_addr) begin

                            sda_en  <= 1'b1;

                            sda_out <= 1'b0;

                        end else begin

                            state <= IDLE;

                        end

                    end

                                        else if (scl_falling && (sda_en == 1'b1)) begin

                        sda_en  <= 1'b0; 
                        bit_cnt <= 7;    
                        state   <= GET_DATA;

                    end

                end



                GET_DATA: begin

                    if (scl_rising) begin

                        data_buffer[bit_cnt] <= sda;

                        if (bit_cnt == 0) begin

                            state <= SEND_ACK2;

                        end else begin

                            bit_cnt <= bit_cnt - 1;

                        end

                    end

                end



                SEND_ACK2: begin

                    if (scl_falling) begin

                        sda_en     <= 1'b1;

                        sda_out    <= 1'b0; 

                        data_rx    <= data_buffer; 

                        data_ready <= 1'b1;

                        state      <= IDLE;

                    end

                end

                

                default: state <= IDLE;

            endcase

        end

    end

endmodule


