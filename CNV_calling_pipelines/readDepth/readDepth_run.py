#!/usr/bin/env python3
import os
import sys
import subprocess
import argparse


def set_result(output_dir):
    """Convert alts.dat to result.dat with variant types."""
    file_path = os.path.join(output_dir, 'alts.dat')
    thresholds_path = os.path.join(output_dir, 'thresholds.dat')
    result_path = os.path.join(output_dir, 'result.dat')

    with open(thresholds_path) as tf:
        gain = float(next(line.split()[1] for line in tf if 'gainThresh' in line))
        loss = float(next(line.split()[1] for line in tf if 'lossThresh' in line))

    with open(file_path) as f, open(result_path, 'w') as fw:
        fw.write("chr\tstart\tend\tvariantType\tCN\tp-value\n")
        for line in f:
            tmp = line.split()
            cn = float(tmp[4])
            cnv_type = 'DUP' if cn >= gain else 'DEL' if cn <= loss else '-'
            fw.write(f"{tmp[0]}\t{int(float(tmp[1]) - 1)}\t{int(float(tmp[2]))}\t{cnv_type}\t{tmp[4]}\t-\n")

    print(">> result.dat successfully written!")


def main():
    parser = argparse.ArgumentParser(description="Run CNV calling using readDepth")
    parser.add_argument("bed_dir", help="Directory containing BED files,converted from BAM")
    parser.add_argument("ref_dir", help="Directory containing params, gcWinds, mapability")
    parser.add_argument("entry_file", help="Path to entrypoint_female or entrypoint_male")
    parser.add_argument("output_dir", help="Directory to store final outputs")
    args = parser.parse_args()

    # Setup
    cur_dir = os.getcwd()
    work_dir = os.path.join(cur_dir, "tmp")
    anno_dir = os.path.join(work_dir, "annotations")
    output_dir = os.path.join(work_dir, "output")

    for d in [work_dir, anno_dir, output_dir]:
        if os.path.exists(d):
            subprocess.run(["rm", "-rf", d])
        os.makedirs(d)

    # Symlink required files
    os.symlink(args.entry_file, os.path.join(anno_dir, "entrypoints"))
    os.symlink(os.path.join(args.ref_dir, "gcWinds"), os.path.join(anno_dir, "gcWinds"))
    os.symlink(os.path.join(args.ref_dir, "mapability"), os.path.join(anno_dir, "mapability"))
    os.symlink(os.path.join(args.ref_dir, "params"), os.path.join(work_dir, "params"))
    os.symlink(args.bed_dir, os.path.join(work_dir, "reads"))

    # Run R script
    print(">> Running R script")
    subprocess.run(["R", "--slave", "-f", "readDepth_execute.R"], cwd=work_dir, check=True)

    # Process result
    set_result(output_dir)

    # Move output
    subprocess.run(f"mv {output_dir}/* {args.output_dir}", shell=True, cwd=work_dir)
    subprocess.run(["rm", "-rf", work_dir])
    print(">> Done!")


if __name__ == "__main__":
    main()
