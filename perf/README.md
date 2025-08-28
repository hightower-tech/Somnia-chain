### ⚠️ WARNING! This method is still under heavy testing ⚠️

To improve performance, we isolated a dedicated CPU core and pinned the `execute_stage` process to it.
This reduced resource contention between system services and the critical workload.

We chose core 2 (hello Solana!) and then determined its sibling vCPU ID:
```
cat /sys/devices/system/cpu/cpu2/topology/thread_siblings_list
```
Next, add the isolation settings to `/etc/default/grub`:
```
GRUB_CMDLINE_LINUX_DEFAULT="nohz_full=2,18 isolcpus=2,18 irqaffinity=0-1,3-17,19-31"
```
Then applied the changes and rebooted:
```
update-grub
reboot
```
After the node is up, pin the `execute_stage` thread to core 2.
```
sudo taskset -cp 2 $execute_stage_pid
```
To simplify this, use the `pin-core.sh` script in the background.
After the node starts, run pin-core.sh — it will automatically find `execute_stage` thread and move it to the core defined inside the script.

## WARNING! THIS IS NOT GOOD TESTED YET !
A similar approach may also be beneficial for all validation processes `val_worker`.
**Note: This can significantly reduce performance on servers with a small number of cores.**

A script for pinning `val_worker` procceses to dedicated cores has already been prepared.

On modern multi-processor systems, additional performance gains may be achieved by disabling SMT (Hyper-Threading), as this reduces contention between sibling threads and improves performance predictability.
