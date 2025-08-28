To improve performance, we isolated a dedicated CPU core and pinned the ```execute_stage``` process to it.
This reduced resource contention between system services and the critical workload.

We are currently monitoring the results. 

A similar approach may also be beneficial for all validation processes ```val_worker``` — a script for pinning them to dedicated cores has already been prepared.

On multi-processor systems, additional performance gains may be achieved by disabling SMT (Hyper-Threading), as it reduces contention between sibling threads and improves performance predictability.
