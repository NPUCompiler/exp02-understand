#include <iostream>

#include "test.cuh"

// 线程(Thread)：一般通过GPU的一个核进行处理;
// 线程块(Block)：由多个线程组成；各block是并行执行的，block间无法通信，也没有执行顺序。
// 线程格(Grid)：由多个线程块组成。
// 核函数(Kernel)：在GPU上执行的函数通常称为核函数;一般通过标识符__global__修饰，
// 调用通过<<<参数1,参数2>>>，用于说明内核函数中的线程数量，以及线程是如何组织的。
// gridDim：gridDim.x、gridDim.y、gridDim.z分别表示线程格各个维度的大小
// blockDim：blockDim.x、blockDim.y、blockDim.z分别表示线程块中各个维度的大小
// blockIdx：blockIdx.x、blockIdx.y、blockIdx.z分别表示当前线程块所处的线程格的坐标位置
// threadIdx：threadIdx.x、threadIdx.y、threadIdx.z分别表示当前线程所处的线程块的坐标位置
// 线程格里面总的线程个数N：N = gridDim.x * gridDim.y * gridDim.z * blockDim.x * blockDim.y * blockDim.z

//定义核函数 __global__为声明关键字
template<typename T>
__global__ void matAdd_cuda(T *a, T *b, T *sum)
{
    // blockIdx代表block的索引, blockDim代表block的大小，threadIdx代表thread线程的索引，
    // 因此对于一维的block和thread索引的计算方式如下
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    sum[i] = a[i] + b[i];
}

// 核函数用模板不会报错，模板名字是具有链接的，但它们不能具有C链接，因此不能用在供调用的函数上
void matAdd(float *a, float *b, float * sum, int length)
{
    cudaDeviceProp prop;

    int count;
    cudaGetDeviceCount( &count );
    for (int i = 0; i < count; i++) {

        cudaGetDeviceProperties(&prop, i);

        // multiProcessorCount: 设备上的流多处理器（SM）的数量
        // maxThreadsPerMultiProcessor: 每个流多处理器（SM）最大线程数量
        std::cout << prop.multiProcessorCount << " " << prop.maxThreadsPerMultiProcessor << std::endl;
        std::cout << prop.maxBlocksPerMultiProcessor << " " << prop.maxThreadsPerBlock << std::endl;
        std::cout << prop.maxThreadsDim[0] << " " << prop.maxThreadsDim[1] << " " << prop.maxThreadsDim[2] << std::endl;
    }

    // 设置使用第0块GPU进行运算，并且设置运算显卡
    int device = 0;
    cudaSetDevice(device);

    // 获取对应设备属性
    cudaDeviceProp devProp;
    cudaGetDeviceProperties(&devProp, device);

    // 每个线程块的最大线程数
    int threadMaxSize = devProp.maxThreadsPerBlock;

    // 计算Block大小,block一维度是最大的，一般不会溢出
    int blockSize = (length + threadMaxSize - 1) / threadMaxSize;

    // 设置thread
    dim3 thread(threadMaxSize);

    // 设置block
    dim3 block(blockSize);

    // 计算空间大小
    int size = length * sizeof(float);

    float *sumGPU = nullptr, *aGPU = nullptr, *bGPU = nullptr;

    // 开辟显存空间
    cudaMalloc((void **) &sumGPU, size);
    cudaMalloc((void **) &aGPU, size);
    cudaMalloc((void **) &bGPU, size);

    // 内存->显存
    cudaMemcpy((void *) aGPU, (void *) a, size, cudaMemcpyHostToDevice);
    cudaMemcpy((void *) bGPU, (void *) b, size, cudaMemcpyHostToDevice);

    // 运算
    matAdd_cuda<float><<<block, thread>>>(aGPU, bGPU, sumGPU);

    // cudaThreadSynchronize();

    // 显存->内存
    cudaMemcpy(sum, sumGPU, size, cudaMemcpyDeviceToHost);

    // 释放显存
    cudaFree(sumGPU);
    cudaFree(aGPU);
    cudaFree(bGPU);
}
