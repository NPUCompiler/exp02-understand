#include <math.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

void __attribute__((noinline)) f(int N, float * arr1, float * arr2, float * result)
{
    // 在开启自动向量化的基础上添加线程级并行导语
#pragma omp parallel for num_threads(4)
    for (int i = 0; i < N; i++) {
        result[i] = arr1[i] + arr2[i];
    }
}

int main()
{
    clock_t start, finish;
    int loop = 10000;
    int len = 1000000;
    float * a = (float *)malloc(sizeof(float) * len);
    float * b = (float *)malloc(sizeof(float) * len);
    float * d = (float *)malloc(sizeof(float) * len);
    for (int i = 0; i < len; i++) {
        //随机生成数组
        a[i] = rand() * 1.8570f - 2.0360f;
        b[i] = rand() * 8.7680f - 6.3840f;
    }

#ifdef _OPENMP
    start = omp_get_wtime(); // 多线程场景下不能使用clock()函数计算时间
#else
    start = clock();
#endif

    for (int i = 0; i < loop; i++) {
        f(len, a, b, d);
    }

#ifdef _OPENMP
    finish = omp_get_wtime();
#else
    finish = clock();
#endif

    double time = (double)(finish - start);
    printf("time: %f s\n", time);

    a[0] = d[0];//调用结果d防止编译器将计算过程优化掉
    free(a);
    free(b);
    free(d);
    return 0;
}
