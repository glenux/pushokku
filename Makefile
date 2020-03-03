
LDFLAGS=
#LDFLAGS=--no-debug

all: build

build:
	crystal build $(LDFLAGS) src/pushokku.cr -o pushokku

test:

run:
	crystal run src/pushokku.cr

