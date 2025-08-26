# CPU Benchmark for OpenWrt Devices
This script benchmarks CPU performance on OpenWrt devices using stress-ng.

It measures **Bogo Ops/s** for **int64** and **matrixprod** methods on both single-thread and multi-thread execution.

The results are printed as a Markdown-formatted table row, ready to be copied into the table below.  
Feel free to submit a pull request with benchmark results from your device.

## Run
> [!NOTE]
> Tested only OpenWrt

```
sh <(wget -O - https://raw.githubusercontent.com/itdoginfo/cpu-wrt-bench/refs/heads/main/cpu-wrt-bench.sh)
```

## Device Results
| Device                  | CPU             | OpenWrt Version |  CPU Threads | int64 (1 Thread) | matrixprod (1 Thread) | int64 (ALL Threads) | matrixprod (ALL Threads) |
|-------------------------|-----------------|-----------------|--------------|----------------|---------------------|-------------------|------------------------|
| Beeline SmartBox TURBO+ | MediaTek MT7621A | OpenWrt 24.10.1 | 4           | 35.77          | 7.88                | 92.83             | 17.94                  |
| Xiaomi Mi Router AX3000T | MediaTek MT7981BA  | OpenWrt 24.10.1 | 2        | 291.67         | 10.89               | 581.33            | 19.86                  |
| FriendlyElec NanoPi R2S | Rockchip RK3328 | OpenWrt 24.10.1 | 4            | 286.60         | 10.80               | 1144.74           | 35.30                  |
| Xiaomi Redmi Router AX6000 | MediaTek MT7986A | OpenWrt 24.10.1 | 4        | 451.73         | 18.78               | 1805.96           | 55.30                  |
| Radxa ROCK Pi 4B+        | Rockchip OP1 64-bit SoC | OpenWrt 24.10.2 | 6            | 512.30         | 21.98               | 2146.80           | 80.34                  |


> [!NOTE]
> n/s - CPU not supported int128 method.
