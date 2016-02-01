#!/bin/bash
#
#   gen_diff - compare source<->pt_BR tmpl files, and store in a text file
#   Copyright (C) 2016 Rafael Fontenelle
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# syntax of the value is ll_CC, where 'll' is language code and 'CC' is country
locale=pt_BR

# name of file that will store the comparison result of tmpl files
# p.s.: will be stored in templates folder!
outfile=review.txt

# Make sure what is the current work dir and where are the '.tmpl' files'.
case $(basename $(pwd)) in
   cups-?.?.?)   srctmpldir="templates" ;;
   templates)    srctmpldir="." ;;
   *) # are we inside a locale folder, e.g. templates/pt_BR ?
      if [[ $(basename $(dirname $(pwd))) == templates ]]; then
        srctmpldir=".."
      else
        echo "Unable to find templates/ folder." && exit 1
      fi
      ;;
esac


# Get list of template files and bail out if there is none.
tmpllist=$(ls $srctmpldir/*.tmpl)
if [[ -z $tmpllist ]]; then
    echo "Unable to find templates inside the templates/ folder. Aborting..."
    exit 1
fi


# Set dsttmpldir with the template translation folder and check it out
dsttmpldir=$srctmpldir/$locale
if [[ ! -d $dsttmpldir ]]; then
    echo "Unable to find template translation folder $dsttmpldir. Exiting..."
    exit 1
fi
if [[ $(find $dsttmpldir -maxdepth 0 -empty) == $dsttmpldir ]]; then
    echo "The template translation folder $dsttmpldir is empty. No reason to go further. Exiting..."
    exit 1
fi


# Set output file to templates/ and verify if it can be created.
outfile=$srctmpldir/$outfile
rm $outfile
touch $outfile
if [[ $? -ne 0 ]]; then
    echo "Output file $outfile is not writable. Aborting..."
    exit 1
fi

failedfiles=
echo "Comparison of Templates generated by gen_diff.sh in $(date)" >> $outfile
for tmplfile in $tmpllist; do
    if ! [[ -e $dsttmpldir/$(basename $tmplfile) ]]; then
        failedfiles="$failedfiles $(basename $tmplfile)"
    else
        echo -e "\n=========================================\n" >> $outfile
        echo -e "$tmplfile\n\n" >> $outfile
        diff -Naur $tmplfile $dsttmpldir/$(basename $tmplfile) >> $outfile
        echo -e "\n" >> $outfile
    fi
done

if [[ -n $failedfiles ]]; then
    echo "The following files doesn't exist in template translation folder, so comparison failed for them:"
    echo $failedfiles
fi