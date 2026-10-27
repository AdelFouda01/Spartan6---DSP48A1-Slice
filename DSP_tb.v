module DSP_tb ();
    parameter A0REG = 0 , A1REG = 1 , B0REG = 0, B1REG = 1;
    parameter CREG = 1, DREG = 1, MREG = 1,PREG = 1, CARRYINREG = 1,CARRYOUTREG = 1,OPMODEREG = 1;
    parameter CARRYINSEL = "OPMODE5", B_INPUT = "DIRECT", RSTTYPE = "SYNC";

    reg [17:0] A, B, D, Bcin;
    reg [47:0] C, Pcin;
    reg [7:0] opmode;
    reg clk, carryin, rstA, rstB, rstM, rstP, rstC, rstD, rstcarryin, rstopmode, CEA, CEB, CEM, CEP, CEC, CED, CEcarryin, CEopmode;

    wire [17:0] Bcout;
    wire [47:0] P, Pcout;
    wire [35:0] M;
    wire carryout, carryoutf;

    DSP #(.A0REG (A0REG), .A1REG(A1REG), .B0REG(B0REG), .B1REG(B1REG), .CREG(CREG), .DREG(DREG), .MREG(MREG), .PREG(PREG), .CARRYINREG(CARRYINREG), .CARRYOUTREG(CARRYOUTREG), .OPMODEREG(OPMODEREG), .CARRYINSEL(CARRYINSEL), .B_INPUT(B_INPUT), .RSTTYPE(RSTTYPE) )
    DUT (A, B, C, D, clk, carryin, opmode, Bcin, rstA, rstB, rstM, rstP, rstC, rstD, rstcarryin, rstopmode, CEA, CEB, CEM, CEP, CEC, CED, CEcarryin, CEopmode, Pcin, Bcout, Pcout, P, M, carryout, carryoutf);


    //clk 
    initial begin 
        clk =0;
        forever 
            #1 clk = ~clk;
    end 

    initial begin 
        rstA = 1;
        rstB = 1; 
        rstM = 1;
        rstP = 1;
        rstC = 1;
        rstD = 1;
        rstcarryin = 1;
        rstopmode = 1;

        repeat (10) begin
            A = $random;
            B = $random; 
            D = $random; 
            Bcin = $random;
            C = $random;
            Pcin = $random;
            opmode = $random;
            carryin = $random;
            CEA = $random; 
            CEB = $random; 
            CEM = $random;
            CEP = $random;
            CEC = $random;
            CED = $random;
            CEcarryin = $random;
            CEopmode = $random;
            @ (negedge clk);

            if ((Bcout != 0) || (P != 0) || (Pcout != 0) || (M != 0) || (carryout != 0) || (carryoutf != 0)) begin
                $display ("Error in reset");
                $stop;
            end 
        end

        rstA = 0;
        rstB = 0; 
        rstM = 0;
        rstP = 0;
        rstC = 0;
        rstD = 0;
        rstcarryin = 0;
        rstopmode = 0;
        
        CEA = 1; 
        CEB = 1; 
        CEM = 1;
        CEP = 1;
        CEC = 1;
        CED = 1;
        CEcarryin = 1;
        CEopmode = 1;

        //PATH 1 

            opmode = 8'b11011101;
            A = 20; 
            B = 10; 
            C = 350;  
            D = 25;

            repeat (10) begin 
                Bcin = $random;
                Pcin = $random;
                carryin = $random;
                @ (negedge clk);
                @ (negedge clk);
                @ (negedge clk);
                @ (negedge clk);
                if ((Bcout != 'hf) || (P != 'h32) || (Pcout != 'h32) || (M != 'h12c) || (carryout != 0) || (carryoutf != 0)) begin
                    $display ("Error in PATH 1");
                    $stop;
                end
            end
        
        // PATH 2

            opmode = 8'b00010000;
            A = 20; 
            B = 10; 
            C = 350;  
            D = 25;

            repeat (10) begin 
                Bcin = $random;
                Pcin = $random;
                carryin = $random;
                @ (negedge clk);
                @ (negedge clk);
                @ (negedge clk);
                if ((Bcout != 'h23 ) || (P != 0) || (Pcout != 0) || (M != 'h2bc) || (carryout != 0) || (carryoutf != 0)) begin
                    $display ("Error in PATH 2");
                    $stop;
                end
            end
        
        //PATH 3
            opmode = 8'b00001010;
            A = 20; 
            B = 10; 
            C = 350;  
            D = 25;

            repeat (10) begin 
                Bcin = $random;
                Pcin = $random;
                carryin = $random;
                @ (negedge clk);
                @ (negedge clk);
                @ (negedge clk);
                if ((Bcout != 'ha ) || (P != 0) || (Pcout != 0) || (M != 'hc8) || (carryout != 0) || (carryoutf != 0)) begin
                    $display ("Error in PATH 3");
                    $stop;
                end
            end

        //PATH4
            opmode = 8'b10100111;
            A = 5;
            B = 6;
            C = 350;
            D = 25; 
            Pcin = 3000;

            repeat (10) begin 
                Bcin = $random;
                carryin = $random;
                @ (negedge clk);
                @ (negedge clk);
                @ (negedge clk);
                if ((Bcout != 'h6 ) || (P != 'hfe6fffec0bb1) || (Pcout != 'hfe6fffec0bb1) || (M != 'h1e) || (carryout != 1) || (carryoutf != 1)) begin
                    $display ("Error in PATH 4");
                    $stop;
                end
            end
        $stop;
    end
endmodule









