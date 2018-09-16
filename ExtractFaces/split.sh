#!/bin/sh
echo "Starting script..."
outputFolder=$1
shift;
files=( "$@" )
# remove existing directory
rm -rf "${outputFolder}"
# make the output directory first
mkdir "${outputFolder}"

ffmpegCommand=""
for file in "${files[@]}"; do
 name=("${file##*/}")
 folder=("${name%.*}")
 echo $folder
 mkdir "${outputFolder}/${folder}"

# Command for run bash program in background
 if [ ! -z "$ffmpegCommand" ]
 then
 ffmpegCommand="$ffmpegCommand & "
 fi
 ffmpegCommand="$ffmpegCommand ffmpeg -i $file \"${outputFolder}/${folder}/%04d.png\""
done

eval $ffmpegCommand
