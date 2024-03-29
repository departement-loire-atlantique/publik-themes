#! /usr/bin/env python

import base64
import os
import sys
import argparse


def data_uri(sourcepath):
  path = os.getcwd()
  os.chdir(sourcepath)
  data_uris = []
  for filename in os.listdir('.'):
    varname, filetype = os.path.splitext(filename)
    mimetype = {
        '.png': 'image/png',
        '.svg': 'image/svg+xml'
    }.get(filetype)
    if not mimetype:
        continue
    filesize = os.stat(filename).st_size
    if filesize > 10000:
        continue
    filecontent = open(filename, "rb").read()
    b64 = base64.b64encode(filecontent)
    data_uris.append('$data_uri_%(varname)s: "data:%(mimetype)s;base64,%(b64)s";' % locals())
  os.chdir(path)
  return data_uris

parser = argparse.ArgumentParser()
parser.add_argument('--source', action='append')
parser.add_argument('--dest', action='append')
args = parser.parse_args()

all_data_uris = [];

for source in args.source:
    all_data_uris += data_uri(source)

for dest in args.dest:
    open(dest, 'w').write('\n'.join(all_data_uris))
