# Define the directory parameter
set dir [lindex $argv 0]



echo "Hello"

echo "dir: $dir"

# Set the path to the vsim.wlf file in the specified directory
set wlf_file "$dir/vsim.wlf"


echo "wlf: $wlf_file"

# Open the vsim.wlf file
wlf load -view $wlf_file

# Start simulation
vsim -view $wlf_file

# Add signals to the waveform viewer for MyMips and HzdDetection components
add wave -position insertpoint /MyMips/*
add wave -position insertpoint /HzdDetection/*

# Zoom out to fit all waveforms in the viewer
view wave

# Start the simulation and show the waveforms
run -all

