#!/bin/bash

# \c to delete
# \a to insert the new patter on the new line
# c to replace matching text's line with new line
# ! at the end of the matching patter replaces the string other than that
# -e to run multiple sed commands
# i to add a new line before each match
#https://www.oakton.edu/user/2/rjtaylor/cis218/Handouts/sed.txt
#https://docstore.mik.ua/orelly/unix/upt/ch34_04.htm#:~:text=A%20sed%20command%20can%20specify,is%20applied%20to%20each%20line.

file='file1.txt'
file='replace.file'
#sed -i '/deleteLinePattern/ c\' $file
#sed -i '/donotdeletethisline/ a\deleteLinePattern' $file
#sed -i '/deleteLine/ c replaced the line containing deleteLine' $file

sed -i '/IPv4 local connections/ a\host    all             all               0.0.0.0/0            trust' $file
#sed -i '/usmanmuzaffarkhan/ a\ ' $file
#echo "Hello"
#sed -i '/IPv4/ c "Change line"' $file

#sed -i 's/tutorial/example/' $file
