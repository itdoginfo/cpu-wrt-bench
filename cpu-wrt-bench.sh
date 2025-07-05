#!/bin/ash

methods="int64 matrixprod"
timeout=30
threads=$(grep -c ^processor /proc/cpuinfo)

device=$(cat /tmp/sysinfo/model)
version=$(grep OPENWRT_RELEASE /etc/os-release | cut -d'"' -f2 | cut -d' ' -f1,2)

if ! command -v stress-ng >/dev/null 2>&1; then
    echo "The package 'stress-ng' is not installed. It is required to run the benchmark tests."
    echo -n "Do you want to install stress-ng now? [y/N]:"
    read answer
    case "$answer" in
        [yY][eE][sS]|[yY])
            if command -v opkg >/dev/null 2>&1; then
                (opkg update && opkg install stress-ng) || {
                    echo "Failed to install stress-ng via opkg"
                    exit 1
                }
            elif command -v apk >/dev/null 2>&1; then
                (apk update && apk add stress-ng) || {
                    echo "Failed to install stress-ng via apk"
                    exit 1
                }
            else
                echo "Neither opkg nor apk package manager found. Cannot install stress-ng."
                exit 1
            fi
            ;;
        *)
            echo "Exit"
            exit 1
            ;;
    esac
fi

echo "== CPU Openwrt Benchmark =="
echo "https://github.com/itdoginfo/cpu-wrt-bench"
echo
echo "Device:        $device"
echo "Version:       $version"
echo "CPU Threads:   $threads"
echo
echo "Please wait 2 minutes..."
echo

echo "[1 thread]"
echo "Method       Bogo Ops/s (real time)"
for method in $methods; do
    output=$(stress-ng --cpu 1 --cpu-method "$method" --metrics-brief --timeout ${timeout}s 2>/dev/null)
    bogo=$(echo "$output" | grep -E "^\s*stress-ng: metrc:" | grep "cpu" | awk '{print $(NF-1)}')
    printf "%-12s %s\n" "$method" "${bogo:-n/s}"
    eval "${method}_1thread=${bogo:-n/s}"
done

echo

echo "[${threads} threads]"
echo "Method       Bogo Ops/s (real time)"
for method in $methods; do
    output=$(stress-ng --cpu "$threads" --cpu-method "$method" --metrics-brief --timeout ${timeout}s 2>/dev/null)
    bogo=$(echo "$output" | grep -E "^\s*stress-ng: metrc:" | grep "cpu" | awk '{print $(NF-1)}')
    printf "%-12s %s\n" "$method" "${bogo:-n/s}"
    eval "${method}_allthreads=${bogo:-n/s}"
done

echo
echo "Markdown Table Row:"
printf "| %-23s | %-15s | %-15s | %-12s | %-14s | %-19s | %-17s | %-22s |\n" \
  "$device" "ENTER CPU MODEL" "$version" "$threads" \
  "$int64_1thread" "$matrixprod_1thread" \
  "$int64_allthreads" "$matrixprod_allthreads"
