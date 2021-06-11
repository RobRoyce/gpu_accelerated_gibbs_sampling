CC=nvcc
CFLAGS=-lm -lcudadevrt -lcurand -g -arch=sm_60
INIT := init
TESTS := cont_pdf_test cont_gof_test int_test
MODULES := distrs utils gmm gmm_gibbs

.PHONY : clean test

all: $(INIT) $(MODULES) $(TESTS)

init:
	mkdir -p obj bin

distrs: src/distrs.cu src/distrs.h
	$(CC) -c $(CFLAGS) $< -o obj/$@.o -dc

utils: src/utils.cu src/utils.h
	$(CC) -c $(CFLAGS) $< -o obj/$@.o -dc

gmm: src/gmm.cu src/gmm.h
	$(CC) -c $(CFLAGS) $< -o obj/$@.o -dc

gmm_gibbs: src/gmm_gibbs.cu src/gmm.h
	$(CC) -c $(CFLAGS) $< -o obj/$@.o -dc

cont_pdf_test: test/cont_pdf_test.cu
	$(CC) $(CFLAGS) obj/* $^ -o bin/$@
	./bin/$@

cont_gof_test: test/cont_gof_test.cu
	$(CC) $(CFLAGS) obj/* $^ -o bin/$@
	./bin/$@

int_test: test/int_test.cu
	$(CC) $(CFLAGS) obj/* $^ -o bin/$@
	./bin/$@

clean:
	rm -rf bin
	rm -rf obj

test:
	cd bin && ./cont_gof_test && ./int_test && ./cont_pdf_test
