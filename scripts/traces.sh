# must be run on ngspice-37
ngspice < core/ripple-carry/generator/ideal/delays.cir;
ngspice < core/ripple-carry/generator/ideal/power.cir;
ngspice < core/carry-lookahead/generator/ideal/delays.cir;
ngspice < core/carry-lookahead/generator/ideal/power.cir;