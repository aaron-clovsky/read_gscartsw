#!/bin/bash
################################################################################
# Read current input of gscartsw via EXT header
#
# Copyright (c) 2025 Aaron Clovsky
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
################################################################################

########################################
# Configuration
########################################

# GPIO Chip is required by gpioget
GPIOCHIP="gpiochip0"

# GPIO Pins
# - These pins should be connected directly to the gscartsw EXT header
#   (EXT logic high is 3.3v on gscartsw v5.2, for safety test yours first)
# - Remember to connect gscartsw EXT Pin 1 (GND) to your board's GND
PIN3=21 # gscartsw EXT Pin 7
PIN2=20 # gscartsw EXT Pin 6
PIN1=12 # gscartsw EXT Pin 5

# This number is somewhat arbitrary, 12 works well in testing
sample_count=12

# All errors exit immediately
set -e

# Needed to avoid calling tr (for speed)
shopt -s extglob

########################################
# Check dependencies
########################################

# Check dependencies
if ! command -v gpioget 2>&1 >/dev/null; then
  >&2 echo "Error: Required command 'gpioget' is not installed"
  exit 1
fi

########################################
# Read the currently selected input
########################################
results=()

for ((i = 1 ; i < $sample_count ; i++ )); do
  results+=("$(gpioget --bias=pull-down $GPIOCHIP $PIN3 $PIN2 $PIN1)")
done

unique_results=$(printf '%s\n' "${results[@]}" | sort -u)

unique_results_count=$(echo "$unique_results" | wc -l)

if [ $unique_results_count -eq 1 ]; then
  input_binary="${unique_results//+([[:space:]])/}"
  input_number=$((2#$input_binary))

  if [ $input_number -ge 0 ] || [ $input_number -le 7 ]; then
    echo $(($input_number+1))
    exit 0
  fi
fi

echo 0
