// ELEX 7660 2020 Assigneent 4 Problem 1  
// a test bendch for fourPhaseHandshake module 
// test it with a 8 bit data 
// Yanming Bu 2020/3/25
module fourPhaseHandshake_tb();
    parameter N = 8; //only sending 8 bits of data 
    logic [N-1:0] data1;
    logic newdata1;
    logic busy1;
    logic [N-1:0] data2;
    logic dataready2;
    logic clk1,clk2,reset_n;

    fourPhaseHandshake#(N) dut(.*);

    initial begin
        //initialize all the data 
        clk1 = 0;
        clk2 = 0;
        newdata1 = 0;
        data1 = 0;
        
        //reset 1 clk2 cycle since clk2 is slower 
        reset_n = 0;
        repeat(1)@(negedge clk2);
        reset_n = 1;

        //looping through 10 sets of random data1 
        repeat(1)@(negedge clk1);
        for (int i=0; i<5; ++i) begin
            data1 = $urandom();//generate random data1
            //set newdata1 to be high at a negedge of clk1 for one clk indicates the data1 has changed
            newdata1 = 1;
            repeat(1)@(negedge clk1);
            newdata1 = 0;
            //wait until busy1 is zero before steping into the next loop 
            wait(busy1 == 0) @(negedge clk1);
        end

        $stop;
    end 

    //generate two clocks
    always begin
        #1ms clk1 = ~clk1;
        #5ms clk2 = ~clk2;//clk2 is a bit slower than clk1 
    end
    
endmodule