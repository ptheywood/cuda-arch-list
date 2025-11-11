# `CUDA_ARCH_LIST` testing

Repo for quick testing of `__CUDA_ARCH_LIST__`, added in CUDA 11.5 with diffiernet `CMAKE_CUDA_ARCHITECTURE` values

## Usage 

```bash
cmake -S . -B build-all-major -DCMAKE_CUDA_ARCHITECTURES=all-major
cmake --build build-all-major
./build-all-major/cuda_arch_list
```

## Values

For my 3060ti linux machine:

| CUDA   | CMAKE_CUDA_ARCHITECTURES | `__CUDA_ARCH_LIST__`                                                                                          |
| ------ | ------------------------ | ------------------------------------------------------------------------------------------------------------- |
| `13.0` | `all-major`              | `750,800,900,1000,1100,1200`                                                                                  |
| `13.0` | `all`                    | `750,800,860,870,880,890,900,1000,1030,1100,1200,1210`                                                        |
| `13.0` | `native`                 | `860`                                                                                                         |
| `13.0` | `80`                     | `800`                                                                                                         |
| `13.0` | `80-real`                | `800`                                                                                                         |
| `13.0` | `80-virtual`             | `800`                                                                                                         |
| `13.0` | `80;86`                  | `800,860`                                                                                                     |
| `13.0` | `100;80;86`              | `800,860,1000`                                                                                                |
| `13.0` | `90a`                    | `900`                                                                                                         |
| `13.0` | `90a;100`                | `900,1000`                                                                                                    |
| `13.0` | `103f`                   | `1030`                                                                                                        |
| `13.0` | `121a;121f`              | `121`                                                                                                         |



### Command used

```bash
cmake -S . -B build-all -DCMAKE_CUDA_ARCHITECTURES=all && cmake --build build-all && ./build-all/cuda_arch_list
cmake -S . -B build-native -DCMAKE_CUDA_ARCHITECTURES=native && cmake --build build-native && ./build-native/cuda_arch_list
cmake -S . -B build-80 -DCMAKE_CUDA_ARCHITECTURES=80 && cmake --build build-80 && ./build-80/cuda_arch_list
cmake -S . -B build-80-real -DCMAKE_CUDA_ARCHITECTURES=80-real && cmake --build build-80-real && ./build-80-real/cuda_arch_list
cmake -S . -B build-80-virtual -DCMAKE_CUDA_ARCHITECTURES=80-virtual && cmake --build build-80-virtual && ./build-80-virtual/cuda_arch_list
cmake -S . -B build-80-86 -DCMAKE_CUDA_ARCHITECTURES="80;86" && cmake --build build-80-86 && ./build-80-86/cuda_arch_list
cmake -S . -B build-100-80-86 -DCMAKE_CUDA_ARCHITECTURES="100;80;86" && cmake --build build-100-80-86 && ./build-100-80-86/cuda_arch_list
cmake -S . -B build-90a -DCMAKE_CUDA_ARCHITECTURES="90a" && cmake --build build-90a && ./build-90a/cuda_arch_list
cmake -S . -B build-90a-100 -DCMAKE_CUDA_ARCHITECTURES="90a;100" && cmake --build build-90a-100 && ./build-90a-100/cuda_arch_list
cmake -S . -B build-103f -DCMAKE_CUDA_ARCHITECTURES="103f" && cmake --build build-103f && ./build-103f/cuda_arch_list
cmake -S . -B build-121a-121f -DCMAKE_CUDA_ARCHITECTURES="121a;121f" && cmake --build build-121a-121f && ./build-121a-121f/cuda_arch_list
```

Some combinations with suffixed architectures are not allowed:

```console
$ cmake -S . -B build-121-121a-121f -DCMAKE_CUDA_ARCHITECTURES="121;121a;121f" && cmake --build build-121-121a-121f && ./build-121-121a-121f/cuda_arch_list
    ...
    nvcc fatal   : The same GPU code (`sm_121f`) generated for non family-specific and family-specific GPU arch
    ...
```
