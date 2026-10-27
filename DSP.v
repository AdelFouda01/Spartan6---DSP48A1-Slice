module DSP (A, B, C, D, clk, carryin, opmode, Bcin, rstA, rstB, rstM, rstP, rstC, rstD, rstcarryin, rstopmode, CEA, CEB, CEM, CEP, CEC, CED, CEcarryin, CEopmode, Pcin, Bcout, Pcout, P, M, carryout, carryoutf);
    parameter A0REG = 0 , A1REG = 1 , B0REG = 0, B1REG = 1;
    parameter CREG = 1, DREG = 1, MREG = 1,PREG = 1, CARRYINREG = 1,CARRYOUTREG = 1,OPMODEREG = 1;
    parameter CARRYINSEL = "OPMODE5", B_INPUT = "DIRECT", RSTTYPE = "SYNC";

    input [17:0] A, B, D, Bcin;
    input [47:0] C, Pcin;
    input [7:0] opmode;
    input clk, carryin, rstA, rstB, rstM, rstP, rstC, rstD, rstcarryin, rstopmode, CEA, CEB, CEM, CEP, CEC, CED, CEcarryin, CEopmode;

    output [17:0] Bcout;
    output [47:0] P, Pcout;
    output [35:0] M;
    output carryout, carryoutf;

    wire [17:0] A1_wire, B1_wire, A2_wire, B3_wire, D_wire;
    reg [17:0] Pre_add_sub, B0_reg, B2_reg;
    wire [47:0] C_wire, P1_wire, concaten_wire;
    reg [47:0] X_reg, Z_reg, P0_reg;
    wire [35:0] M0_wire, M1_wire;
    wire CIN;
    reg CYI_reg, Cout;
    wire [7:0] opmode_wire;

    REG_MUX #(.REG_EN(OPMODEREG), .RSTTYPE(RSTTYPE), .WIDTH(8)) opmodereg (clk, rstopmode, CEopmode, opmode, opmode_wire);
    REG_MUX #(.REG_EN(DREG), .RSTTYPE(RSTTYPE), .WIDTH(18)) Dreg (clk, rstD, CED, D, D_wire);

    //B_INPUT
    always @ (*) begin
        if (B_INPUT == "DIRECT")
            B0_reg = B;
        else if (B_INPUT == "CASCADE")
            B0_reg = Bcin;
    end 

    REG_MUX #(.REG_EN(B0REG), .RSTTYPE(RSTTYPE), .WIDTH(18)) B0reg (clk, rstB, CEB, B0_reg, B1_wire);

    
    //pre addition and subtraction 
    always @ (*) begin 
        if (opmode_wire[6])
            Pre_add_sub = D_wire - B1_wire;
        else 
            Pre_add_sub = D_wire + B1_wire;
    end 

    //B1_reg_Input 
    always @ (*) begin 
        if (opmode_wire[4])
            B2_reg = Pre_add_sub;
        else 
            B2_reg = B1_wire;
    end

    REG_MUX #(.REG_EN(B1REG), .RSTTYPE(RSTTYPE), .WIDTH(18)) B1reg (clk, rstB, CEB, B2_reg, B3_wire);

    REG_MUX #(.REG_EN(A0REG), .RSTTYPE(RSTTYPE), .WIDTH(18)) A0reg (clk, rstA, CEA, A, A1_wire);

    REG_MUX #(.REG_EN(A1REG), .RSTTYPE(RSTTYPE), .WIDTH(18)) A1reg (clk, rstA, CEA, A1_wire, A2_wire);

    assign concaten_wire = {D_wire[11:0], A2_wire, B3_wire};

    assign M0_wire = B3_wire * A2_wire;

    REG_MUX #(.REG_EN(MREG), .RSTTYPE(RSTTYPE), .WIDTH(36)) Mreg (clk, rstM, CEM, M0_wire, M1_wire);

    //X_INPUT 
    always @ (*) begin 
        case (opmode_wire[1:0])
            0: X_reg = 0;
            1: X_reg = {{12{1'b0}},M1_wire};
            2: X_reg = P1_wire;
            3: X_reg = concaten_wire;
        endcase 
    end 

    REG_MUX #(.REG_EN(CREG), .RSTTYPE(RSTTYPE), .WIDTH(48)) Creg (clk, rstC, CEC, C, C_wire);

    //Z_INPUT 
    always @ (*) begin 
        case (opmode_wire[3:2])
            0: Z_reg = 0;
            1: Z_reg = Pcin;
            2: Z_reg = P1_wire;
            3: Z_reg = C_wire;
        endcase 
    end 

    //carryin cascade
    always @ (*) begin 
        case (CARRYINSEL)
            "OPMODE5": CYI_reg = opmode_wire[5];
            "CARRYIN": CYI_reg = carryin;  
            default: CYI_reg = 0;
        endcase
    end 

    REG_MUX #(.REG_EN(CARRYINREG), .RSTTYPE(RSTTYPE), .WIDTH(1)) CYIreg (clk, rstcarryin, CEcarryin, CYI_reg, CIN);





    //Post_add_sub
    always @ (*) begin 
        if (opmode_wire[7])
            {Cout,P0_reg} = Z_reg - (X_reg + CIN);  
        else 
           {Cout,P0_reg} = X_reg + Z_reg + CIN;
    end 

    REG_MUX #(.REG_EN(PREG), .RSTTYPE(RSTTYPE), .WIDTH(48)) Preg (clk, rstP, CEP, P0_reg, P1_wire);

    REG_MUX #(.REG_EN(CARRYOUTREG), .RSTTYPE(RSTTYPE), .WIDTH(1)) CYOreg (clk, rstcarryin, CEcarryin, Cout, carryout);

    assign carryoutf = carryout;
    
    assign Bcout = B3_wire;

    assign P = P1_wire;

    assign Pcout = P1_wire;

    assign M = M1_wire;
endmodule

 


   
   

   
   


    
    



