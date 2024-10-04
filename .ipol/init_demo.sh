#!/bin/sh
set -e

zoom="$1"
scale_check=$2
gaussian_strategy=$3
gradient_strategy=$4

measure=$5 # (0.Harris, 1.Shi-Tomasi, 2.Szeliski)

sigma_derivation=$6
sigma_integration=$7

k_harris=$8
threshold_harris=$9
threshold_tomasi=${10}
threshold_harmonic=${11}

corners_strategy=${12} # (0.All corners; 1.Sort all corners; 2.N corners; 3.Distributed N corners)
output_corners=${13}
number_corners=${14}

subpixel_precision=${15}

if [ $measure -eq 0 ];then
	threshold=$threshold_harris
else
	if [ $measure -eq 1 ];then
		threshold=$threshold_tomasi
	else
		threshold=$threshold_harmonic	
	fi
fi

if [ "$zoom" != "100" ];then
	convert input_0.png -resize "$zoom""%" input_0.png
fi


params="input_0.png -o selected_points.png -f harris_corners.txt -z $scale_check -s $gaussian_strategy -g $gradient_strategy -m $measure -k $k_harris"
params="$params -d $sigma_derivation -i $sigma_integration -t $threshold -q $corners_strategy -c $output_corners -n $number_corners "
params="$params -p $subpixel_precision -v "
harris_corner_detector $params 

