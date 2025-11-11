# `CUDA_ARCH_LIST` testing

Repo for quick testing of `__CUDA_ARCH_LIST__`, added in CUDA 11.5 with diffiernet `CMAKE_CUDA_ARCHITECTURE` values

## Usage 

```bash
cmake -S . -B build-all-major -DCMAKE_CUDA_ARCHITECTURES=all-major
cmake --build build-all-major
./build-all-major/cuda_arch_list
```
