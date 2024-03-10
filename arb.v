// module custom_adder #(parameter WIDTH = 8)(
//     input [WIDTH-1:0] a,
//     input [WIDTH-1:0] b,
//     output reg [WIDTH-1:0] result
// );
// integer i;
// integer carry = 0;
// always @* begin
//     for (i = WIDTH-1; i >= 0; i = i - 1) begin
//         result[i] = a[i] ^ b[i] ^ carry; // Sum bit
//         carry = (a[i] & b[i]) | (a[i] & carry) | (b[i] & carry); // Carry bit
//     end
// end

// endmodule

module matrix_multiplier #(parameter N = 3)(
);

reg [15:0] A[N-1:0][N-1:0]; // Input matrix A (NxN)
reg [15:0] B[N-1:0][N-1:0]; // Input matrix B (NxN)
reg [31:0] C[N-1:0][N-1:0]; // Output matrix C (NxN)
integer i, j,tmp,k;
real x;
reg [31:0] tmp_result; 

function automatic integer custom_adder;
    input [7:0] a;
    input [7:0] b;
    reg [7:0] result;
    reg [7:0] carry;
    integer i;
    begin
        result = 8'b0; // Initialize result to zero
        carry = 8'b0;  // Initialize carry to zero
        for (i = 0; i < 8; i = i + 1) begin
            result[i] = a[i] ^ b[i] ^ carry; // Calculate sum bit
            carry = (a[i] & b[i]) | (a[i] & carry) | (b[i] & carry); // Calculate carry bit
        end
        custom_adder = result; // Assign result to custom_adder
    end
endfunction

function automatic [31:0] custom_multiply;
    input [15:0] a; // 16-bit floating-point number a
    input [15:0] b; // 16-bit floating-point number b
    reg [15:0] a_frac;
    reg [15:0] b_frac;
    reg [31:0] result;
    integer i;
    begin
    // Perform multiplication by adding the product of each bit pair
    a_frac = a[11:0]; // Extract fractional part of a
    b_frac = b[11:0]; // Extract fractional part of b

    result = 32'b0; // Initialize result to zero
    for (i = 0; i < 12; i = i + 1) begin
        if (a_frac[i]) begin
            // Shift b_frac by i positions to the left
            // and add the result to the accumulator
            result = custom_adder(result, (b_frac << i));
        end
    end
    custom_multiply = result;
    end
endfunction

// Initialize input matrices A and B with random numbers
initial begin
    // Initialize matrices A and B with random numbers
    for (i = 0; i < N; i = i + 1) begin
        for (j = 0; j < N; j = j + 1) begin
            A[i][j] = $urandom_range(0, 10) * 1.0; // Assign random value to A[i][j]
            B[i][j] = $urandom_range( 10) * 1.0; // Assign random value to B[i][j]
            $display("A[%0d][%0d] = %f, B[%0d][%0d] = %f", i, j, A[i][j], i, j, B[i][j]);
        end
    end
end

// Matrix multiplication operation
always @* begin
    // Perform matrix multiplication
    for (i = 0; i < N; i = i + 1) begin
        for (j = 0; j < N; j = j + 1) begin
            C[i][j] = 0;
            for (k = 0; k < N; k = k + 1) begin
                tmp = custom_multiply(A[i][k], B[k][j]);
                $display("A[%0d][%0d] = %d,B[%0d][%0d] = %d, tmp = %d",i,k,A[i][j],k, j,B[k][j],tmp);
                //add_arrays(C[i][j], tmp, C[i][j);
                
                // custom_adder #(8) xyz (
                //     .a(a),
                //     .b(b),
                //     .result(result)
                // );

     C[i][j] = custom_adder(C[i][j], tmp); // Call the custom_adder function
     // $display("C[%0d][%0d] = %d,tmp = %d,result = %d",i, j,C[i][j],tmp,C[i][j]);
                //C[i][j] = C[i][j] + tmp;
               // $display("C[%0d][%0d] = %d,A[%0d][%0d] = %d,B[%0d][%0d] = %d, tmp = %d",i, j,C[i][j],i, j,A[i][j],k, j,B[k][j],tmp);
            end
        end
    end
end
always @* begin
    $display("Matrix A:");
    for (i = 0; i < N; i = i + 1) begin
        for (j = 0; j < N; j = j + 1) begin
            $write("%f ", A[i][j]);
        end
        $write("\n");
    end
end

always @* begin
    $display("Matrix B:");
    for (i = 0; i < N; i = i + 1) begin
        for (j = 0; j < N; j = j + 1) begin
            $write("%f ", B[i][j]);
        end
        $write("\n");
    end
end
// Display output matrix C
always @* begin
    $display("Matrix C:");
    for (i = 0; i < N; i = i + 1) begin
        for (j = 0; j < N; j = j + 1) begin
            $write("%f ", C[i][j]);
        end
        $write("\n");
    end
end
endmodule


    // reg [WIDTH-1:0] a = 8'b00000001; // Example value for input a
    // reg [WIDTH-1:0] b = 8'b00000010; // Example value for input b
//     reg [8-1:0] a;
//     reg [8-1:0] b;

//     // Output
//     wire [8-1:0] result;
// custom_adder #(8) xyz (
//                     .a(a),
//                     .b(b),
//                     .result(result)
//                 );

//     initial begin
//         // Test with various input values
//         // You can modify these values based on your testing requirements
//         a = 8'b00000001; // Example input a
//         b = 8'b00000010; // Example input b
//         #10; // Wait for some time
        
//         // Add more test cases here
        
//         // Terminate simulation
//         $finish;
//     end

//     // Monitor
//     always @* begin
//         $display("a = %b, b = %b, result = %b", a, b, result);
//     end





