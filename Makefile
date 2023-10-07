GRUB_THEMES=kaisen-theme/grub\
	lightdm/grub \
	sddm/grub \
	additionnal1/grub \
	additionnal2/grub \
	cassis/grub \
DEFAULT_BACKGROUND=desktop-background

PIXMAPS=$(wildcard pixmaps/*.[ps][vn]g)
DESKTOPFILES=$(wildcard *.desktop)

.PHONY: all clean install install-local
all: build-emblems build-logos
clean: clean-emblems clean-logos

.PHONY: install-grub
install-grub:
	@target=`echo $@ | sed s/-grub//`; \
	for grub_theme in $(GRUB_THEMES) ; do \
		if [ -f $$grub_theme/Makefile ] ; then \
			$(MAKE) $$target -C $$grub_theme || exit 1; \
		fi \
	done

.PHONY: build-emblems clean-emblems install-emblems
build-emblems clean-emblems install-emblems:
	@target=`echo $@ | sed s/-emblems//`; \
	$(MAKE) $$target -C emblems-kaisen || exit 1;

.PHONY: build-logos clean-logos install-logos
build-logos clean-logos install-logos:
	@target=`echo $@ | sed s/-logos//`; \
	$(MAKE) $$target -C kaisen-logos || exit 1;

install: install-grub install-emblems install-logos install-local

install-local:
	#plymouth configurations
	mkdir -p $(DESTDIR)/usr/share/plymouth/
	$(INSTALL_DATA) plymouth-confs/plymouthd.defaults $(DESTDIR)/usr/share/plymouth
	mkdir -p $(DESTDIR)/etc/plymouth
	$(INSTALL_DATA) plymouth-confs/plymouthd.conf $(DESTDIR)/etc/plymouth

	# background files
	mkdir -p $(DESTDIR)/usr/share/images/desktop-base
	cd $(DESTDIR)/usr/share/images/desktop-base && ln -s $(DEFAULT_BACKGROUND) default
	# desktop files
	mkdir -p $(DESTDIR)/usr/share/desktop-base
	$(INSTALL_DATA) $(DESKTOPFILES) $(DESTDIR)/usr/share/desktop-base/
	# pixmaps files
	mkdir -p $(DESTDIR)/usr/share/pixmaps/kaisen-logos
	$(INSTALL_DATA) $(PIXMAPS) $(DESTDIR)/usr/share/pixmaps/kaisen-logos

	# Create a 'kaisen-theme' symlink in plymouth themes folder, pointing at the
	# plymouth theme for the currently active 'desktop-theme' alternative.
	mkdir -p $(DESTDIR)/usr/share/plymouth/themes
	ln -s ../../desktop-base/active-theme/plymouth $(DESTDIR)/usr/share/plymouth/themes/kaisen-theme

	# Set Plasma 5/KDE default wallpaper
	install -d $(DESTDIR)/usr/share/plasma/shells/org.kde.plasma.desktop/contents/updates
	$(INSTALL_DATA) defaults/plasma5/desktop-base.js $(DESTDIR)/usr/share/plasma/shells/org.kde.plasma.desktop/contents/updates/

	# Xfce 4.6
	mkdir -p $(DESTDIR)/usr/share/desktop-base/profiles/xdg-config/xfce4/xfconf/xfce-perchannel-xml
	$(INSTALL_DATA) $(wildcard profiles/xdg-config/xfce4/xfconf/xfce-perchannel-xml/*) $(DESTDIR)/usr/share/desktop-base/profiles/xdg-config/xfce4/xfconf/xfce-perchannel-xml

	# GNOME background descriptors
	mkdir -p $(DESTDIR)/usr/share/gnome-background-properties

	# kaisen theme (Kaisen Linux default)
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/kaisen
	$(INSTALL_DATA) $(wildcard kaisen-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/kaisen
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-theme
	cd $(DESTDIR)/usr/share/desktop-base/kaisen-theme && ln -s /usr/share/plymouth/themes/kaisen plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-theme/login
	$(INSTALL_DATA) $(wildcard kaisen-theme/login/*) $(DESTDIR)/usr/share/desktop-base/kaisen-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-theme/wallpaper/contents/images
	$(INSTALL_DATA) kaisen-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-theme/wallpaper
	$(INSTALL_DATA) kaisen-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-theme/wallpaper
	$(INSTALL_DATA) $(wildcard kaisen-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-theme/wallpaper/contents/images/
	$(INSTALL_DATA) kaisen-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/kaisen.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-theme/wallpaper kaisen

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-theme/lockscreen/contents/images
	$(INSTALL_DATA) kaisen-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-theme/lockscreen
	$(INSTALL_DATA) kaisen-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-theme/lockscreen
	$(INSTALL_DATA) $(wildcard kaisen-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-theme/lockscreen/contents/images/

	# lightdm theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/kaisen-lightdm
	$(INSTALL_DATA) $(wildcard kaisen-lightdm-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/kaisen-lightdm
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-theme
	cd $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-theme && ln -s /usr/share/plymouth/themes/kaisen-lightdm plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-theme/login
	$(INSTALL_DATA) $(wildcard kaisen-lightdm-theme/login/*) $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-theme/wallpaper/contents/images
	$(INSTALL_DATA) kaisen-lightdm-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-theme/wallpaper
	$(INSTALL_DATA) kaisen-lightdm-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-theme/wallpaper
	$(INSTALL_DATA) $(wildcard kaisen-lightdm-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-theme/wallpaper/contents/images/
	$(INSTALL_DATA) kaisen-lightdm-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/kaisen-lightdm.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-lightdm-theme/wallpaper kaisen-lightdm

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-theme/lockscreen/contents/images
	$(INSTALL_DATA) kaisen-lightdm-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-theme/lockscreen
	$(INSTALL_DATA) kaisen-lightdm-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-theme/lockscreen
	$(INSTALL_DATA) $(wildcard kaisen-lightdm-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-theme/lockscreen/contents/images/

	# sddm theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/kaisen-sddm
	$(INSTALL_DATA) $(wildcard kaisen-sddm-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/kaisen-sddm
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-sddm-theme
	cd $(DESTDIR)/usr/share/desktop-base/kaisen-sddm-theme && ln -s /usr/share/plymouth/themes/kaisen-sddm plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-sddm-theme/login
	$(INSTALL_DATA) $(wildcard kaisen-sddm-theme/login/*) $(DESTDIR)/usr/share/desktop-base/kaisen-sddm-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-sddm-theme/wallpaper/contents/images
	$(INSTALL_DATA) kaisen-sddm-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-sddm-theme/wallpaper
	$(INSTALL_DATA) kaisen-sddm-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-sddm-theme/wallpaper
	$(INSTALL_DATA) $(wildcard kaisen-sddm-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-sddm-theme/wallpaper/contents/images/
	$(INSTALL_DATA) kaisen-sddm-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/kaisen-sddm.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-sddm-theme/wallpaper kaisen-sddm

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-sddm-theme/lockscreen/contents/images
	$(INSTALL_DATA) kaisen-sddm-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-sddm-theme/lockscreen
	$(INSTALL_DATA) kaisen-sddm-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-sddm-theme/lockscreen
	$(INSTALL_DATA) $(wildcard kaisen-sddm-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-sddm-theme/lockscreen/contents/images/

	# additionnal1 theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/kaisen-additionnal1
	$(INSTALL_DATA) $(wildcard kaisen-additionnal1-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/kaisen-additionnal1
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal1-theme
	cd $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal1-theme && ln -s /usr/share/plymouth/themes/kaisen-additionnal1 plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal1-theme/login
	$(INSTALL_DATA) $(wildcard kaisen-additionnal1-theme/login/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal1-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal1-theme/wallpaper/contents/images
	$(INSTALL_DATA) kaisen-additionnal1-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal1-theme/wallpaper
	$(INSTALL_DATA) kaisen-additionnal1-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal1-theme/wallpaper
	$(INSTALL_DATA) $(wildcard kaisen-additionnal1-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal1-theme/wallpaper/contents/images/
	$(INSTALL_DATA) kaisen-additionnal1-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/kaisen-additionnal1.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-additionnal1-theme/wallpaper kaisen-additionnal1

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal1-theme/lockscreen/contents/images
	$(INSTALL_DATA) kaisen-additionnal1-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal1-theme/lockscreen
	$(INSTALL_DATA) kaisen-additionnal1-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal1-theme/lockscreen
	$(INSTALL_DATA) $(wildcard kaisen-additionnal1-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal1-theme/lockscreen/contents/images/

	# additionnal2 theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/kaisen-additionnal2
	$(INSTALL_DATA) $(wildcard kaisen-additionnal2-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/kaisen-additionnal2
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal2-theme
	cd $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal2-theme && ln -s /usr/share/plymouth/themes/kaisen-additionnal2 plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal2-theme/login
	$(INSTALL_DATA) $(wildcard kaisen-additionnal2-theme/login/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal2-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal2-theme/wallpaper/contents/images
	$(INSTALL_DATA) kaisen-additionnal2-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal2-theme/wallpaper
	$(INSTALL_DATA) kaisen-additionnal2-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal2-theme/wallpaper
	$(INSTALL_DATA) $(wildcard kaisen-additionnal2-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal2-theme/wallpaper/contents/images/
	$(INSTALL_DATA) kaisen-additionnal2-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/kaisen-additionnal2.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-additionnal2-theme/wallpaper kaisen-additionnal2

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal2-theme/lockscreen/contents/images
	$(INSTALL_DATA) kaisen-additionnal2-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal2-theme/lockscreen
	$(INSTALL_DATA) kaisen-additionnal2-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal2-theme/lockscreen
	$(INSTALL_DATA) $(wildcard kaisen-additionnal2-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additionnal2-theme/lockscreen/contents/images/

	# cassis theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/kaisen-cassis
	$(INSTALL_DATA) $(wildcard kaisen-cassis-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/kaisen-cassis
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-cassis-theme
	cd $(DESTDIR)/usr/share/desktop-base/kaisen-cassis-theme && ln -s /usr/share/plymouth/themes/kaisen-cassis plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-cassis-theme/login
	$(INSTALL_DATA) $(wildcard kaisen-cassis-theme/login/*) $(DESTDIR)/usr/share/desktop-base/kaisen-cassis-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-cassis-theme/wallpaper/contents/images
	$(INSTALL_DATA) kaisen-cassis-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-cassis-theme/wallpaper
	$(INSTALL_DATA) kaisen-cassis-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-cassis-theme/wallpaper
	$(INSTALL_DATA) $(wildcard kaisen-cassis-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-cassis-theme/wallpaper/contents/images/
	$(INSTALL_DATA) kaisen-cassis-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/kaisen-cassis.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-cassis-theme/wallpaper kaisen-cassis

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-cassis-theme/lockscreen/contents/images
	$(INSTALL_DATA) kaisen-cassis-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-cassis-theme/lockscreen
	$(INSTALL_DATA) kaisen-cassis-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-cassis-theme/lockscreen
	$(INSTALL_DATA) $(wildcard kaisen-cassis-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-cassis-theme/lockscreen/contents/images/

include Makefile.inc
