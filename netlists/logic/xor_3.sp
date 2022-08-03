* 4-bits-adder circuit netlist
* vitor eduardo schuh

.include 45nm_HP.pm
.param lmin = 50n
.param wn = '2.5*lmin'
.param wp = '1.75*wn'

.subckt xor_3 a b c vdd vss out 
mxor000 not_a a vdd vdd pmos l=lmin w=wp
mxor001 not_a a vss vss nmos l=lmin w=wn
mxor002 not_b b vdd vdd pmos l=lmin w=wp
mxor003 not_b b vss vss nmos l=lmin w=wn
mxor004 not_c c vdd vdd pmos l=lmin w=wp
mxor005 not_c c vss vss nmos l=lmin w=wn
mxor006 pu_a_b a vdd vdd pmos l=lmin w=wp
mxor007 pu_bnb_nc b pu_a_b pu_a_b pmos l=lmin w=wp
mxor008 out not_c pu_bnb_nc pu_bnb_nc pmos l=lmin w=wp
mxor009 pu_na_nb not_a vdd vdd pmos l=lmin w=wp
mxor010 pu_bnb_nc not_b pu_na_nb pu_na_nb pmos l=lmin w=wp
mxor011 pu_a_nb a vdd vdd pmos l=lmin w=wp
mxor012 pu_nbb_c not_b pu_a_nb pu_a_nb pmos l=lmin w=wp
mxor013 out c pu_nbb_c pu_nbb_c pmos l=lmin w=wp
mxor014 pu_na_b not_a vdd vdd pmos l=lmin w=wp
mxor015 pu_nbb_c b pu_na_b pu_na_b pmos l=lmin w=wp
mxor016 out not_a pd_na_nbb pd_na_nbb nmos l=lmin w=wn
mxor017 pd_na_nbb not_b pd_nb_nc pd_nb_nc nmos l=lmin w=wn
mxor018 pd_nb_nc not_c vss vss nmos l=lmin w=wn
mxor019 pd_na_nbb b pd_b_c pd_b_c nmos l=lmin w=wn
mxor020 pd_b_c c vdd vdd nmos l=lmin w=wn
mxor021 out a pd_a_bnb pd_a_bnb nmos l=lmin w=wn
mxor022 pd_a_bnb b pd_b_nc pd_b_nc nmos l=lmin w=wn
mxor023 pd_b_nc not_c vdd vdd nmos l=lmin w=wn
mxor024 pd_a_bnb not_b pd_nb_c pd_nb_c nmos l=lmin w=wn
mxor025 pd_nb_c c vdd vdd nmos l=lmin w=wn 
.ends

xxor_3 in_1 in_2 in_3 vdd vss out_1 xor_3

v_in_1 in_1 0 pwl(0 0 5e-09 0 5.01e-09 1 1e-08 1 1.001e-08 0 1.5000000000000002e-08 0 1.5010000000000003e-08 1 2e-08 1 2.0010000000000002e-08 0 2.5e-08 0 2.501e-08 1 3.0000000000000004e-08 1 3.001e-08 0 3.5e-08 0 3.501e-08 1)
v_in_2 in_2 0 pwl(0 0 5e-09 0 5.01e-09 0 1e-08 0 1.001e-08 1 1.5000000000000002e-08 1 1.5010000000000003e-08 1 2e-08 1 2.0010000000000002e-08 0 2.5e-08 0 2.501e-08 0 3.0000000000000004e-08 0 3.001e-08 1 3.5e-08 1 3.501e-08 1)
v_in_3 in_3 0 pwl(0 0 5e-09 0 5.01e-09 0 1e-08 0 1.001e-08 0 1.5000000000000002e-08 0 1.5010000000000003e-08 0 2e-08 0 2.0010000000000002e-08 1 2.5e-08 1 2.501e-08 1 3.0000000000000004e-08 1 3.001e-08 1 3.5e-08 1 3.501e-08 1)

vdd vdd 0 dc 1
vss vss 0 dc 0

c1 out_1 0 1e-18

.control
run
tran 1n 40n
plot v(in_1) xlimit 0 40e-9 ylimit -0.5 1.5
plot v(in_2) xlimit 0 40e-9 ylimit -0.5 1.5
plot v(in_3) xlimit 0 40e-9 ylimit -0.5 1.5
plot v(out_1) xlimit 0 40e-9 ylimit -0.5 1.5
.endc
