#! /usr/bin/env python3

import argparse
from os import path
from sys import exit

def create_template_env_file(in_file, out_file, unsafe_vars, del_comments=False, keep_safe_vals=False):
	with open(in_file,'r') as env:
		print("Reading from file: {}".format(path.abspath(in_file)))
		# get in_file content
		src_txt = env.read()
		# text to be written in out_file
		with open(out_file, 'w') as template:
			print("Writing to file: {}".format(path.abspath(out_file)))
			headersep = '#' + '*'*40 + '\n\n'
			header = '# Template env with all the required variables.\n# Make sure to fill any' + \
			'empty values and remove ".template" suffix from the file name.\n\n'
			header = headersep + header + headersep
			template.write(header)
			#template.write(header)
			for line in src_txt.split('\n'):
				# if line is whitespace then write
				if not line.strip():
					template.write(line + '\n')
				# if line is a comment and want to keep, then write
				elif line[0] == '#' and not del_comments:					
					template.write(line + '\n')
				# line is VAR=VAL, write accordingly
				else:
					var, val = line.split('=')
					# if option to keep safe vars and the var is not any of the sensitive var types
					if keep_safe_vals and not any(v in var.upper() for v in unsafe_vars):
						template.write(var + '=' + val + '\n')
					else:
						template.write(var + '=' + '\n')
	exit(0)
			


if __name__ == '__main__':
	desc = """Simple script to create template env files with all the vars without sensitive values. 
	\nUseful for sharing or uploading your implementation without cleaning up sensitive vars manually.
	\nExpects and writes docker env files in the form of VAR=VAL, separated by newlines, and with 
	\ncomments starting with #."""
	unsafe_vars = ['KEY', 'CERT', 'SECRET', 'COOKIE', 'TOKEN', 'PASSWORD']

	parser = argparse.ArgumentParser(description=desc)
	parser.add_argument('-i', '--in-file', required=True, help='original *.env file to be parsed')
	parser.add_argument('-o', '--out-file', help='template *.env file to be written. (default: <path>/<input env file>.template)', default='')
	parser.add_argument('--no-comments', help='Option to write file without any comments', action='store_true')
	parser.add_argument('-k', '--keep-safe-vals', help="Option to keep non-sensitive values (var name doesn't include any of {})".format(unsafe_vars),
		action='store_true')
	# get dict of parsed args and their values
	args = parser.parse_args()
	
	if path.exists(args.in_file): 
		# if no output file is provided use the same path as input file
		# and same input name with .template suffix
		if not args.out_file:
			args.in_file = path.abspath(args.in_file)
			in_path = '/'.join(args.in_file.split('/')[:-1])
			args.out_file = in_path + '/' + args.in_file.split('/')[-1] + '.template'
		create_template_env_file(args.in_file, args.out_file, unsafe_vars, args.no_comments, args.keep_safe_vals)
	else:
		print('ERROR! There is an error with the provided input file.\n' + \
			'Check that file path is correct and that you have appropriate permissions to read and write')
		exit(1)
