prefix ?= /usr/local

test:
	./bang test

install: clean build-bang
	-mkdir -p $(prefix)/bin
	cp dist/bang $(prefix)/bin/bang

install-doc:
	-mkdir -p $(prefix)/doc/bangsh
	cp CONTRIBUTING.md $(prefix)/doc/bangsh/
	cp README.md $(prefix)/doc/bangsh/
	cp -r samples/ $(prefix)/doc/bangsh/examples

build-bang: clean
	mkdir dist/
	echo "#!/usr/bin/env bash" > dist/bang
	cat LICENSE | sed 's/^/# /' >> dist/bang
	cat "boot.sh" >> dist/bang
	cat modules/* tasks/* >> dist/bang
	echo 'b._run "$$@"' >> dist/bang

clean:
	@-rm -r dist/
