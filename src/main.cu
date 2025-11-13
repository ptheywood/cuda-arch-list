#include <string>
#include <iostream>
#include <algorithm>
#include <limits>
#include <array>

/**
 * Get the __CUDA_ARCH_LIST__ in a std::string.
 * 
 * It is a list of integers in a macro (not a string) so macro faff is required.
 */
constexpr std::string_view string_cuda_arch_list() {
#if defined(__CUDA_ARCH_LIST__)
    // macro stringification needed
    #define STR_HELPER(x) #x
    #define STR(x) STR_HELPER(x)
    // #pragma message("usable" STR((__CUDA_ARCH_LIST__)))
    std::string_view arch_list_str = STR((__CUDA_ARCH_LIST__));
    #undef STR_HELPER
    #undef STR
    if (arch_list_str.length() >= 2 && arch_list_str.front() == '(' && arch_list_str.back() == ')') {
        arch_list_str = arch_list_str.substr(1, arch_list_str.length() - 2);
    }
    return arch_list_str;
#else
    #error "__CUDA_ARCH_LIST__ is not defined"
#endif
}

/**
 * Templated variadic template constexpr method which returns a std::array from a number of arguments
 */
template <typename... Args>
constexpr auto macro_to_array(Args... values) {
    constexpr std::size_t N = sizeof...(Args);
    return std::array<int, N>{ (static_cast<int>(values))... };
}

/**
 * Get __CUDA_ARCH_LIST__ as a constexpr std::array<int, _>
 */
constexpr auto array_cuda_arch_list() {
#if defined(__CUDA_ARCH_LIST__)
    // Macro wrapper for getting the __CUDA_ARCH_LIST__ as a std::array of int
    #define ARRAY_HELPER() macro_to_array<int>(__CUDA_ARCH_LIST__)
    return ARRAY_HELPER();
    #undef ARRAY_HELPER
#else
    return std::array<int, 1>{0};
#endif
}

/**
 * Base case for getting the minium value integer value from a macro-defined list of integers using recursion.
 */
constexpr int recursive_min_int(int a) {
    return a;
}
/**
 * Recursive method to get the the minium value integer value from a macro-defined list of integers provided as independent arguments
 */
template <typename... Args>
constexpr int recursive_min_int(int a, Args... tail) {
    return std::min(a, recursive_min_int(tail...));
}
/**
 * Get thge minimum cuda arch using recursion, or 0 if required macro is missing.
 */
constexpr int recursive_min_cuda_arch() {
    #if defined(__CUDA_ARCH_LIST__)
        // macro nonsense to pass the comma separated macro as function arguments to the variadic template function
        #define MIN_INT_FROM_MACROLIST(...) recursive_min_int(__VA_ARGS__)
        return MIN_INT_FROM_MACROLIST(__CUDA_ARCH_LIST__);
        #undef MIN_INT_FROM_MACROLIST
    #else
        // return a defualt value, 0 or intmax would make sense depending on usage.
        return 0;
    #endif
}

/**
 * Get the minimum cuda arch trusting that the __CUDA_ARCH_LIST__ is sorted as documented, by just getting the first macro function argument.
 *
 * @note MSVC is unhappy with this version.
 *
 */
constexpr int macro_min_cuda_arch(){
#if ! defined(_MSC_VER)
    #if defined(__CUDA_ARCH_LIST__)
        #define GET_FIRST_ARG(A, ...) A
        #define GET_FIRST_ARG_WRAPPER(LIST) GET_FIRST_ARG(LIST)
        #define MIN_ARCH GET_FIRST_ARG_WRAPPER(__CUDA_ARCH_LIST__)
        // The result is a compile-time constant integer:
        return MIN_ARCH;
        #undef MIN_ARCH
        #undef GET_FIRST_ARG_WRAPPER
        #undef GET_FIRST_ARG
    #endif
#endif
    // fallback to 0.
    return 0;
}

/**
 * Get the minimum cuda arch trusting that the __CUDA_ARCH_LIST__ is sorted as documented, via a std::array to avoid macro issues on msvc
 *
 */
constexpr int array_min_cuda_arch(){
#if defined(__CUDA_ARCH_LIST__)
    // Macro wrapper for getting the __CUDA_ARCH_LIST__ as a std::array of int
    #define ARRAY_HELPER() macro_to_array<int>(__CUDA_ARCH_LIST__)
    auto archs = ARRAY_HELPER();
    #undef ARRAY_HELPER
    if (archs.size() > 0) {
        return archs[0] / 10;
    }
#endif
    // fallback to 0.
    return 0;
}


/**
 * Print the value of __CUDA_ARCH_LIST__ to stdout, and then the minimum value from that list on separate lines.
 *
 */
int main(int argc, const char * argv[]) {
    std::cout << string_cuda_arch_list() << std::endl;
    std::cout << "recursive min: " << recursive_min_cuda_arch() << std::endl;
    std::cout << "macro min: " << macro_min_cuda_arch() << std::endl;
    std::cout << "array min: " << array_min_cuda_arch() << std::endl;
    constexpr auto archs = array_cuda_arch_list();
    for (std::size_t idx = 0; idx < archs.size(); idx++) {
        if (idx != 0) std::cout << ",";
        std::cout << archs[idx] / 10;
    }
    std::cout << std::endl;
}
