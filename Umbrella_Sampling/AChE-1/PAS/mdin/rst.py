import numpy as np

a = 2 * np.abs(0.33)
r1 = 25.22 - a
r4 = 25.22 + a

outfile = open('./RST/d.25.22.RST', 'w')

outfile.write('''Umbrella restraint
&rst 
iat=-1,-1, igr1=8357, igr2=6769,6771,6774,6775, r1=%.2f, r2=25.22, r3=25.22, r4=%.2f, rk2=10.0, rk3=10.0,
&end\n''' %(r1,r4) )

