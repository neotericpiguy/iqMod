

all:
	octave-cli -qf iqmod.m

clean:
	-rm -rf build
