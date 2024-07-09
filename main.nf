nextflow.enable.dsl=2

// parameters set by the command line
params.fasta = ""
params.pep_length_min = 15
params.pep_length_max = 15
params.alleles = "DRB1_15_01 DRB5_01_01"

// check parameters
if (!params.fasta) { exit 1, 'Input fasta file not specified, please provide with the argument "--fasta /path/to/protein.fasta"' }

// enable "output" feature
nextflow.preview.output = true

workflow {
    fasta = Channel.fromPath(params.fasta).first()
    pep_length_min = params.pep_length_min
    pep_length_max = params.pep_length_max
    alleles = params.alleles

    peptides_file = chop_peptides(fasta, pep_length_min, pep_length_max)
    predictions = mixmhc2pred(peptides_file, alleles)

    publish:
    peptides_file >> 'mixmhc2pred'
    predictions >> 'mixmhc2pred'
}

output {
    directory 'results'
    mode 'copy'
}


process chop_peptides {
    container 'medbioinf/mhc2-predictions-python:latest'

    input:
    path fasta
    val pep_length_min
    val pep_length_max

    output:
    path "peptides_data.txt"

    """
    create-peptides.py -fasta ${fasta} -out peptides_data.txt -pep_length_min ${pep_length_min} -pep_length_max ${pep_length_max}
    """
}


process mixmhc2pred {
    container 'quay.io/medbioinf/mixmhc2pred'

    input:
    path peptides_with_context
    val alleles

    output:
    path "mixmhc2pred_out.txt"

    """
    MixMHC2pred --input ${peptides_with_context} --output mixmhc2pred_out.txt --alleles ${alleles}
    """
}