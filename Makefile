prefix ?= /usr/local

test:
	./bang test

install: install-bang install-doc

dist: build-bang build-docs

install-bang: clean build-bang
	-mkdir -p $(prefix)/bin
	cp dist/bang $(prefix)/bin/bang

install-doc: build-docs
	-mkdir -p $(prefix)/doc/bangsh
	cp CONTRIBUTING.md $(prefix)/doc/bangsh/
	cp README.md $(prefix)/doc/bangsh/
	cp -r samples/ $(prefix)/doc/bangsh/examples
	-mkdir -p $(prefix)/man
	cp dist/docs/bang.1.gz $(prefix)/man/
	cp dist/docs/bang-new.1.gz $(prefix)/man/
	cp dist/docs/bang-run.1.gz $(prefix)/man/
	cp dist/docs/bang-test.1.gz $(prefix)/man/

build-bang: clean
	mkdir dist/
	echo "#!/usr/bin/env bash" > dist/bang
	cat LICENSE | sed 's/^/# /' >> dist/bang
	cat "boot.sh" >> dist/bang
	cat modules/* tasks/* >> dist/bang
	echo 'b._run "$$@"' >> dist/bang
	chmod +x dist/bang

build-docs:
	mkdir -p dist/docs
	# Add contributors to the manpages
	echo "CONTRIBUTORS" > dist/contributors
	git log --format='  %an <%ae>' | sort -u | sed '/Gustavo Dutra/d ; s/$$/,/ ; $$s/,//' >> dist/contributors
	# Generate the manpages
	cat docs/bang dist/contributors | txt2man -t bang > dist/docs/bang.1
	cat docs/bang-new dist/contributors | txt2man -t bang-new > dist/docs/bang-new.1
	cat docs/bang-run dist/contributors | txt2man -t bang-run > dist/docs/bang-run.1
	cat docs/bang-test dist/contributors | txt2man -t bang-test > dist/docs/bang-test.1
	gzip dist/docs/bang.1 dist/docs/bang-new.1 dist/docs/bang-run.1 dist/docs/bang-test.1

clean:
	@-rm -rf dist/
