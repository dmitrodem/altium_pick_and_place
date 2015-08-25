#!/usr/bin/env python2
# -*- coding: utf-8 -*-
#
# The following variations can be handled:
# 1. Do not fill part (Kind = 0)
# 2. Change 'Comment' field (Kind = 1)
#
# Currently Kind = 2 (Alternative Part change)
# is not supported
#

import ConfigParser
import sys
import re
import csv
from prettytable import PrettyTable
from argparse import ArgumentParser
from natsort import natsort_key

parser = ArgumentParser(description = 'Apply variation to pick and place file')
parser.add_argument('--project',
        action = 'store', 
        nargs = 1,
        type = str,
        required = True,
        help = 'Project file',
        metavar = 'file.PrjPcb',
        dest = 'project')

parser.add_argument('--variant',
        action = 'store', 
        nargs = 1,
        type = str,
        required = False,
        help = 'Variant index. Do not specify to see available variations',
        metavar = 'N',
        dest = 'variant_index')

parser.add_argument('--pnp',
        action = 'store', 
        nargs = 1,
        type = str,
        required = False,
        help = 'PickAndPlace CSV file',
        metavar = 'file.csv',
        dest = 'pnp')

parser.add_argument('--output',
        action = 'store', 
        nargs = 1,
        type = str,
        required = False,
        help = 'Output TXT file (stdout if not specified)',
        metavar = 'file.txt',
        dest = 'output')


args = parser.parse_args(sys.argv[1:])

conf = ConfigParser.RawConfigParser()
conf.read(args.project[0])

if not args.variant_index:
    print 'Available variations:'
    for section in conf.sections():
        m = re.match('ProjectVariant(\d+)', section);
        if m:
            print '%s: %s' %(m.group(1), conf.get(section, 'description'))
    print 'Select desired variation index via command line (--variant N)'
    sys.exit(0)

if not args.pnp:
    print 'Please specify pick and place file via command line (--pnp file.csv)'
    sys.exit(0)

variations = {}
paramvariations = {}
for section in conf.sections():
    if not re.match('ProjectVariant%s' % args.variant_index, section):
        continue
    for key, value in conf.items(section):
        if re.match('variation\d+', key):
            d = {}
            for part in value.split('|'):
                k, v = part.split('=')
                d.update({k: v})
            variations.update({d['Designator']: d['Kind']})
        m = re.match('paramdesignator(\d+)', key)
        if m:
            var_id = m.group(1)
            designator = value
            d = {}
            for part in conf.get(section, 'paramvariation%s' % var_id).split('|'):
                k,v = part.split('=')
                d.update({k: v})
            if paramvariations.has_key(designator):
                curr_value = paramvariations[designator]
            else:
                curr_value = {}
            curr_value.update({d['ParameterName']: d['VariantValue']})
            paramvariations.update({designator: curr_value})
    
with open(args.pnp[0], 'r') as f:
    reader = csv.reader(f)
    for row in reader:
        do_print = True
        
        # skip header lines
        if reader.line_num < 3:
            if reader.line_num == 1:
                t = PrettyTable(row)
            continue
        try:
            designator = row[0]
            if variations.has_key(designator):
                kind = variations[designator]
                if kind == '0':
                    row[10] = paramvariations[designator]['Comment']
                elif kind == '1':
                    do_print = False
            if do_print:
                t.add_row(row)
        except IndexError:
            pass

if args.output:
    with open(args.output[0], 'w') as f:
        f.write(t.get_string(border = False, sortby = 'Designator', sort_key = natsort_key))
else:
    print t.get_string(border = False, sortby = 'Designator', sort_key = natsort_key)
