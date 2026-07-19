module i2c_master (

    input  wire       clk, reset, enable,

    input  wire [6:0] addr,

    input  wire [7:0] data,

    output reg        scl,

    inout  wire       sda,

    output reg        done

);

    parameter IDLE       = 3'b000;

    parameter START      = 3'b001;

    parameter ADDRESS    = 3'b010;

    parameter ACK_ADDR   = 3'b011;

    parameter WRITE_DATA = 3'b100;

    parameter STOP       = 3'b101;



    reg [2:0] state;

    reg [1:0] count; 

    reg [3:0] bit_cnt;

    reg       sda_out;

    reg       sda_en;

    reg [7:0] addr_rw;



    assign sda = (sda_en) ? sda_out : 1'bz;



    always @(posedge clk or posedge reset) begin

        if (reset) begin

            state   <= IDLE;

            count   <= 0;

            scl     <= 1'b1;

            sda_out <= 1'b1;

            sda_en  <= 1'b1;

            done    <= 1'b0;

            bit_cnt <= 0;

            addr_rw <= 0;

        end else begin

            case (state)

                IDLE: begin

                    scl     <= 1'b1;

                    sda_out <= 1'b1;

                    sda_en  <= 1'b1;

                    done    <= 1'b0;

                    count   <= 0;

                    if (enable) begin

                        addr_rw <= {addr, 1'b0};

                        state   <= START;

                    end

                end

                

                START: begin

                    sda_out <= 1'b0;

                    scl     <= 1'b1;

                    if (count == 2'b11) begin

                        count <= 0;

                        state <= ADDRESS;

                        bit_cnt <= 7;

                    end else begin

                        count <= count + 1;

                    end

                end



                ADDRESS: begin

                    if (count == 2'b00) begin

                        scl     <= 1'b0;

                        sda_en  <= 1'b1;

                        sda_out <= addr_rw[bit_cnt];

                        count   <= count + 1;

                    end else if (count == 2'b10) begin

                        scl     <= 1'b1;

                        count   <= count + 1;

                    end else if (count == 2'b11) begin

                        count   <= 0;

                        if (bit_cnt == 0) state <= ACK_ADDR;

                        else bit_cnt <= bit_cnt - 1;

                    end else begin

                        count <= count + 1;

                    end

                end



                ACK_ADDR: begin

                    if (count == 2'b00) begin

                        scl    <= 1'b0;

                        sda_en <= 1'b0; // ????? ???? ??? Slave ACK

                        count  <= count + 1;

                    end else if (count == 2'b10) begin

                        scl   <= 1'b1;

                        count <= count + 1;

                    end else if (count == 2'b11) begin

                        count   <= 0;

                        state   <= WRITE_DATA;

                        bit_cnt <= 7;

                    end else begin

                        count <= count + 1;

                    end

                end



                WRITE_DATA: begin

                    if (count == 2'b00) begin

                        scl     <= 1'b0;

                        sda_en  <= 1'b1;

                        sda_out <= data[bit_cnt];

                        count   <= count + 1;

                    end else if (count == 2'b10) begin

                        scl     <= 1'b1;

                        count   <= count + 1;

                    end else if (count == 2'b11) begin

                        count <= 0;

                        if (bit_cnt == 0) state <= STOP;

                        else bit_cnt <= bit_cnt - 1;

                    end else begin

                        count <= count + 1;

                    end

                end



                STOP: begin

                    if (count == 2'b00) begin

                        scl     <= 1'b0;

                        sda_en  <= 1'b1;

                        sda_out <= 1'b0;

                        count   <= count + 1;

                    end else if (count == 2'b10) begin

                        scl     <= 1'b1;

                        count   <= count + 1;

                    end else if (count == 2'b11) begin

                        sda_out <= 1'b1;

                        done    <= 1'b1;

                        state   <= IDLE;

                        count   <= 0;

                    end else begin

                        count <= count + 1;

                    end

                end

                default: state <= IDLE;

            endcase

        end

    end

endmodule


