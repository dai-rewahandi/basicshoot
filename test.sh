#!/bin/bash

# Simulated long-running function
my_function() {
  sleep 5  # simulate a task taking 5 seconds
}

# Spinner function
spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'

  echo -n "Running task... "
  while ps -p $pid &>/dev/null; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf " ✅ Done!\n"
}

# Run the function in the background
my_function &

# Get its PID and start the spinner
spinner $!
