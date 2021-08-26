#!/bin/bash
#Testing signal trapping
#
trap "echo ' Sorry! I have trapped Ctrl-C'" SIGINT
#
count=1
while (( $count <= 5 )); do
	echo "Loop #$count"
	sleep 1
	count=$(( $count + 1 ))
done
#
echo "This is the end of test script."
exit
