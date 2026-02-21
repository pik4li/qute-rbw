all: ./install.sh ./bin/
	./install.sh

skip: ./install.sh
	./install.sh -s
