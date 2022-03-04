GRUB_THEMES=kaisen-theme/grub\
	block-black-dragon/grub \
	line-red/grub \
	block-white-dragon/grub \
	line-white/grub \
	picto-red/grub \
	dna-center/grub \
	picto-white/grub \
	tobas-theme/grub \
	dna-left/grub \
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

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) kaisen-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-theme/wallpaper-withlogo
	$(INSTALL_DATA) kaisen-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard kaisen-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-theme/wallpaper-withlogo kaisenWithLogo

	# block-black-dragon theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/block-black-dragon
	$(INSTALL_DATA) $(wildcard block-black-dragon-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/block-black-dragon
	install -d $(DESTDIR)/usr/share/desktop-base/block-black-dragon-theme
	cd $(DESTDIR)/usr/share/desktop-base/block-black-dragon-theme && ln -s /usr/share/plymouth/themes/block-black-dragon plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/block-black-dragon-theme/login
	$(INSTALL_DATA) $(wildcard block-black-dragon-theme/login/*) $(DESTDIR)/usr/share/desktop-base/block-black-dragon-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/block-black-dragon-theme/wallpaper/contents/images
	$(INSTALL_DATA) block-black-dragon-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/block-black-dragon-theme/wallpaper
	$(INSTALL_DATA) block-black-dragon-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/block-black-dragon-theme/wallpaper
	$(INSTALL_DATA) $(wildcard block-black-dragon-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/block-black-dragon-theme/wallpaper/contents/images/
	$(INSTALL_DATA) block-black-dragon-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/block-black-dragon.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/block-black-dragon-theme/wallpaper block-black-dragon

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/block-black-dragon-theme/lockscreen/contents/images
	$(INSTALL_DATA) block-black-dragon-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/block-black-dragon-theme/lockscreen
	$(INSTALL_DATA) block-black-dragon-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/block-black-dragon-theme/lockscreen
	$(INSTALL_DATA) $(wildcard block-black-dragon-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/block-black-dragon-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/block-black-dragon-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) block-black-dragon-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/block-black-dragon-theme/wallpaper-withlogo
	$(INSTALL_DATA) block-black-dragon-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/block-black-dragon-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard block-black-dragon-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/block-black-dragon-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/block-black-dragon-theme/wallpaper-withlogo block-black-dragonWithLogo

	# block-white-dragon theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/block-white-dragon
	$(INSTALL_DATA) $(wildcard block-white-dragon-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/block-white-dragon
	install -d $(DESTDIR)/usr/share/desktop-base/block-white-dragon-theme
	cd $(DESTDIR)/usr/share/desktop-base/block-white-dragon-theme && ln -s /usr/share/plymouth/themes/block-white-dragon plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/block-white-dragon-theme/login
	$(INSTALL_DATA) $(wildcard block-white-dragon-theme/login/*) $(DESTDIR)/usr/share/desktop-base/block-white-dragon-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/block-white-dragon-theme/wallpaper/contents/images
	$(INSTALL_DATA) block-white-dragon-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/block-white-dragon-theme/wallpaper
	$(INSTALL_DATA) block-white-dragon-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/block-white-dragon-theme/wallpaper
	$(INSTALL_DATA) $(wildcard block-white-dragon-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/block-white-dragon-theme/wallpaper/contents/images/
	$(INSTALL_DATA) block-white-dragon-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/block-white-dragon.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/block-white-dragon-theme/wallpaper block-white-dragon

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/block-white-dragon-theme/lockscreen/contents/images
	$(INSTALL_DATA) block-white-dragon-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/block-white-dragon-theme/lockscreen
	$(INSTALL_DATA) block-white-dragon-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/block-white-dragon-theme/lockscreen
	$(INSTALL_DATA) $(wildcard block-white-dragon-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/block-white-dragon-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/block-white-dragon-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) block-white-dragon-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/block-white-dragon-theme/wallpaper-withlogo
	$(INSTALL_DATA) block-white-dragon-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/block-white-dragon-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard block-white-dragon-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/block-white-dragon-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/block-white-dragon-theme/wallpaper-withlogo block-white-dragonWithLogo

	# line-red theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/line-red
	$(INSTALL_DATA) $(wildcard line-red-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/line-red
	install -d $(DESTDIR)/usr/share/desktop-base/line-red-theme
	cd $(DESTDIR)/usr/share/desktop-base/line-red-theme && ln -s /usr/share/plymouth/themes/line-red plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/line-red-theme/login
	$(INSTALL_DATA) $(wildcard line-red-theme/login/*) $(DESTDIR)/usr/share/desktop-base/line-red-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/line-red-theme/wallpaper/contents/images
	$(INSTALL_DATA) line-red-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/line-red-theme/wallpaper
	$(INSTALL_DATA) line-red-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/line-red-theme/wallpaper
	$(INSTALL_DATA) $(wildcard line-red-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/line-red-theme/wallpaper/contents/images/
	$(INSTALL_DATA) line-red-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/line-red.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/line-red-theme/wallpaper line-red

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/line-red-theme/lockscreen/contents/images
	$(INSTALL_DATA) line-red-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/line-red-theme/lockscreen
	$(INSTALL_DATA) line-red-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/line-red-theme/lockscreen
	$(INSTALL_DATA) $(wildcard line-red-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/line-red-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/line-red-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) line-red-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/line-red-theme/wallpaper-withlogo
	$(INSTALL_DATA) line-red-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/line-red-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard line-red-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/line-red-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/line-red-theme/wallpaper-withlogo line-redWithLogo

	# line-white theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/line-white
	$(INSTALL_DATA) $(wildcard line-white-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/line-white
	install -d $(DESTDIR)/usr/share/desktop-base/line-white-theme
	cd $(DESTDIR)/usr/share/desktop-base/line-white-theme && ln -s /usr/share/plymouth/themes/line-white plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/line-white-theme/login
	$(INSTALL_DATA) $(wildcard line-white-theme/login/*) $(DESTDIR)/usr/share/desktop-base/line-white-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/line-white-theme/wallpaper/contents/images
	$(INSTALL_DATA) line-white-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/line-white-theme/wallpaper
	$(INSTALL_DATA) line-white-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/line-white-theme/wallpaper
	$(INSTALL_DATA) $(wildcard line-white-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/line-white-theme/wallpaper/contents/images/
	$(INSTALL_DATA) line-white-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/line-white.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/line-white-theme/wallpaper line-white

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/line-white-theme/lockscreen/contents/images
	$(INSTALL_DATA) line-white-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/line-white-theme/lockscreen
	$(INSTALL_DATA) line-white-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/line-white-theme/lockscreen
	$(INSTALL_DATA) $(wildcard line-white-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/line-white-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/line-white-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) line-white-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/line-white-theme/wallpaper-withlogo
	$(INSTALL_DATA) line-white-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/line-white-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard line-white-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/line-white-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/line-white-theme/wallpaper-withlogo line-whiteWithLogo

	# tobas theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/tobas
	$(INSTALL_DATA) $(wildcard tobas-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/tobas
	install -d $(DESTDIR)/usr/share/desktop-base/tobas-theme
	cd $(DESTDIR)/usr/share/desktop-base/tobas-theme && ln -s /usr/share/plymouth/themes/tobas plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/tobas-theme/login
	$(INSTALL_DATA) $(wildcard tobas-theme/login/*) $(DESTDIR)/usr/share/desktop-base/tobas-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/tobas-theme/wallpaper/contents/images
	$(INSTALL_DATA) tobas-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/tobas-theme/wallpaper
	$(INSTALL_DATA) tobas-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/tobas-theme/wallpaper
	$(INSTALL_DATA) $(wildcard tobas-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/tobas-theme/wallpaper/contents/images/
	$(INSTALL_DATA) tobas-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/tobas.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/tobas-theme/wallpaper tobas

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/tobas-theme/lockscreen/contents/images
	$(INSTALL_DATA) tobas-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/tobas-theme/lockscreen
	$(INSTALL_DATA) tobas-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/tobas-theme/lockscreen
	$(INSTALL_DATA) $(wildcard tobas-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/tobas-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/tobas-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) tobas-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/tobas-theme/wallpaper-withlogo
	$(INSTALL_DATA) tobas-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/tobas-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard tobas-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/tobas-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/tobas-theme/wallpaper-withlogo tobasWithLogo

	# picto-red theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/picto-red
	$(INSTALL_DATA) $(wildcard picto-red-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/picto-red
	install -d $(DESTDIR)/usr/share/desktop-base/picto-red-theme
	cd $(DESTDIR)/usr/share/desktop-base/picto-red-theme && ln -s /usr/share/plymouth/themes/picto-red plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/picto-red-theme/login
	$(INSTALL_DATA) $(wildcard picto-red-theme/login/*) $(DESTDIR)/usr/share/desktop-base/picto-red-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/picto-red-theme/wallpaper/contents/images
	$(INSTALL_DATA) picto-red-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/picto-red-theme/wallpaper
	$(INSTALL_DATA) picto-red-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/picto-red-theme/wallpaper
	$(INSTALL_DATA) $(wildcard picto-red-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/picto-red-theme/wallpaper/contents/images/
	$(INSTALL_DATA) picto-red-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/picto-red.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/picto-red-theme/wallpaper picto-red

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/picto-red-theme/lockscreen/contents/images
	$(INSTALL_DATA) picto-red-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/picto-red-theme/lockscreen
	$(INSTALL_DATA) picto-red-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/picto-red-theme/lockscreen
	$(INSTALL_DATA) $(wildcard picto-red-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/picto-red-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/picto-red-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) picto-red-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/picto-red-theme/wallpaper-withlogo
	$(INSTALL_DATA) picto-red-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/picto-red-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard picto-red-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/picto-red-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/picto-red-theme/wallpaper-withlogo picto-redWithLogo

	# picto-white theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/picto-white
	$(INSTALL_DATA) $(wildcard picto-white-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/picto-white
	install -d $(DESTDIR)/usr/share/desktop-base/picto-white-theme
	cd $(DESTDIR)/usr/share/desktop-base/picto-white-theme && ln -s /usr/share/plymouth/themes/picto-white plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/picto-white-theme/login
	$(INSTALL_DATA) $(wildcard picto-white-theme/login/*) $(DESTDIR)/usr/share/desktop-base/picto-white-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/picto-white-theme/wallpaper/contents/images
	$(INSTALL_DATA) picto-white-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/picto-white-theme/wallpaper
	$(INSTALL_DATA) picto-white-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/picto-white-theme/wallpaper
	$(INSTALL_DATA) $(wildcard picto-white-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/picto-white-theme/wallpaper/contents/images/
	$(INSTALL_DATA) picto-white-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/picto-white.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/picto-white-theme/wallpaper picto-white

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/picto-white-theme/lockscreen/contents/images
	$(INSTALL_DATA) picto-white-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/picto-white-theme/lockscreen
	$(INSTALL_DATA) picto-white-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/picto-white-theme/lockscreen
	$(INSTALL_DATA) $(wildcard picto-white-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/picto-white-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/picto-white-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) picto-white-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/picto-white-theme/wallpaper-withlogo
	$(INSTALL_DATA) picto-white-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/picto-white-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard picto-white-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/picto-white-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/picto-white-theme/wallpaper-withlogo picto-whiteWithLogo

	# dna-center theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/dna-center
	$(INSTALL_DATA) $(wildcard dna-center-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/dna-center
	install -d $(DESTDIR)/usr/share/desktop-base/dna-center-theme
	cd $(DESTDIR)/usr/share/desktop-base/dna-center-theme && ln -s /usr/share/plymouth/themes/dna-center plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/dna-center-theme/login
	$(INSTALL_DATA) $(wildcard dna-center-theme/login/*) $(DESTDIR)/usr/share/desktop-base/dna-center-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/dna-center-theme/wallpaper/contents/images
	$(INSTALL_DATA) dna-center-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/dna-center-theme/wallpaper
	$(INSTALL_DATA) dna-center-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/dna-center-theme/wallpaper
	$(INSTALL_DATA) $(wildcard dna-center-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/dna-center-theme/wallpaper/contents/images/
	$(INSTALL_DATA) dna-center-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/dna-center.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/dna-center-theme/wallpaper dna-center

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/dna-center-theme/lockscreen/contents/images
	$(INSTALL_DATA) dna-center-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/dna-center-theme/lockscreen
	$(INSTALL_DATA) dna-center-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/dna-center-theme/lockscreen
	$(INSTALL_DATA) $(wildcard dna-center-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/dna-center-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/dna-center-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) dna-center-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/dna-center-theme/wallpaper-withlogo
	$(INSTALL_DATA) dna-center-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/dna-center-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard dna-center-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/dna-center-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/dna-center-theme/wallpaper-withlogo dna-centerWithLogo

	# dna-left theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/dna-left
	$(INSTALL_DATA) $(wildcard dna-left-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/dna-left
	install -d $(DESTDIR)/usr/share/desktop-base/dna-left-theme
	cd $(DESTDIR)/usr/share/desktop-base/dna-left-theme && ln -s /usr/share/plymouth/themes/dna-left plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/dna-left-theme/login
	$(INSTALL_DATA) $(wildcard dna-left-theme/login/*) $(DESTDIR)/usr/share/desktop-base/dna-left-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/dna-left-theme/wallpaper/contents/images
	$(INSTALL_DATA) dna-left-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/dna-left-theme/wallpaper
	$(INSTALL_DATA) dna-left-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/dna-left-theme/wallpaper
	$(INSTALL_DATA) $(wildcard dna-left-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/dna-left-theme/wallpaper/contents/images/
	$(INSTALL_DATA) dna-left-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/dna-left.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/dna-left-theme/wallpaper dna-left

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/dna-left-theme/lockscreen/contents/images
	$(INSTALL_DATA) dna-left-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/dna-left-theme/lockscreen
	$(INSTALL_DATA) dna-left-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/dna-left-theme/lockscreen
	$(INSTALL_DATA) $(wildcard dna-left-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/dna-left-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/dna-left-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) dna-left-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/dna-left-theme/wallpaper-withlogo
	$(INSTALL_DATA) dna-left-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/dna-left-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard dna-left-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/dna-left-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/dna-left-theme/wallpaper-withlogo dna-leftWithLogo

include Makefile.inc
