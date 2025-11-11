#include <string>
#include <iostream>

// macro stringification needed
#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)

int main(int argc, const char * argv[]) {
#if defined(__CUDA_ARCH_LIST__)
    #pragma message("usable" STR((__CUDA_ARCH_LIST__)))
    std::string arch_list_str = STR((__CUDA_ARCH_LIST__));
    if (arch_list_str.length() >= 2 && arch_list_str.front() == '(' && arch_list_str.back() == ')') {
        arch_list_str = arch_list_str.substr(1, arch_list_str.length() - 2);
    }
    std::cout << arch_list_str << std::endl;
#else 
    #error "__CUDA_ARCH_LIST__ is not defined"
#endif 
}
