#!/usr/bin/env python

# #%% imports
import argparse
from Bio import SeqIO

parser = argparse.ArgumentParser()
parser.add_argument("-fasta", help="FASTA input file for peptide chopping", default=None)
parser.add_argument("-out", help="The output file for the input of MixMHC2pred", default=None)
parser.add_argument("-pep_length_min", type=int, help="Minimum length of peptides (should be >=12)", default=15)
parser.add_argument("-pep_length_max", type=int, help="Maximum length of peptides (should be <=21)", default=15)
args = parser.parse_args()


#%% parameters
fastafile = args.fasta
pep_length_min = args.pep_length_min
pep_length_max = args.pep_length_max
dataout = args.out

#%% chop
with open(fastafile, "r") as infile, open(dataout, "w") as outfile:
    c = 0
    for record in SeqIO.parse(infile, "fasta"):
        protseq = str(record.seq)
        prot_len = len(protseq) 
        if prot_len < pep_length_min:
            print(f"protein sequence too short for {record.id} ({len(protseq)})")
            break

        print(record.id)
        print(protseq)

        # remove the ending "*" on sequences
        if protseq.endswith("*"):
            protseq = protseq[:-1]

        protseq = "---" + protseq + "---"

        # iterate over all possible peptides
        peptides = []
        for pos in range(3, len(protseq)-2-pep_length_min):

            for l in range(pep_length_min, pep_length_max+1):
                if pos + l < prot_len+3:
                    pep = protseq[pos:pos+l]
                    context = protseq[pos-3:pos+3] + protseq[pos-3+l:pos+3+l]
                    peptides.append(pep + "\t" + context)
        
        outfile.writelines('\n'.join(peptides) + '\n')

# %%
