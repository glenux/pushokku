
SOURCES=$(wildcard **/*.cr)

LDFLAGS=
DESTDIR=/usr

BUILDDIR=_build

all: build

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

$(BUILDDIR)/pushokku: $(BUILDDIR) $(SOURCES)
	crystal build $(LDFLAGS) src/pushokku.cr -o $(BUILDDIR)/pushokku

build: $(BUILDDIR)/pushokku

build-release: LDFLAGS=--release --no-debug
build-release: build

install: build
	install -m 0755 -o root -g root \
		$(BUILDDIR)/pushokku \
		$(DESTDIR)/bin/pushokku

spec:
	crystal spec

test: spec

run:
	crystal run src/pushokku.cr

clean:
	rm -f $(BUILDDIR)/pushokku
