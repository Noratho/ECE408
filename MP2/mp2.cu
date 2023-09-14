

// Compute C = A * B TODO
__global__ void matrixMultiply(float *A, float *B, float *C, int numARows,
                               int numAColumns, int numBRows,
                               int numBColumns, int numCRows,
                               int numCColumns)
{
    //@@ Insert code to implement matrix multiplication here
}
#define BLOCK_WIDTH 256
int main(int argc, char **argv)
{
    float *hostA; // The A matrix
    float *hostB; // The B matrix
    float *hostC; // The output C matrix
    float *deviceA;
    float *deviceB;
    float *deviceC;
    int numARows;    // number of rows in the matrix A
    int numAColumns; // number of columns in the matrix A
    int numBRows;    // number of rows in the matrix B
    int numBColumns; // number of columns in the matrix B
    int numCRows;    // number of rows in the matrix C (you have to set this)
    int numCColumns; // number of columns in the matrix C (you have to set
                     // this)

    // TODO replace with custom data loading to hostA and hostB
    //@@ Set numCRows and numCColumns DONE
    numCRows = numARows;
    numCColumns = numBColumns;
    //@@ Allocate the hostC matrix DONE
    hostc = malloc(numARows * numBColumns * sizeof(float));

    //@@ Allocate GPU memory here DONE
    cudaMalloc((void **)&deviceA, numARows * numAColumns * sizeof(float));
    cudaMalloc((void **)&deviceB, numBRows * numBColumns * sizeof(float));
    cudaMalloc((void **)&deviceC, numCRows * numCColumns * sizeof(float));

    //@@ Copy memory to the GPU here DONE
    cudaMemcpy(deviceA, hostA, numARows * numAColumns * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(deviceB, hostB, numBRows * numBColumns * sizeof(float), cudaMemcpyHostToDevice);

    //@@ Initialize the grid and block dimensions here DONE
    dim3 DimGrid(ceil(numCColumns / BLOCK_WIDTH), ceil(numCRows / BLOCK_WIDTH), 1);
    dim3 DimBlock(BLOCK_WIDTH, BLOCK_WIDTH, 1);

    //@@ Launch the GPU Kernel here DONE
    matrixMultiply<<<DimGrid, DimBlock>>>(deviceA, deviceB, deviceC,
                                          numARows, numAColumns,
                                          numBRows, numBColumns,
                                          numCRows, numCColumns);

    cudaDeviceSynchronize();

    //@@ Copy the GPU memory back to the CPU here DONE
    cudaMemcpy(hostC, deviceC, numCRows * numCColumns * sizeof(float), cudaMemcpyDeviceToHost);

    //@@ Free the GPU memory here DONE
    cudaFree(deviceA);
    cudaFree(deviceB);
    cudaFree(deviceC);

    wbSolution(args, hostC, numCRows, numCColumns);

    free(hostA);
    free(hostB);
    free(hostC);

    return 0;
}
