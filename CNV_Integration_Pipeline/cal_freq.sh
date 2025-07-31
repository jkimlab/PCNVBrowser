#!/bin/bash

# 1) set parameters
POP=$1 # ASW, CDX, ...
TYPE=$2 # ALL, DUP, DEL

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <population> <ALL|DUP|DEL>"
    exit 1
fi

if [[ ! "$TYPE" =~ ^(ALL|DUP|DEL)$ ]]; then
    echo "Error: TYPE must be one of ALL, DUP, or DEL"
    exit 1
fi

# 2) bedtools multiinter로
pattern="${POP}/*.sorted.bed.*"
echo ">> Processing $POP, TYPE=$TYPE"
outfile="./${POP}.freq.bed"

file_list=( $pattern )

valid_files=( $(printf "%s\n" "${file_list[@]}" | sort) )
if [[ ${#valid_files[@]} -eq 0 ]]; then
    echo "No BED files found for: $pattern"
    exit 1
fi

sample_count=${#valid_files[@]}
echo "  Generated: $outfile  (file count: $sample_count)"
tmp="${POP}.tmp"
echo > "$tmp"
if [[ "$TYPE" == "ALL" ]];then
	bedtools multiinter -i "${valid_files[@]}" > "$tmp"
	perl all_generator.pl "$tmp" > $outfile
else
	bedtools multiinter -i "${valid_files[@]}" > "$tmp"
	cut -f1-4 "$tmp" \
	| awk -v OFS='\t' -v all="$sample_count" -v type="$TYPE" '
	{
		freq = sprintf("%.5f", ($4 / all));  # $4 = "이 구간에 겹치는 파일 수"
		print $1, $2, $3, type, freq;
	}
	' > "$outfile"
fi


rm -rf "$tmp"
echo "Done."
