# Script to clean up record identifiers from fasta sequence files
# Renames every sequence id to organism name

def addoptions():

	'''Provides the user flags to tweak the program'''

	import argparse

	parser = argparse.ArgumentParser()
	
	parser.add_argument('input_file', help='Input file in fasta format')
	parser.add_argument('-o', '--outfile', help='Specify the output file')

	args = parser.parse_args()

	fin = args.input_file
	fout = args.outfile

	return fin, fout


def clean_headers(infile, outfile=None):

	'''Clean the sequence headers limited to organism names
	and write to a different file if specified'''

	import re
	from pathlib import Path

	if outfile != None:
		fout = open(outfile, 'w')
	else:
		fout = open(Path(infile).stem + '_clean.fasta', 'w')

	for line in open(infile, 'r').readlines():
		line = line.strip()
		if line.startswith('>'):
			org_name = re.findall(r"\[(.*?)\]", line)[-1]
			fout.write('>' + org_name + '\n')
		else:
			fout.write(line + '\n')

	fout.close()

	return

if __name__ == '__main__':

	arguments = addoptions()

	if len(arguments) != 1:
		clean_headers(arguments[0], outfile=arguments[1])
	else:
		clean_headers(arguments[0])

# Abhilesh Dhawanjewar
# abhilesh7@gmail.com