 
    alu u_alu (
        .SrcA       (rd1),          
        .SrcB       (src_b),        
        .ALUControl (alu_control),  
        .ALUResult  (alu_result),   
        .Zero       (zero)          
    );