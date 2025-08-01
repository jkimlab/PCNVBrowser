#!/bin/bash

# Help message
if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <rawfiles_path> <query_bedfile> <output_path> [--bin_size INT]"
	echo "  Example: $0 ./data/raw ./example.bed ./out --bin_size 50000"
    echo "  rawfiles_path  : Directory containing raw CNV BED files"
    echo "  query_bedfile  : BED file with CNV regions of interest"
    echo "  output_path    : Final output directory for continent-wise matrix"
    exit 1
fi


# Main pipeline script
rawfiles_path=$1
query_bedfile=$2
output_path=$3

# Optional arguments (e.g., --bin_size 50000)
shift 3
optional_args=("$@")

# Internal paths
filtered_dir="${rawfiles_path}/filtered"
multiinter_dir="${rawfiles_path}/multiinter"

# Step 1: Filter BED files with CNV freq ≥ 0.05
bash ./1_filter_bed.sh "$rawfiles_path" "$filtered_dir"

# Step 2: Run bedtools multiinter per continent
bash ./2_run_multiinter.sh "$filtered_dir" "$multiinter_dir"

# Step 3: Compare against custom CNV regions
python ./3_compare_with_query.py "$query_bedfile" "$multiinter_dir" "$output_path" "${optional_args[@]}"
