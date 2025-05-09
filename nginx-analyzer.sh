#!/bin/bash

LOG_FILE=$1

# check errors in the input
if [ -z "$LOG_FILE" ]; then
  echo "Error: No log file specified."
  echo "Usage: $0 <nginx-access-log>"
  exit 1
fi

if [ ! -f "$LOG_FILE" ]; then
  echo "Error: '$LOG_FILE' is not a valid file."
  exit 1
fi

echo "Top 5 IP addresses with the most requests:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests"}'
echo ""

echo "Top 5 most requested paths:"
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests"}'
echo ""

echo "Top 5 response status codes:"
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests"}'
echo ""

echo "Top 5 user agents:"
awk -F\" '{print $6}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print substr($0, index($0,$2)) " - " $1 " requests"}'

# Extracts the IP (first column).
# Then sort | uniq -c | sort -nr | head -n 5:
# uniq -c: count occurrences
# sort -nr: sort descending
# head -n 5: top 5
# the -F\" is to change the separator to get the User-Agent
