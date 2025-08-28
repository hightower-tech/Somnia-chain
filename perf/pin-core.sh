#!/bin/bash

PARENT_PROCESS_NAME="somnia node"
THREAD_NAME="execute_stage"
CPU_N=2
TIMEOUT1=60
TIMEOUT2=120

# Get main pid
while [ -z "$parent_pid" ]; do
 parent_pid=$(pgrep -f "${PARENT_PROCESS_NAME}")
 if [ -z "$parent_pid" ]; then
  echo "Parent process >> "${PARENT_PROCESS_NAME}" << not found. Sleeping for ${TIMEOUT1} seconds before retrying..."
  sleep $TIMEOUT1
 fi
done

# Get thread pid
while [ -z "$thread_pid" ]; do
 thread_pid=$(ps -T -p $parent_pid -o spid,comm | grep "${THREAD_NAME}" | awk '{print $1}')
 if [ -z "$thread_pid" ]; then
  echo "Thread process >> "${THREAD_NAME}" << not found. Sleeping for ${TIMEOUT2} seconds before retrying..."
  sleep $TIMEOUT2
 fi
done

# Get current affinity
current_affinity=$(taskset -cp $thread_pid 2>&1 | awk '{print $NF}')
if [ "$current_affinity" == "${CPU_N}" ]; then
 echo "Affinity already set: ${THREAD_NAME} - cpu:${CPU_N}"
 exit 0
else
 # Set affinity
 echo "Setting affinity of $thread_pid to CPU ${CPU_N}"
 sudo taskset -cp $CPU_N $thread_pid
fi
