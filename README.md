# MHC2-prediction-workflows

A Nextflow script using MixMHC2pred (https://github.com/GfellerLab/MixMHC2pred) to predict MHC class II
ligands and epitopes given a protein FASTA file and the desired alleles.

## Setup
You need Nextflow (>=24.04.0) and docker installed.

Before the first execution run the Makefile in the main directory by executing
```
main
```
in the root filder of the project. This should download respectively build all required docker images.

## Running the workflow
After downloading and building the images, execute the script like:

```
nextflow run main.nf -profile docker \
    --fasta /path/to/proteins.fasta  \
    --pep_length_min 12  --pep_length_max 15 \
    --alleles "DRB1_15_01 DRB5_01_01"
```

For the alleles, please refer to the MixMHC2pred homepage (https://github.com/GfellerLab/MixMHC2pred)

The output of the prediction will be given in the `results` folder.

### Arguments

| name | description | default
| --- | --- | --- |
| `--fasta` | path to the FASTA file containing protein sequences | |
| `--pep_length_min` | Minimal length of peptides for the prediction | 15 |
| `--pep_length_max` | Directory where results should be stored | 15 |
| `--alleles` | Set to false if there are decoys in your FASTA file | "DRB1_15_01 DRB5_01_01" |
