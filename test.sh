echo '-------------------------------------------------------------------------'
echo
echo "TESTING FLAGS BEFORE FILES"
ash fileio --expires 1w help.txt license.md -e 1w readme.md -e 1w callable.sh
echo
echo '-------------------------------------------------------------------------'
echo
echo "TESTING FLAGS AFTER FILES"
ash fileio help.txt license.md -e 1w readme.md -e 1y callable.sh -e 3y
echo
echo '-------------------------------------------------------------------------'
echo
echo "TESTING SINGLE FILE UPLOAD - SHOULD COPY TO CLIPBOARD"
ash fileio help.txt
echo
echo '-------------------------------------------------------------------------'
echo
echo "TESTING SINGLE FILE UPLOAD WITH FLAG - SHOULD COPY TO CLIPBOARD"
ash fileio help.txt -e 1w
echo
echo '-------------------------------------------------------------------------'
echo
echo "TESTING BAD PARAMS"
echo "BAD PARAM (-f 3) at end of params"
ash fileio help.txt license.md -e 1w readme.md -e 1y callable.sh -e 3y -f 3
echo
echo "BAD PARAM (-f 2) at start of params"
ash fileio -f 2 --expires 1w help.txt license.md -e 1y readme.md -e 3y callable.sh
echo
echo '-------------------------------------------------------------------------'

