
LDFLAGS=
DESTDIR=/usr

BUILDDIR=_build

all: build

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

build: clean $(BUILDDIR)
	crystal build $(LDFLAGS) src/pushokku.cr -o $(BUILDDIR)/pushokku

build-release: LDFLAGS=--release --no-debug
build-release: build

install:
	install -m 0755 -o root -g root \
		$(BUILDDIR)/pushokku \
		$(DESTDIR)/bin/pushokku
test:

run:
	crystal run src/pushokku.cr

clean:
	rm -f $(BUILDDIR)/pushokku
