#include <iostream>

#include "test.cuh"

int main()
{
    //创建数组
    const int length = 10000;

    float * a = new float[length];
    float * b = new float[length];
    float * c = new float[length];

    for (int i = 0; i < length; i++) {
        a[i] = 1.5;
        b[i] = 2;
    }

    // 矩阵加法运算
    matAdd(a, b, c, length);

    // 输出查看是否完成计算
    bool ok = true;
    for (int i = 0; i < length; i++) {
        if (c[i] != (a[i] + b[i])) {
            ok = false;
            break;
        }
    }

    if (ok) {
        std::cout << "OK!" << std::endl;
    } else {
        std::cout << "NG!" << std::endl;
    }

    delete [] a;
    delete [] b;
    delete [] c;

    return 0;
}
