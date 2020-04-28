#!/bin/sh

/bin/sed -i 's/WAIT_TIMEOUT=300/'"WAIT_TIMEOUT=$WAIT_TIMEOUT"'/g' /opt/pdfmerge.sh
/bin/sed -i 's/ROTATE_ODD=0/'"ROTATE_ODD=$ROTATE_ODD"'/g' /opt/pdfmerge.sh
/bin/sed -i 's/ROTATE_EVEN=1/'"ROTATE_EVEN=$ROTATE_EVEN"'/g' /opt/pdfmerge.sh
/bin/sed -i 's/REVERSE_EVEN=1/'"REVERSE_EVEN=$REVERSE_EVEN"'/g' /opt/pdfmerge.sh
chown -R app:app /input /output
exec "$@"
