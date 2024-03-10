module arb_inv #(parameter X = 2) ();

reg signed [15:0] A[X-1:0][X-1:0]; // Input matrix A (NxN)
reg signed [63:0] B[X-1:0][X-1:0];
reg success;
reg signed [31:0] pivot;
real result_scaled,factor;
// Declare local variables
reg signed [31:0] augmented[X-1:0][2*X-1:0]; // Augmented matrix (A|I)
integer i, j, k,max_row;
//real o ;
initial begin
    // Initialize matrices A with arbitrary random values
    for (i = 0; i < X; i = i + 1) begin
        for (j = 0; j < X; j = j + 1) begin
            A[i][j] = $urandom_range(0, 10) * 1.00; // Random values between -10 and 10
         //   o = 1.00/2.00;
        
            $display("A[%0d][%0d] = %d", i, j, A[i][j]);
        end
       //             $display("%d/%d = %f", 1, 2,o);
    end


    // Initialize the augmented matrix with A and the identity matrix
    for (i = 0; i < X; i = i + 1) begin
        for (j = 0; j < X*2; j = j + 1) begin
            if (j < X)
                augmented[i][j] = A[i][j];
            else if (j == X + i)
                augmented[i][j] = 1'b1 * 1.00; // Identity matrix I
            else
                augmented[i][j] = 1'b0 * 1.00;
            
         //   $display("augmented[%0d][%0d] = %d", i, j, augmented[i][j]);
        end
    end
end
function integer my_abs;
    input integer x;
    begin
        if (x < 0)
            my_abs = -x;
        else
            my_abs = x;
    end
endfunction

initial begin
    // Print the initial augmented matrix
    $display("Initial augmented matrix:");
    for (i = 0; i < X; i = i + 1) begin
        for (j = 0; j < X*2; j = j + 1) begin
            $write("%f ", augmented[i][j]);
        end
        $write("\n");
    end

    // Gaussian elimination with partial pivoting
    for (i = 0; i < X; i = i + 1) begin
        // Find the row with the largest absolute value in the current column
        max_row = i;
        for ( k = i + 1; k < X; k = k + 1) begin
            if (my_abs(augmented[k][i]) > my_abs(augmented[max_row][i])) begin
                max_row = k;
            end
        end

        // Swap the current row with the row containing the maximum element
        if (max_row != i) begin
            for ( j = i; j < 2*X; j = j + 1) begin
                {augmented[i][j], augmented[max_row][j]} = {augmented[max_row][j], augmented[i][j]};
            end
        end

        pivot = augmented[i][i] * 1.0;
       // $display("pivot: %d", pivot);
        if (pivot == 0) begin
            // Handle singular matrix
            success = 1'b0;
            $display("Matrix is singular, inversion not possible.");
            $finish; // Terminate simulation
        end

        // Scale the pivot row
for (j = 0; j < 2*X; j = j + 1) begin
   // $write("\npivot: %d, %d", pivot,augmented[i][j]);
    result_scaled = ((augmented[i][j] * 1.0)/ pivot) * 1.0;
   //   $write("result = %f", result_scaled);
    augmented[i][j] = result_scaled; // Convert to signed and perform division
  //  $write("\naugmented= %d", augmented[i][j]);
end


        // Eliminate elements below the pivot
        for (integer k = 0; k < X; k = k + 1) begin
            if (k != i) begin
                factor = augmented[k][i] * 1.0;
                for (j = 0; j < 2*X; j = j + 1) begin 
                    augmented[k][j] = augmented[k][j] * 1.00;
                    augmented[i][j] = augmented[i][j]* 1.0;
                    augmented[k][j] = augmented[k][j] - factor * augmented[i][j];
                end
            end
        end
    end

// Extract inverted matrix B
for (i = 0; i < X; i = i + 1) begin
    for (j = 0; j < X; j = j + 1) begin
        B[i][j] = augmented[i][X + j] * 1.0; // Extract values after pivot columns
    end
end


    // Print the augmented matrix after Gaussian elimination
    $display("\nAugmented matrix after Gaussian elimination:");
    for (i = 0; i < X; i = i + 1) begin
        for (j = 0; j < X*2; j = j + 1) begin
            $write("%f ", augmented[i][j]);
        end
        $write("\n");
    end

        success = 1'b1; // Matrix inversion successful
end



always @(success) begin
    if (success)
        $display("\nMatrix inversion successful:");
    else
        $display("\nMatrix is singular, inversion not possible.");

    // Display inverted matrix B
    $display("\nInverted matrix B:");
    for (integer i = 0; i < X; i = i + 1) begin
        for (integer j = 0; j < X; j = j + 1) begin
            $write("%f ", B[i][j]);
        end
        $write("\n");
    end
end

endmodule
