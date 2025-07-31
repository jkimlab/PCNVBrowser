## Usage
`./cal_freq.sh {input_directory} {ALL | DUP | DEL}`

- {input_directory}: Directory name containing the CNV BED files
- {ALL | DUP | DEL}: CNV type to process
    - ALL: Merge both duplication and deletion CNVs
    - DUP: Process duplication CNVs only
    - DEL: Process deletion CNVs only

---

## Workflow

1. Compute overlapping CNV regions across samples using `bedtools multiinter`.
2. Calculate frequency of each region** by dividing the number of overlapping samples by the total number of input samples.

The resulting frequency table is saved as `${POP}.freq.bed`.

---

### Input directory requirements
- Each input file must contain "sorted.bed" in its filename.
    - Example: `CN.MOPS.25000.HG01879.sorted.bed.DEL`
- All CNV BED files for a population should be placed inside a folder named after the population.
    - Example:
      ```text
        ASW/
        ├── sample1.sorted.bed.DEL
        └── sample2.sorted.bed.DEL
  
      ```
- File suffixes such as .DUP or .DEL are assumed but not enforced by the script.
    - If you run the script with TYPE=DUP, it does not automatically exclude .DEL files.
    - You are responsible for ensuring that only relevant files (matching the given TYPE) are present in the input folder.

---

### Dependencies  
- bash
- awk
- perl
- bedtools ≥ v2.29.2

