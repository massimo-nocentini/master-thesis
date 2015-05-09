
SAGE=~/Developer/snapshots/sage/sage-6.6/sage
SCRIPT_NAME=catalan.sage

echo "The following script will be executed under Sage environment:"
cat $SCRIPT_NAME

#PARENT_PATH=$(dirname "$PWD")
#PATH=$PATH:$PARENT_PATH 
$SAGE $SCRIPT_NAME
