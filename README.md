# BI131-2L Week 3 Laboratory Activity: Chromosome-Level Variant Calling

## Dataset and compute route
- Dataset: BI131_chr21_dataset (course Google Drive), paired reads `data/chr21_R1_001.fastq.gz` and `data/chr21_R2_001.fastq.gz`.
- Reference: `reference/chr21.fa` (contig `chr21`, 46,709,983 bp; GRCh38-compatible length) with `.fai` and `.dict`.
- Checksums validated against `MANIFEST.sha256` (all OK); see `evidence/dataset-staging-log.txt`.
- Compute route: Docker image `bi131-week3` (see `Dockerfile`), 4 CPUs and 4.8 GiB RAM available to WSL, analysis run with 2 threads.

## FastQC observation
Both read files contain 1,245,599 reads of 150 bp (186.8 Mbp each, 40% GC). All modules passed except per-sequence GC content, which gave a WARN in both files; this is likely because the reads come from one chromosome and do not follow FastQC's whole-genome GC model. No adapter content was detected, so no trimming was done. Total sequence is about 373.6 Mbp over a 46.7 Mbp chromosome, roughly 8x average depth, so this reduced dataset is not representative of full 30x human WGS and low depth may limit variant sensitivity.
