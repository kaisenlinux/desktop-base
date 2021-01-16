dir = usr/share/desktop-base/block-black-dragon-theme/grub

.PHONY: install

files = \
	grub-4x3.png \
	grub-16x9.png

install:
	install -d $(DESTDIR)/$(dir)
	$(INSTALL_DATA) $(wildcard *.png *.sh) $(DESTDIR)/$(dir)

include ../../Makefile.inc
