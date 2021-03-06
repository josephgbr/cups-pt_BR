#!/bin/sh
#
# "$Id: 5.2-lpc.sh 11398 2013-11-06 20:11:11Z msweet $"
#
#   Test the lpc command.
#
#   Copyright 2007 by Apple Inc.
#   Copyright 1997-2005 by Easy Software Products, all rights reserved.
#
#   These coded instructions, statements, and computer programs are the
#   property of Apple Inc. and are protected by Federal copyright
#   law.  Distribution and use rights are outlined in the file "LICENSE.txt"
#   which should have been included with this file.  If this file is
#   file is missing or damaged, see the license at "http://www.cups.org/".
#

echo "LPC Test"
echo ""
echo "    lpc status"
$VALGRIND ../berkeley/lpc status 2>&1
if test $? != 0; then
	echo "    FAILED"
	exit 1
else
	echo "    PASSED"
fi
echo ""

#
# End of "$Id: 5.2-lpc.sh 11398 2013-11-06 20:11:11Z msweet $".
#
