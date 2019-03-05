
all: build/iqmod.pdf build/fftTest.pdf build/fftIq.pdf
	@echo "done $*"
	@echo "done $^"
	@echo "done $<"
	@echo "done $@"

build/iqmod.pdf: iqmod.m
	octave-cli -qf $<

build/fftIq.pdf: fftIq.m
	octave-cli -qf $<

build/fftTest.pdf: fftTest.m
	octave-cli -qf $<

clean:
	-rm -rf build octave-workspace
