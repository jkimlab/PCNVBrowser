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

#### **Dependencies**

- Python 3.6
- R 4.1.1

#### **Command Example**

```bash
python readDepth/readDepth_run.py {input_path} {annotations_path} {entrypoint_file} {output_path}

```

#### **Input**

- input_path: Directory containing BED files (per chromosome) for a single sample
- annotations_path: Directory containing params, gcWinds, and mapability files (provided by the readDepth tool)
- entrypoint_file: Tab-delimited file containing chromosome metadata — e.g., chromosome name, length, and ploidy
- output_path: Directory where result.dat will be saved

#### **Output**

- **`result.dat`**: Processed from `alts.dat`, this file is used for downstream CNV analysis.

---

## 2. cn.MOPS

- **Version:** 1.40.0
- **Resolutions:** 5k, 25k, and 50k


#### **Dependencies**

- R 4.1.0

#### **Command Example**

```r
Rscript cn.MOPS/cn.MOPS_execute.R {bamfile_path} {output_file} {sex} {WL} 
```

#### **Input**

- bamfile_path: Directory path containing `.BAM`, `.BAI` files (All BAM files from the same population were placed in a single directory and processed together.)
- output_file: Name of the output file
- sex: Sex information of input samples ("female" or "male")
- WL: Window length

#### **Output**

- Autosomes and sex chromosomes are processed separately using sex-specific priors and combined.
- `.CNVs`: Per-sample CNV call tables parsed by sample name, used for downstream analysis.

---

## 3. CNVkit

- **Version:** 0.9.9
- **Resolutions:** 5k, 25k, and 50k


#### **Dependencies**

- Python 3.7

#### **Command Example**

```bash
cnvkit.py batch --method wgs -y -p {threads} {bamfile_path} -f {ref_path} -n --target-avg-size {i}
```

#### **Input**

- threade: Number of threads
- bamfile_path: Directory path containing .BAM, .BAI files
- ref_path: Directory path containing reference genome (FASTA)

#### **Output**

- `.cns` files: used for segmentation and downstream CNV analysis

---

## 4. Control-FREEC

- **Version:** 11.6
- **Resolutions:** 5k, 25k, and 50k

#### **Dependencies**

- Python 3.6

#### **Command Example**

```bash
{freec_dir}/freec -conf {config_file}
```

### **Input**

- config_file
    ```text
        [general]
        chrLenFile = ./reference.faSize
        outputDir = ./output/
        ploidy = 2
        window = 50000
        maxThreads = 10
        sex = XX
        chrFiles = ./perChrom/
        
        [sample]
        mateFile = ./sample.bam
        inputFormat = BAM
        mateOrientation = 0
        
        [control]
        
        
        [target]
    ```

#### **Output**

- `.CNVs` files: CNV calls used for downstream analysis


---

#### References

1. Miller, C. A., Hampton, O., Coarfa, C. & Milosavljevic, A. 「ReadDepth: a parallel R package for detecting copy number alterations from short sequencing reads」. 『PloS one』 6, e16327, doi:10.1371/journal.pone.0016327 2011.
2. Klambauer, G. et al. 「cn.MOPS: mixture of Poissons for discovering copy number variations in next-generation sequencing data with a low false discovery rate」. 『Nucleic acids research』 40, e69, doi:10.1093/nar/gks003 2012.
3. Talevich, E., Shain, A. H., Botton, T. & Bastian, B. C. 「CNVkit: Genome-Wide Copy Number Detection and Visualization from Targeted DNA Sequencing」. 『PLoS computational biology』 12, e1004873, doi:10.1371/journal.pcbi.1004873 2016.
4. Boeva, V. et al. 「Control-free calling of copy number alterations in deep-sequencing data using GC-content normalization」. 『Bioinformatics (Oxford, England)』 27, 268-269, doi:10.1093/bioinformatics/btq635 2011.

