#!/bin/bash
# Usage: bash 1_filter_bed.sh ./data/raw ./data/filtered

input_dir=$1
output_dir=$2
mkdir -p "$output_dir"

for file in "$input_dir"/*.bed; do
  prefix=$(basename "$file" | cut -d'.' -f1)
  awk '$5 >= 0.05' "$file" > "$output_dir/${prefix}.all_0.05.bed"
done

