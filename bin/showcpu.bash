#!/bin/bash
#Old version. Must be reviewed.
#Show information about cpu

TEMP_FILE="${HOME}/cpu_info.log"
/usr/bin/kstat -m cpu_info | egrep "chip_id|core_id|module: cpu_info" > ${TEMP_FILE}

nproc=`(grep chip_id ${TEMP_FILE} | awk '{ print $2 }' | sort -u | wc -l | tr -d ' ')`
ncore=`(grep core_id ${TEMP_FILE} | awk '{ print $2 }' | sort -u | wc -l | tr -d ' ')`
vproc=`(grep 'module: cpu_info' ${TEMP_FILE} | awk '{ print $4 }' | sort -u | wc -l | tr -d ' ')`

nstrandspercore=$(($vproc/$ncore))
ncoresperproc=$(($ncore/$nproc))

speedinmhz=`(/usr/bin/kstat -m cpu_info | grep clock_MHz | awk '{ print $2 }' | sort -u)`
speedinghz=`echo "scale=2; $speedinmhz/1000" | bc`

echo "Total number of physical processors: $nproc"
echo "Number of virtual processors: $vproc"
echo "Total number of cores: $ncore"
echo "Number of cores per physical processor: $ncoresperproc"
echo "Number of hardware threads (strands or vCPUs) per core: $nstrandspercore"
echo "Processor speed: $speedinmhz MHz ($speedinghz GHz)"

# now derive the vcpu-to-core mapping based on above information #

echo -e "\n** Socket-Core-vCPU mapping **"
let linenum=2

for ((i = 1; i <= ${nproc}; ++i ))
do
        chipid=`sed -n ${linenum}p ${TEMP_FILE} | awk '{ print $2 }'`
        echo -e "\nPhysical Processor $i (chip id: $chipid):"

        for ((j = 1; j <= ${ncoresperproc}; ++j ))
        do
                let linenum=($linenum + 1)
                coreid=`sed -n ${linenum}p ${TEMP_FILE} | awk '{ print $2 }'`
                echo -e "\tCore $j (core id: $coreid):"

                let linenum=($linenum - 2)
                vcpustart=`sed -n ${linenum}p ${TEMP_FILE} | awk '{ print $4 }'`

                let linenum=(3 * $nstrandspercore + $linenum - 3)
                vcpuend=`sed -n ${linenum}p ${TEMP_FILE} | awk '{ print $4 }'`

                echo -e "\t\tvCPU ids: $vcpustart - $vcpuend"
                let linenum=($linenum + 4)
        done
done

rm ${TEMP_FILE}
