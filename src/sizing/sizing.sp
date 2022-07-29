* sizing tunning
* vitor eduardo schuh

.include 45nm_HP.pm
.param lmin = 50n
.param wn = '2.5*lmin'
.param wp = '1.75*wn'

.subckt inv a not_a vdd vss
minv000 not_a a vdd vdd pmos l=lmin w=wp
minv001 not_a a vss vss nmos l=lmin w=wn
.ends inv

xinv1 in_1 out_1 vdd vss inv
xinv2 in_2 out_2 vdd vss inv

vstep1 in_1 0 pwl(0 0 0.995m 0 1m 1)
vstep2 in_2 0 pwl(0 1 0.995m 1 1m 0)
vdd vdd 0 dc 1
vss vss 0 dc 0

c1 out_1 0 1n
c2 out_2 0 1n

.control
run
tran .5m 10m
let lmin = 50n
let wn = 2.5*lmin
let wp = 1.75*wn
print wn wp >> sizing.log
meas tran t_hilo trig v(out_1) val={0.9*vdd} cross=1
+ targ v(out_1) val={0.1*vdd} cross=1
meas tran t_lohi trig v(out_2) val={0.1*vdd} cross=1
+ targ v(out_2) val={0.9*vdd} cross=1
print t_hilo t_lohi >> sizing.log
.endc