// ELEX 7660 2020 Assigneent 4 Problem 1  
// simulation of a four phase handshake
// takes clk1, clk2, data1, and newdata1 that only asserted for one clk indicates change of data1 
// outputs busy1 (indicates a handshake is in progress), data2, dataready2(only asserted for one clk, indicates change of data2)
// can transimit up to 32 bits of data 
// Yanming Bu 2020/3/25
module fourPhaseHandshake #(
    parameter N = 32
) (
    input logic [N-1:0] data1,
    input logic newdata1, output logic busy1,
    output logic [N-1:0] data2,
    output logic dataready2,
    input logic clk1,clk2,reset_n
    );

    logic ack, req;
    logic ack_temp1, ack_temp2; //extra two flip flops to synchronize ack from clk2
    logic req_temp1, req_temp2;//extra two flip flops to synchronize req from clk1
    logic dataready2_reset;//controls the dataready2 only high for one clk cycle 
    logic req_posedge;//indicates a positive edge of req_temp2
    logic ack_posedge;//indicate a positive edge of ack_temp2

    always_ff @(posedge clk1, negedge reset_n) begin
        if (~reset_n) begin //reset all the variables 
            req <= 0;
            ack_temp1 <= 0;
            ack_temp2 <= 0;
            busy1 <= 0;
            ack_posedge <= 0;
        end else begin
            //req logic and busy1 logic 
            if (newdata1) begin
                //req and busy1 goes high when there is a newdata1 
                req <= 1;
                busy1 <= 1;
            end else if(ack_posedge) begin
                //req and busy1 goes low when there is a positive edge of ack_temp2
                req <= 0;
                busy1 <= 0;
            end

            //generating a ack_posedge to indicate a positive edge at ack_temp2 for one clk
            if(ack_temp1&&ack_temp2==0) begin
                ack_posedge <= 1;
            end
            if(ack_posedge) begin
                ack_posedge <= 0;
            end

            //two flip flop for ack from clk2 
            ack_temp1 <= ack;
            ack_temp2 <= ack_temp1;
        end
    end
    
    always_ff @(posedge clk2, negedge reset_n) begin
        if (~reset_n) begin//reset all variables in this flip flop 
            dataready2 <= 0;
            data2 <= 0;
            req_temp1 <= 0;
            req_temp2 <= 0;
            req_posedge <= 0;
            ack <= 0;
            dataready2_reset <= 0;
        end else begin
            //two flip flop for req logic from clk1
            req_temp1 <= req;
            req_temp2 <= req_temp1;

            //generate a req_posedge to indicate a positive edge at req_temp2 for one clk
            //clk data1 into data2 logic  
            if(req_temp1&&req_temp2==0)begin
                //detect a positive edge for req_temp2 next clk
                req_posedge <= 1;
            end
            if (req_posedge) begin
                //set dataready2 and dataready2_reset to high 
                dataready2 <= 1;
                dataready2_reset <= 1;
                req_posedge <= 0; //reset the req_posedge, make sure it only high for one clk
                data2 <= data1;//clock data1 into data2 
            end 
            //reset dataready2 
            if(dataready2_reset)begin 
                dataready2 <= 0;
                dataready2_reset <= 0;
            end

            //ack is high when req_temp2 is high 
            if(req_temp2) begin
                ack <= 1;
            end 
            else begin
                ack <= 0;
            end

        end
    end
    
endmodule