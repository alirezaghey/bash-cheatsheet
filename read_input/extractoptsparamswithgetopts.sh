#!/bin/bash
# Extract command-line options and parameters with getopts
#
echo
while getopts :ab:cd opt; do
	case "$opt" in
		a) echo "Found the -a options" ;;
		b) echo "Found the -b options with parameter value $OPTARG";;
		c) echo "Found teh -c options" ;;
		d) echo "Found the -d options" ;;
		*) echo "Unknown option: $opt" ;;
	esac
done
#
shift $(( $OPTIND - 1 ))
#
count=1
for param in "$@"; do
	echo "Parameter $count: $param"
	count=$(( $count + 1 ))
done
exit
