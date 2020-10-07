all: install test


install:
	python3 setup.py build_ext --inplace

test:
	python3 test.py

clean:
	rm -r build/
	rm search_myers_IUPAC.c
	rm search_myers_IUPAC*.so
