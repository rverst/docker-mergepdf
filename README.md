# pdfmerge
  ![automation](https://img.shields.io/docker/cloud/automated/rverst/pdfmerge) ![build status](https://img.shields.io/docker/cloud/build/rverst/pdfmerge)

TL;DR  
A docker-container that watches for incoming files (incrond) and merges them together
 (using [qpdf](http://qpdf.sourceforge.net)) if needed.  

The reason I created this project, is a scanner (HP OfficeJet) whose duplex unit sucks.
It can’t handle folded sheets well (paperjam in 8 out of 10 cases).
So I need to scan the odd and even pages separately and merge them together afterwards.  
The docker-container is running on my NAS (QNAP TS-251+) and watches for new files in a mounted volume,
in which the scanner saves it files. The files are prefixed based on scan-profiles and merged based on
these prefixes.  
For convenience I reverse the order of the even pages and rotate them by 180 degree during the
merge process. Doing that I can simply take the scanned pages from the output
tray and put them back to the input feeder without the need to rotate and reorder them.

## Example usage:
```console
> docker pull rverst/pdfmerge
> docker run -v /scan_folder:/input \
             -v /scan_folder:/output \
             rverst/pdfmerge:latest
```
Note that the script runs as UID 1000 and GID 1000 by default. These may be altered with the PUID and PGID environment variables.

## Environment variables:

 * PUID - UID to use
 * GUID - GID to use
 * WAIT_TIMEOUT - timeout in sec. the script waits for a file to close. Should not be to short since some scanners
 create the file at the beginning of the scan.
 * ROTATE_ODD - rotate the odd pages
 * ROTATE_EVEN - rotate the even pages
 * REVERSE_EVEN - reverse the order of the even pages

## Alternatives:
* [docker-mergepdf](https://github.com/tuxflo/docker-mergepdf) - Inspiration for this little project.

