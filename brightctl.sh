#!/bin/sh

# Check if at least one argument is given
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 [(b)up|(b)down|get] [value(%)]"
    echo "e.g: ./brightctl up 5"
    echo "to increase brightness by 5%"
    exit 1
fi

# Function to get xgamma output
get_xgamma_output() {
    echo $(xgamma 2>&1)
}

# Function to parse RGB values from xgamma output
parse_rgb_values() {
    local xgamma_output=$1
    red=$(echo $xgamma_output | awk -F '[ ,]+' '{print $3}')
    green=$(echo $xgamma_output | awk -F '[ ,]+' '{print $5}')
    blue=$(echo $xgamma_output | awk -F '[ ,]+' '{print $7}')

    echo "$red $green $blue"
}

# Get xgamma output
xgamma_output=$(get_xgamma_output)

# Parse the RGB values
read current_red current_green current_blue <<< $(parse_rgb_values "$xgamma_output")

# Assign first argument to variable
command=$1

# Handle 'get' command
# (convert decimal to percentage)
if [ "$command" == "get" ]; then
    brightness_average=$(echo "($current_red+$current_blue+$current_green)/3" | bc -l)
    brightness_percentage=$(printf "%.0f" $(echo "$brightness_average * 100" | bc -l))
    blue_perc=$(printf "%.0f" $(echo "$current_blue * 100" | bc -l))
    
    echo $brightness_percentage:$blue_perc
    exit 0
fi

# Check if two arguments are given for 'up' or 'down' commands
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 [up|down|bup|bdown] [value(%)]"
    echo "e.g: ./brightctl up 5"
    echo "to increase brightness by 5%"
    echo "use bup and bdown to control blue levels"
    exit 1
fi

# Assign second argument to variable
# change value comes in as a percentage (%)
change_value=$2
# convert to decimal
change_value=$(echo "$change_value * 0.01" | bc -l)
change_value=$(printf '%.3f' $change_value)

# Calculate new brightness based on command
if [[ "$command" == "up" ]]; then
    new_red=$(echo "$current_red + $change_value" | bc)
    new_green=$(echo "$current_green + $change_value" | bc)
    new_blue=$(echo "$current_blue + $change_value" | bc)
elif [[ "$command" == "down" ]]; then
    new_red=$(echo "$current_red - $change_value" | bc)
    new_green=$(echo "$current_green - $change_value" | bc)
    new_blue=$(echo "$current_blue - $change_value" | bc)
elif [[ "$command" == "bup" ]]; then
    new_red=$current_red
    new_green=$current_green
    new_blue=$(echo "$current_blue + $change_value" | bc)
elif [[ "$command" == "bdown" ]]; then
    new_red=$current_red
    new_green=$current_green
    new_blue=$(echo "$current_blue - $change_value" | bc)
else
    echo "Invalid command. Use '(b)up', '(b)down', or 'get'."
    exit 1
fi

# do this better, this seems stupid
trim_brightness() {
    local value=$1
    if (( $(echo "$value < 0.1" | bc -l) )); then
        value=0.1
    elif (( $(echo "$value > 1.0" | bc -l) )); then
        value=1.0
    fi
    echo "$value"
}

new_red=$(trim_brightness $new_red)
new_green=$(trim_brightness $new_green)
new_blue=$(trim_brightness $new_blue)

# Apply the new brightness setting
xgamma -rgamma $new_red -ggamma $new_green -bgamma $new_blue
