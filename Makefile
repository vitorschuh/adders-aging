dirs:
	sh src/scripts/skeleton.sh

env:
	sh src/scripts/pyenv.sh
	
base:
	sh src/scripts/traces.sh

montecarlo:
	sh src/scripts/delays.sh
	sh src/scripts/power.sh