AUTOMAKEVERSION ?= $(shell automake --version | sed -n '1{s/.* //;p}' | grep -oE '[0-9]+\.[0-9]+')

all: install

install: buildtools

buildtools: linux-buildtools

linux-buildtools:
	./install_linux-buildtools
