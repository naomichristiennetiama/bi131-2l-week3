# BI131-2L Week 3 Laboratory Activity: Chromosome-Level Variant Calling

## Dataset and compute route
- Dataset: BI131_chr21_dataset (course Google Drive), paired reads `data/chr21_R1_001.fastq.gz` and `data/chr21_R2_001.fastq.gz`.
- Reference: `reference/chr21.fa` (contig `chr21`, 46,709,983 bp; GRCh38-compatible length) with `.fai` and `.dict`.
- Checksums validated against `MANIFEST.sha256` (all OK); see `evidence/dataset-staging-log.txt`.
- Compute route: Docker image `bi131-week3` (see `Dockerfile`), 4 CPUs and 4.8 GiB RAM available to WSL, analysis run with 2 threads.

## FastQC observation
Both read files contain 1,245,599 reads of 150 bp (186.8 Mbp each, 40% GC). All modules passed except per-sequence GC content, which gave a WARN in both files; this is likely because the reads come from one chromosome and do not follow FastQC's whole-genome GC model. No adapter content was detected, so no trimming was done. Total sequence is about 373.6 Mbp over a 46.7 Mbp chromosome, roughly 8x average depth, so this reduced dataset is not representative of full 30x human WGS and low depth may limit variant sensitivity.

## Alignment and duplicate marking
Reads were aligned to `reference/chr21.fa` with BWA-MEM inside the `bi131-week3` container, and duplicates were marked with GATK MarkDuplicates (`results/aligned/sample1.marked.bam`, index `.bai`). The marked BAM has 2,491,219 records: 2,491,198 primary and 21 supplementary, with 2,491,212 mapped (rounds to 100.00%) and 2,491,186 properly paired. There are 3 singletons and no reads with a mate on another chromosome. MarkDuplicates flagged 232 reads (116 read pairs, 0.0093% duplication). See `results/aligned/alignment-report.txt`. The first flagstat file (`sample1.flagstat.txt`) was taken before duplicate marking and shows 0 duplicates; `sample1.marked.flagstat.txt` is the post-marking one.

## Variant calling and filtering
Germline variants were called with GATK HaplotypeCaller (GATK 4.6.2.0) and hard-filtered (`evidence/haplotypecaller.log`, `evidence/variantfiltration.log`). Of 14,456 raw variants, 312 were filtered out (282 HighSOR, 4 HighSOR;LowMQ, 24 LowMQ, 2 LowQD) and 14,144 PASS (12,075 SNPs and 2,069 indels; `results/variants/sample1.stats.txt`, `results/variants/variant-counts.txt`).

## Annotation
PASS variants were annotated with SnpEff 5.2 using database GRCh38.105 (`results/annotation/sample1.annotated.vcf.gz`, `sample1.annotated.tsv`; 14,144 records). The first Docker builds failed on the SnpEff download; causes and fixes are in `evidence/troubleshooting.tsv`.

## IGV review of candidate variants
Two candidates were inspected in IGV and recorded in `results/igv-review.tsv`:
- **chr21:33576378 G>GA** (SON frameshift): supported. All 7 reads carry the insertion (5 reverse, 2 forward), MAPQ 60, no soft-clipping, QUAL 247.98.
- **chr21:33931469 A>G** (splice donor variant): ambiguous. Only 3 of 10 reads carry the alternate allele (AD 7,3, QUAL 44.64, QD 4.46), and the alt reads have near-equal alternative alignments elsewhere on chr21 (XA tags), so a repeated copy or alignment artefact cannot be ruled out.

## Validation
File, index and checksum checks are recorded in `evidence/validation.log`.

## Limitations
The dataset is one chromosome at about 8x average depth, so it is not comparable to 30x whole-genome sequencing and low depth may limit sensitivity. IGV review shows read-level support for 7 to 10 reads only; it cannot establish genotype, functional or clinical effect, and it does not replace orthogonal validation. High MAPQ does not rule out repeated sequence, as the second variant shows. Annotated consequences are predictions.
