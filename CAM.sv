module CAM(
    input logic clk,rst,
    input logic [7:0]search_data,
    input logic [7:0]write_data,
    input logic search_en,
    input logic write_en,
    input logic [9:0]write_addr,
    output logic match,
    output logic [9:0]match_address
    );
    int i,j,k;
    logic [7:0]mem[0:1023];
    logic [1023:0]match_vector;

    always_ff@(posedge clk) begin
        if(rst) begin
            for( i = 0; i < 1024; i ++) begin
                mem[i] <= 8'b00000000;
            end
        end else if(write_en) begin
                mem[write_addr] <= write_data;
            end 
        end
// pattern matching circuit for matching the data-byte 
    always_comb begin
         if(search_en) begin
            for(j = 0; j < 1024; j++) begin
                match_vector[j] = &(~(mem[j] ^ search_data));
            end
         end
    end

// priority encoder 
    always_comb begin
        for(k = 0; k < 1024; k++) begin
            if(match_vector[k]) begin
                match_address = k;
                match = '1;
                break;
            end else begin
                match = '0;
                match_address = 10'b0;
            end
        end
    end
endmodule
