#!/bin/bash

# === Settings ===
PARENT_PROCESS_NAME="somnia node"
TIMEOUT1=60
TIMEOUT2=120
THREAD_PREFIX="val_worker"
THREAD_COUNT="12"
CPU_START=3

THREADS=()
CPUS=()

for ((i=0; i<THREAD_COUNT; i++)); do
 THREADS+=("${THREAD_PREFIX}_${i}")
 CPUS+=($((CPU_START + i)))
done

while [ -z "$parent_pid" ]; do
 parent_pid=$(pgrep -f "${PARENT_PROCESS_NAME}")
 if [ -z "$parent_pid" ]; then
  echo "Parent process '${PARENT_PROCESS_NAME}' not found, retrying in 20s..."
  sleep 20
 fi
done

# Set affinity
for i in "${!THREADS[@]}"; do
 thread_name="${THREADS[$i]}"
 cpu="${CPUS[$i]}"
  while : ; do
   thread_pids=$(ps -T -p $parent_pid -o spid=,comm= | awk -v tname="$thread_name" '$NF==tname {print $1}')
   if [ -n "$thread_pids" ]; then
    break
   fi
   echo "Thread '$thread_name' not found, sleeping 60s and retrying..."
   sleep 60
  done

  for thread_pid in $thread_pids; do
   current_affinity=$(taskset -cp $thread_pid 2>&1 | awk '{print $NF}')
   if [ "$current_affinity" == "$cpu" ]; then
    echo "Affinity for thread '$thread_name' (TID $thread_pid) already set to CPU $cpu"
   else
    echo "Setting affinity for thread '$thread_name' (TID $thread_pid) to CPU $cpu"
    sudo taskset -cp $cpu $thread_pid
   fi
 done
done
