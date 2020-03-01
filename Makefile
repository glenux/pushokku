
all: build

build:
	crystal src/pushokku.cr -o pushokku

test:

run:
	crystal run src/pushokku.cr

