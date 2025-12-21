copy /y TEMPLATE.IMG BOOT.IMG
imdisk -a -f BOOT.IMG -m A: -o rem
xcopy CONTENT\* A:\ /E /H /K
imdisk -D -m A:
