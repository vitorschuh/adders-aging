* 4-bits-adder circuit netlist
* vitor eduardo schuh

.include 45nm_HP.pm
.param lmin = 50n
.param wn = '2.5*lmin'
.param wp = '1.75*wn'
.param wn_x4 = '4*wn'
.param wp_x4 = '4*wp'

.subckt inv a not_a vdd vss
minv000 not_a a vdd vdd pmos l=lmin w=wp
minv001 not_a a vss vss nmos l=lmin w=wn
.ends inv

.subckt inv_x4 a not_a vdd vss
minv000 not_a a vdd vdd pmos l=lmin w=wp_x4
minv001 not_a a vss vss nmos l=lmin w=wn_x4
.ends inv_x4

.subckt and a b vdd vss out
mand000 tmp a vdd vdd pmos l=lmin w=wp
mand001 tmp b vdd vdd pmos l=lmin w=wp
mand002 tmp a pd pd nmos l=lmin w=wn
mand003 pd b vss vss nmos l=lmin w=wn
mand004 out tmp vdd vdd pmos l=lmin w=wp
mand005 out tmp vss vss nmos l=lmin w=wp
.ends and

.subckt or a b vdd vss out
mor000 pu a vdd vdd pmos l=lmin w=wp
mor001 tmp b pu pu pmos l=lmin w=wp
mor002 tmp a vss vss nmos l=lmin w=wn
mor003 tmp b vss vss nmos l=lmin w=wn
mor004 out tmp vdd vdd pmos l=lmin w=wp
mor005 out tmp vss vss nmos l=lmin w=wn
.ends or

.subckt xor a b vdd vss out
mxor000 not_a a vdd vdd pmos l=lmin w=wp
mxor001 not_a a vss vss nmos l=lmin w=wn
mxor002 not_b b vdd vdd pmos l=lmin w=wp
mxor003 not_b b vss vss nmos l=lmin w=wn
mxor004 pu_l not_b vdd vdd pmos l=lmin w=wp
mxor005 out a pu_l pu_l pmos l=lmin w=wp
mxor006 out b pd_l pd_l nmos l=lmin w=wn
mxor007 pd_l a vss vss nmos l=lmin w=wn
mxor008 pu_r b vdd vdd pmos l=lmin w=wp
mxor009 out not_a pu_r pu_r pmos l=lmin w=wp
mxor010 out not_b pd_r pd_r nmos l=lmin w=wn
mxor011 pd_r not_a vss vss nmos l=lmin w=wn
.ends xor

.subckt half_adder a b vdd vss s c_out
xlogic000 a b vdd vss c_out and
xlogic001 a b vdd vss s xor
.ends half_adder

.subckt full_adder a b c_in vdd vss s c_out
xlogic000 a b vdd vss tmp_1 xor
xlogic001 tmp_1 c_in vdd vss s xor
xlogic002 c_in tmp_1 vdd vss tmp_2 and
xlogic003 a b vdd vss tmp_3 and
xlogic004 tmp_2 tmp_3 vdd vss c_out or
.ends full_adder

.subckt 4_bit_adder a_0 a_1 a_2 a_3 b_0 b_1 b_2 b_3 vdd vss s_0 s_1 s_2 s_3 c_out
xaddr000 a_0, b_0, vdd, vss, s_0, c_out_0 half_adder
xaddr001 a_1, b_1, c_out_0, vdd, vss, s_1, c_out_1 full_adder
xaddr002 a_2, b_2, c_out_1, vdd, vss, s_2, c_out_2 full_adder
xaddr003 a_3, b_3, c_out_2, vdd, vss, s_3, c_out full_adder
.ends 4_bit_adder

.subckt fan_in_cell in out vdd vss
xinv000 in tmp vdd vss inv_x4
xinv001 tmp out vdd vss inv_x4
.ends fan_in_cell

.subckt fan_in in_0 in_1 in_2 in_3 out_0 out_1 out_2 out_3 vdd vss
xcell000 in_0 out_0 vdd vss fan_in_cell
xcell001 in_1 out_1 vdd vss fan_in_cell
xcell002 in_2 out_2 vdd vss fan_in_cell
xcell003 in_3 out_3 vdd vss fan_in_cell
.ends fan_in

.subckt fan_out in out vdd vss
xinv000 in out vdd vss inv
xinv001 in out vdd vss inv
xinv002 in out vdd vss inv
xinv003 in out vdd vss inv
.ends fan_out

xdelay_a a_in_0 a_in_1 a_in_2 a_in_3 a_out_0 a_out_1 a_out_2 a_out_3 vdd_aux vss fan_in
xdelay_b b_in_0 b_in_1 b_in_2 b_in_3 b_out_0 b_out_1 b_out_2 b_out_3 vdd_aux vss fan_in
xdut a_out_0 a_out_1 a_out_2 a_out_3 b_out_0 b_out_1 b_out_2 b_out_3 vdd vss s_out_0 s_out_1 s_out_2 s_out_3 c_out 4_bit_adder
xcharge_s_0 s_out_0 dummy_0 vdd_aux vss fan_out
xcharge_s_1 s_out_1 dummy_1 vdd_aux vss fan_out
xcharge_s_2 s_out_2 dummy_2 vdd_aux vss fan_out
xcharge_s_3 s_out_3 dummy_3 vdd_aux vss fan_out

v_a_in_0 a_in_0 0 pwl(0 0 5e-09 0 5.01e-09 0 1e-08 0 1.001e-08 0 1.5000000000000002e-08 0 1.5010000000000003e-08 0 2e-08 0 2.0010000000000002e-08 0 2.5e-08 0 2.501e-08 0 3.0000000000000004e-08 0 3.001e-08 1 3.5e-08 1 3.501e-08 1 4e-08 1 4.001e-08 0 4.5e-08 0 4.501e-08 1)
v_a_in_1 a_in_1 0 pwl(0 1 5e-09 1 5.01e-09 0 1e-08 0 1.001e-08 1 1.5000000000000002e-08 1 1.5010000000000003e-08 1 2e-08 1 2.0010000000000002e-08 1 2.5e-08 1 2.501e-08 1 3.0000000000000004e-08 1 3.001e-08 1 3.5e-08 1 3.501e-08 0 4e-08 0 4.001e-08 0 4.5e-08 0 4.501e-08 0)
v_a_in_2 a_in_2 0 pwl(0 1 5e-09 1 5.01e-09 0 1e-08 0 1.001e-08 0 1.5000000000000002e-08 0 1.5010000000000003e-08 0 2e-08 0 2.0010000000000002e-08 0 2.5e-08 0 2.501e-08 1 3.0000000000000004e-08 1 3.001e-08 0 3.5e-08 0 3.501e-08 0 4e-08 0 4.001e-08 1 4.5e-08 1 4.501e-08 1)
v_a_in_3 a_in_3 0 pwl(0 1 5e-09 1 5.01e-09 0 1e-08 0 1.001e-08 0 1.5000000000000002e-08 0 1.5010000000000003e-08 0 2e-08 0 2.0010000000000002e-08 1 2.5e-08 1 2.501e-08 1 3.0000000000000004e-08 1 3.001e-08 0 3.5e-08 0 3.501e-08 0 4e-08 0 4.001e-08 1 4.5e-08 1 4.501e-08 1)
v_b_in_0 b_in_0 0 pwl(0 0 5e-09 0 5.01e-09 1 1e-08 1 1.001e-08 0 1.5000000000000002e-08 0 1.5010000000000003e-08 0 2e-08 0 2.0010000000000002e-08 0 2.5e-08 0 2.501e-08 1 3.0000000000000004e-08 1 3.001e-08 0 3.5e-08 0 3.501e-08 0 4e-08 0 4.001e-08 1 4.5e-08 1 4.501e-08 1)
v_b_in_1 b_in_1 0 pwl(0 0 5e-09 0 5.01e-09 1 1e-08 1 1.001e-08 1 1.5000000000000002e-08 1 1.5010000000000003e-08 1 2e-08 1 2.0010000000000002e-08 1 2.5e-08 1 2.501e-08 1 3.0000000000000004e-08 1 3.001e-08 0 3.5e-08 0 3.501e-08 0 4e-08 0 4.001e-08 1 4.5e-08 1 4.501e-08 0)
v_b_in_2 b_in_2 0 pwl(0 1 5e-09 1 5.01e-09 1 1e-08 1 1.001e-08 0 1.5000000000000002e-08 0 1.5010000000000003e-08 0 2e-08 0 2.0010000000000002e-08 0 2.5e-08 0 2.501e-08 1 3.0000000000000004e-08 1 3.001e-08 0 3.5e-08 0 3.501e-08 0 4e-08 0 4.001e-08 1 4.5e-08 1 4.501e-08 1)
v_b_in_3 b_in_3 0 pwl(0 1 5e-09 1 5.01e-09 0 1e-08 0 1.001e-08 1 1.5000000000000002e-08 1 1.5010000000000003e-08 0 2e-08 0 2.0010000000000002e-08 1 2.5e-08 1 2.501e-08 1 3.0000000000000004e-08 1 3.001e-08 0 3.5e-08 0 3.501e-08 0 4e-08 0 4.001e-08 0 4.5e-08 0 4.501e-08 1)


vs_0 vdd 0 dc 1
vs_1 vdd_aux 0 dc 1
vs_2 vss 0 dc 0

.control
run
tran 1n 50n
plot v(s_out_0) xlimit 0 50e-9 ylimit -0.5 1.5
plot v(s_out_1) xlimit 0 50e-9 limit -0.5 1.5
plot v(s_out_2) xlimit 0 50e-9 ylimit -0.5 1.5
plot v(s_out_3) xlimit 0 50e-9 ylimit -0.5 1.5
plot v(c_out) xlimit 0 50e-9 ylimit -0.5 1.5
.endc