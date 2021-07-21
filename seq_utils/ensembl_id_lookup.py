import requests
import sys
from collections import OrderedDict

from requests.models import HTTPError

# Specify Ensembl REST server address
ensembl_server = "https://rest.ensembl.org"
# Specify Ensembl Lookup Table
ensembl_ext = "/lookup/symbol"

# Take input file from command line argument
# Input file format
# First line: Species name
# Subsequent lines: gene symbol on each line
fin = sys.argv[1]

# Read all the lines from input file
fin_lines = open(fin, 'r').readlines()

# Format species name to lowercase and '_' as delimiter
species_name = '_'.join([x.lower() for x in fin_lines[0].split()])

# Remove trailing spaces from gene symbols
gene_list = [x.lower().strip() for x in fin_lines[1:]]

# Container to hold ensembl IDs for all the genes ---> {gene_symbol : ensembl_id}
ensembl_id_dict = OrderedDict()

# Make requests to the server for all genes
for gene_symbol in gene_list:
	try:
		# Sending request to Ensembl and asking for json output
		r = requests.get(ensembl_server+f'{ensembl_ext}/{species_name}/{gene_symbol}?', 
						headers={ "Content-Type" : "application/json"})

		# Exception in case of bad request
		if not r.ok:
  			r.raise_for_status()
  			sys.exit()

		# Convert HTML response to JSON dictionary
		ensembl_report = r.json()

		# Update the dictionary with ensembl ids
		ensembl_id_dict.update({gene_symbol : ensembl_report['id']})
	
	# If gene symbol not found add a '-' for ENSEMBL ID
	except:
		print(f'No entry found for {gene_symbol}')
		ensembl_id_dict.update({gene_symbol : '-'})

# Write output file
with open('ensembl_ids.csv', 'w') as fout:
	fout.write(','.join(['Gene Symbol', 'ENSEMBL ID']) + '\n')
	for gene in ensembl_id_dict:
		fout.write(','.join([gene, ensembl_id_dict[gene]]) + '\n')