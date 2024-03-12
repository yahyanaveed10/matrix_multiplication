module DotProductN #(parameter NUM_VECTORS = 3,
parameter VECTOR_LENGTH = 4
);
reg signed [7:0] a [NUM_VECTORS][VECTOR_LENGTH]; // Input array of vectors a (8-bit signed elements)
reg signed [7:0] b [NUM_VECTORS][VECTOR_LENGTH]; // Input array of vectors b (8-bit signed elements)
reg signed [15:0] dot_product [NUM_VECTORS]; // Output array of dot products (16-bit signed)
reg signed [15:0] temp_product;
integer i, j;


initial begin
    // Assign values to input vectors
    // (You can modify this part to initialize vectors with your desired values)
    for (integer i = 0; i < NUM_VECTORS; i = i + 1) begin
        for (integer j = 0; j < VECTOR_LENGTH; j = j + 1) begin
            a[i][j] = $urandom_range(-10, 10) * 1.0; // Random values between -10 and 10
            b[i][j] = $urandom_range(-10, 10) * 1.0; // Random values between -10 and 10
        end
    end

    // Print input vectors
    $display("Input vectors:");
    for (integer i = 0; i < NUM_VECTORS; i = i + 1) begin
        $write("a[%0d]: ", i);
        for (integer j = 0; j < VECTOR_LENGTH; j = j + 1) begin
            $write("%d ", a[i][j]);
        end
        $write("\n");

        $write("b[%0d]: ", i);
        for (integer j = 0; j < VECTOR_LENGTH; j = j + 1) begin
            $write("%d ", b[i][j]);
        end
        $write("\n");
    end
end

always @* begin
    for (j = 0; j < NUM_VECTORS; j = j + 1) begin // Use NUM_VECTORS as the loop limit
        dot_product[j] = 0;
        temp_product = 0;
        for (i = 0; i < VECTOR_LENGTH; i = i + 1) begin // Use VECTOR_LENGTH as the loop limit
            temp_product = a[j][i] * b[j][i]; // Access elements with both indices
            dot_product[j] = dot_product[j] + temp_product;
        end
    end
end


initial begin
    // Wait for some time to let the dot product calculation complete
    #10;

    // Print dot products
    $display("\nDot products:");
    for (integer i = 0; i < NUM_VECTORS; i = i + 1) begin
        $display("dot_product[%0d] = %d", i, dot_product[i]);
    end
end

endmodule

// module TestDotProductN;

// // Define parameters
// parameter NUM_VECTORS = 3;
// parameter VECTOR_LENGTH = 4;

// // Declare arrays for input vectors
// reg signed [7:0] a[NUM_VECTORS][VECTOR_LENGTH];
// reg signed [7:0] b[NUM_VECTORS][VECTOR_LENGTH];

// // Declare array for output dot products
// reg signed [15:0] dot_product[NUM_VECTORS];

// // Instantiate DotProductN module
// DotProductN #(
//     .NUM_VECTORS(NUM_VECTORS),
//     .VECTOR_LENGTH(VECTOR_LENGTH)
// ) dot_product_inst (
//     .a(a),
//     .b(b),
//     .dot_product(dot_product)
// );

// // Initial block to assign values to input vectors
// initial begin
//     // Assign values to input vectors
//     // (You can modify this part to initialize vectors with your desired values)
//     for (integer i = 0; i < NUM_VECTORS; i = i + 1) begin
//         for (integer j = 0; j < VECTOR_LENGTH; j = j + 1) begin
//             a[i][j] = $urandom_range(-10, 10); // Random values between -10 and 10
//             b[i][j] = $urandom_range(-10, 10); // Random values between -10 and 10
//         end
//     end

//     // Print input vectors
//     $display("Input vectors:");
//     for (integer i = 0; i < NUM_VECTORS; i = i + 1) begin
//         $write("a[%0d]: ", i);
//         for (integer j = 0; j < VECTOR_LENGTH; j = j + 1) begin
//             $write("%d ", a[i][j]);
//         end
//         $write("\n");

//         $write("b[%0d]: ", i);
//         for (integer j = 0; j < VECTOR_LENGTH; j = j + 1) begin
//             $write("%d ", b[i][j]);
//         end
//         $write("\n");
//     end
// end

// // Display dot products
// initial begin
//     // Wait for some time to let the dot product calculation complete
//     #10;

//     // Print dot products
//     $display("\nDot products:");
//     for (integer i = 0; i < NUM_VECTORS; i = i + 1) begin
//         $display("dot_product[%0d] = %d", i, dot_product[i]);
//     end
// end

// endmodule
