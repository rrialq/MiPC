!/bin/bash

# Para formatear con el filesystem udf
#sudo apt-get install udftools
#Borramos el particionado
#sudo dd if=/dev/zero of=/dev/sdi bs=1M count=1
#Formateamos
#sudo mkudffs -b 512 --media-type=hd --utf8 --lvid=DriveLabel --vid=DriveLabel --fsid=DriveLabel  /dev/sdi