#!/bin/bash -l

# rutina de MINIMIZACION del DIO

rm -f mdin1
cat <<eof > mdin1

&cntrl
        imin=1,
        ntx=1, irest=0,
        maxcyc=1000, ncyc=500,
        ntb=1, cut=10,
        IBELLY=1
&end
optimización ligandos
FIND
* * * *
SEARCH
RES 533
END
END

eof

sander -O -i mdin1  -o ache_1_min1.out -p ache_1_w.top -c ache_1_w.rst -r ache_1_min1.rst


# rutina de MINIMIZACION de WAT(solvente) i Na+

rm -f mdin2
cat <<eof > mdin2

&cntrl
        imin=1,
        ntx=1, irest=0,
        maxcyc=10000, ncyc=2000,
        ntb=1, cut=10,
        IBELLY=1
&end
optimización solvente
FIND
* * * *
SEARCH
RES 534 13438
END
END

eof

sander -O -i mdin2  -o ache_1_min2.out -p ache_1_w.top -c ache_1_min1.rst -r ache_1_min2.rst


# rutina de MINIMIZACION de H de proteina 

rm -f mdin3
cat <<eof > mdin3

&cntrl
        imin=1,
        ntx=1, irest=0,
        maxcyc=10000, ncyc=2000,
        ntb=1, cut=10,
        IBELLY=1
&end
optimizacion de hidrogenos
FIND
* H * *
* HC * *
* H1 * *
* H2 * *
* H3 * *
* HA * *
* H4 * *
* H5 * *
* HO * *
* HS * *
* HP * *
* HZ * *
SEARCH
RES 1 532
END
END

eof

sander -O -i mdin3  -o ache_1_min3.out -p ache_1_w.top -c ache_1_min2.rst -r ache_1_min3.rst


# rutina de MINIMIZACION de sistema completo

rm -f mdin4
cat <<eof > mdin4

&cntrl
        imin=1,
        ntx=1, irest=0,
        maxcyc=10000, ncyc=2000,
        ntb=1, cut=10,
&end

eof


sander -O -i mdin4  -o ache_1_min4.out -p ache_1_w.top -c ache_1_min3.rst -r ache_1_min4.rst

			  
# rutinas de EQUILIBRACION

$AMBERHOME/bin/pmemd.cuda -O -i equi1.in -p ache_1_w.top -c ache_1_min4.rst -r ache_1_equi1.rst7 -o ache_1_equi1.out -x ache_1_equi1.nc -e ache_1_equi1.ene -ref ache_1_min4.rst

$AMBERHOME/bin/pmemd.cuda -O -i equi2.in -p ache_1_w.top -c ache_1_equi1.rst7 -r ache_1_equi2.rst7 -o ache_1_equi2.out -x ache_1_equi2.nc -e ache_1_equi2.ene -ref ache_1_equi1.rst7

$AMBERHOME/bin/pmemd.cuda -O -i equi3.in -p ache_1_w.top -c ache_1_equi2.rst7 -r ache_1_equi3.rst7 -o ache_1_equi3.out -x ache_1_equi3.nc -e ache_1_equi3.ene -ref ache_1_equi2.rst7

$AMBERHOME/bin/pmemd.cuda -O -i equi4.in -p ache_1_w.top -c ache_1_equi3.rst7 -r ache_1_equi4.rst7 -o ache_1_equi4.out -x ache_1_equi4.nc -e ache_1_equi4.ene -ref ache_1_equi3.rst7

# generamos el archivo de entrada de la DM con el nombre adecuado

cp ache_1_equi4.rst7 ache_1_0ns.rst7


# rutina de DINAMICA MOLECULAR

for i in {5..100..5}
do
let z=${i}-5
$AMBERHOME/bin/pmemd.cuda -O -i run5ns.in -p ache_1_w.top -c ache_1_${z}ns.rst7 -r ache_1_${i}ns.rst7 -x ache_1_${i}ns.nc -e ache_1_${i}ns.ene -o ache_1_${i}ns.out
done





