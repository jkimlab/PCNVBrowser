## 1. CNV Calling Pipeline

This directory documents the CNV (Copy Number Variation) calling process using four tools:

- **[readDepth](https://github.com/chrisamiller/readDepth)** (v0.9.8.4)
- **[cn.MOPS](https://bioconductor.org/packages/cn.mops)** (v1.40.0)
- **[CNVkit](https://github.com/etal/cnvkit)** (v0.9.9)
- **[Control-FREEC](https://github.com/BoevaLab/FREEC)** (v11.6)

Each tool was used to identify CNVs at three resolutions: **5 kb**, **25 kb**, and **50 kb**.  
Note: For *readDepth*, the resolution is automatically selected by the tool.

---

# 1. readDepth

- **Version:** 0.9.8.4
- **Resolution:** Automatically determined by the tool
- **Parameters:** Default
(see: ./readDepth/readDepth_input/annotations/params)

### **Dependencies**

- Python 3.6
- R 4.1.1

### **Command Example**

```bash
python readDepth_run.py {input_directory} {annotations_directory} {entrypoint_file} {output_directory}
```

### **Input**

- .bed files (per chromosome)
- Reference files(see: ./cnv_calling/readDepth_input/annotations/):
    - `gcWinds/` and `mapability/`: provided by the readDepth package
    - `entrypoints`: tab-delimited chromosome metadata (name, length, ploidy)

### **Output**

- **`result.dat`**: Processed from `alts.dat`, this file is used for downstream CNV analysis.

---


