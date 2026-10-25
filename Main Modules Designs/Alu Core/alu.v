module alu (
    input  wire [31:0] SrcA,        
    input  wire [31:0] SrcB,        
    input  wire [2:0]  ALUControl,  
    output reg  [31:0] ALUResult,   
    output wire        Zero         
);
    always @(*) begin
        case (ALUControl)
            3'b000: ALUResult = SrcA & SrcB;                                  
            3'b001: ALUResult = SrcA | SrcB;                                  
            3'b010: ALUResult = SrcA + SrcB;                                  
            3'b110: ALUResult = SrcA - SrcB;                                 
            3'b111: ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 32'd1 : 32'd0;  
            default: ALUResult = 32'd0;                                        
        endcase
    end
    assign Zero = (ALUResult == 32'd0) ? 1'b1 : 1'b0;

endmodule
