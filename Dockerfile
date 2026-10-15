FROM mambaorg/micromamba:2.3.2
RUN micromamba install -y -n base -c conda-forge -c bioconda \
    bash \
    coreutils \
    procps-ng \
    fastqc \
    bwa \
    samtools \
    bcftools \
    gatk4 \
    snpeff=5.2 \
    htslib \
    && micromamba clean --all --yes
ARG MAMBA_DOCKERFILE_ACTIVATE=1
RUN snpEff download -v GRCh38.105
WORKDIR /work
CMD ["bash"]
