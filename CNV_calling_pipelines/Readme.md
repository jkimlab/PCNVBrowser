# 1. CNV Calling Pipeline

This directory documents the CNV (Copy Number Variation) calling process using four tools:

- **[readDepth](https://github.com/chrisamiller/readDepth)** (v0.9.8.4)
- **[cn.MOPS](https://bioconductor.org/packages/cn.mops)** (v1.40.0)
- **[CNVkit](https://github.com/etal/cnvkit)** (v0.9.9)
- **[Control-FREEC](https://github.com/BoevaLab/FREEC)** (v11.6)

Each tool was used to identify CNVs at three resolutions: **5 kb**, **25 kb**, and **50 kb**.  
Note: For *readDepth*, the resolution is automatically selected by the tool.

---

## 1. readDepth

- **Version:** 0.9.8.4
- **Resolution:** Automatically determined by the tool
- **Parameters:** Default
(see: ./readDepth/params)

### **Dependencies**

- Python 3.6
- R 4.1.1

### **Command Example**

```bash
python readDepth/readDepth_run.py {input_directory} {annotations_directory} {entrypoint_file} {output_directory}
```

### **Input**

- .bed files (per chromosome)
- Reference files(see: ./cnv_calling/readDepth_input/annotations/):
    - `gcWinds/` and `mapability/`: provided by the readDepth package
    - `entrypoints`: tab-delimited chromosome metadata (name, length, ploidy)

### **Output**

- **`result.dat`**: Processed from `alts.dat`, this file is used for downstream CNV analysis.

---

## 2. cn.MOPS

- **Version:** 1.40.0
- **Resolutions:** 5k, 25k, and 50k
- **Parameters:**
    - `WL = 5000 / 25000 / 50000`
    - Others default

### **Dependencies**

- R 4.1.0

### **Command Example**

```r
Rscript cn.MOPS/cn.MOPS_execute.R {bamfile_path} {output_file} {sex} {WL} 
```

### **Input**

- Directory path containing `.bam`, `.bai` files
    
    All BAM files from the same population were placed in a single directory and processed together.
    

### **Output**

- Autosomes and sex chromosomes are processed separately using sex-specific priors and combined.
- `.CNVs`: Per-sample CNV call tables parsed by sample name, used for downstream analysis.

---

## 3. CNVkit

- **Version:** 0.9.9
- **Resolutions:** 5k, 25k, and 50k
- **Parameters:**
    - `-method wgs`
    - `-target-avg-size = 5000 / 25000 / 50000`
    - `f`: reference FASTA
    - `n`: normal-only mode
    - `y`: male sample
    - `p`: threads

### **Dependencies**

- Python 3.7

### **Command Example**

```bash
cnvkit.py batch --method wgs -y -p {threads} {bamfile_path} -f {readfile_path} -n --target-avg-size {i}
```

### **Input**

- `.bam`, `.bai` files
- Reference genome (FASTA)
(see: ./cnv_calling/**Homo_sapiens_assembly38.fasta**)

### **Output**

- `.cns` files: used for segmentation and downstream CNV analysis

---

## 4. Control-FREEC

- **Version:** 11.6
- **Resolutions:** 5k, 25k, and 50k
- **Parameters:**
    - `window = 5000 / 25000 / 50000`
    - Others default

### **Dependencies**

- Python 3.6

### **Command Example**

```bash
{freec_dir}/freec -conf {config_file}
```

### **Input**

- `.bam`, `.bai` files
- Reference files(see: cnv_calling/Homo_sapiens_assembly38.faSize and **perChrom**):
    - `Homo_sapiens_assembly38.faSize`
    - GC/mappability files in `perChrom/`
- Configuration file (auto-generated via Python script; see **example_config.txt**)

### **Output**

- `.CNVs` files: CNV calls used for downstream analysis


---

#### References

1. Miller, C. A., Hampton, O., Coarfa, C. & Milosavljevic, A. 「ReadDepth: a parallel R package for detecting copy number alterations from short sequencing reads」. 『PloS one』 6, e16327, doi:10.1371/journal.pone.0016327 2011.
2. Klambauer, G. et al. 「cn.MOPS: mixture of Poissons for discovering copy number variations in next-generation sequencing data with a low false discovery rate」. 『Nucleic acids research』 40, e69, doi:10.1093/nar/gks003 2012.
3. Talevich, E., Shain, A. H., Botton, T. & Bastian, B. C. 「CNVkit: Genome-Wide Copy Number Detection and Visualization from Targeted DNA Sequencing」. 『PLoS computational biology』 12, e1004873, doi:10.1371/journal.pcbi.1004873 2016.
4. Boeva, V. et al. 「Control-free calling of copy number alterations in deep-sequencing data using GC-content normalization」. 『Bioinformatics (Oxford, England)』 27, 268-269, doi:10.1093/bioinformatics/btq635 2011.

