module REG_MUX (clk, rst, CE, din, dout);
    parameter REG_EN = 1, RSTTYPE = "SYNC", WIDTH = 18;
    input [WIDTH-1:0] din;
    input clk, rst, CE;
    output [WIDTH-1:0] dout;
    reg  [WIDTH-1:0] dreg;

    generate
        if (RSTTYPE == "SYNC") begin
            always @ (posedge clk) begin
                if (rst)
                    dreg <= 0;
                else if (CE == 1)
                    dreg <= din;
            end
        end  
        else if (RSTTYPE == "ASYNC") begin
            always @ (posedge clk or posedge rst) begin
                if (rst)
                    dreg <= 0;
                else if (CE == 1)
                    dreg <= din;
            end 
        end
    endgenerate

    assign dout = (REG_EN == 1 ) ? dreg : din;
endmodule
