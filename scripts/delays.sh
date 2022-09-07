# must be run on ngspice-24 with the charge trap model engine
for round in $(seq 0 99);
do
    for stress_time in $(seq -7 7);
    do
        echo "$(date) static time analysis round: $round stress time: 1e$stress_time" >> temp/trapped.log;
        ngspice < core/ripple-carry/generator/under-traps-delays/1e$stress_time.cir;
        ngspice < core/carry-lookahead/generator/under-traps-delays/1e$stress_time.cir;
    done
done