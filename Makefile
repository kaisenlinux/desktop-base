GRUB_THEMES=futureprototype-theme/grub\
	moonlight-theme/grub\
	softwaves-theme/grub\
	lines-theme/grub\
	joy-theme/grub\
	spacefun-theme/grub\
	blackdragon-theme/grub\
	dragondown-theme/grub\
	dragonmiror-theme/grub\
	dragonup-theme/grub\
	kaisen-theme/grub\
	logocenter-theme/grub \
	logoright-theme/grub \
	debian10-theme/grub \
	kaisen-block-black-dragon/grub \
	kaisen-block-white-dragon/grub \
	kaisen-line-red/grub \
	kaisen-line-white/grub \
	kaisen-picto-red/grub \
	kaisen-picto-white/grub \
	tobas-theme/grub \
DEFAULT_BACKGROUND=desktop-background

PIXMAPS=$(wildcard pixmaps/*.png)
DESKTOPFILES=$(wildcard *.desktop)

.PHONY: all clean install install-local
all: build-grub build-emblems build-logos
clean: clean-grub clean-emblems clean-logos

.PHONY: build-grub clean-grub install-grub
build-grub clean-grub install-grub:
	@target=`echo $@ | sed s/-grub//`; \
	for grub_theme in $(GRUB_THEMES) ; do \
		if [ -f $$grub_theme/Makefile ] ; then \
			$(MAKE) $$target -C $$grub_theme || exit 1; \
		fi \
	done

.PHONY: build-emblems clean-emblems install-emblems
build-emblems clean-emblems install-emblems:
	@target=`echo $@ | sed s/-emblems//`; \
	$(MAKE) $$target -C emblems-debian || exit 1;

.PHONY: build-logos clean-logos install-logos
build-logos clean-logos install-logos:
	@target=`echo $@ | sed s/-logos//`; \
	$(MAKE) $$target -C debian-logos || exit 1;


install: install-grub install-emblems install-logos install-local

install-local:
	# background files
	mkdir -p $(DESTDIR)/usr/share/images/desktop-base
	cd $(DESTDIR)/usr/share/images/desktop-base && ln -s $(DEFAULT_BACKGROUND) default
	# desktop files
	mkdir -p $(DESTDIR)/usr/share/desktop-base
	$(INSTALL_DATA) $(DESKTOPFILES) $(DESTDIR)/usr/share/desktop-base/
	# pixmaps files
	mkdir -p $(DESTDIR)/usr/share/pixmaps
	$(INSTALL_DATA) $(PIXMAPS) $(DESTDIR)/usr/share/pixmaps/

	# Create a 'debian-theme' symlink in plymouth themes folder, pointing at the
	# plymouth theme for the currently active 'desktop-theme' alternative.
	mkdir -p $(DESTDIR)/usr/share/plymouth/themes
	ln -s ../../desktop-base/active-theme/plymouth $(DESTDIR)/usr/share/plymouth/themes/debian-theme

	# Set Plasma 5/KDE default wallpaper
	install -d $(DESTDIR)/usr/share/plasma/shells/org.kde.plasma.desktop/contents/updates
	$(INSTALL_DATA) defaults/plasma5/desktop-base.js $(DESTDIR)/usr/share/plasma/shells/org.kde.plasma.desktop/contents/updates/

	# Xfce 4.6
	mkdir -p $(DESTDIR)/usr/share/desktop-base/profiles/xdg-config/xfce4/xfconf/xfce-perchannel-xml
	$(INSTALL_DATA) $(wildcard profiles/xdg-config/xfce4/xfconf/xfce-perchannel-xml/*) $(DESTDIR)/usr/share/desktop-base/profiles/xdg-config/xfce4/xfconf/xfce-perchannel-xml

	# GNOME background descriptors
	mkdir -p $(DESTDIR)/usr/share/gnome-background-properties


	# Space Fun theme (Squeeze’s default)
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/spacefun
	$(INSTALL_DATA) $(wildcard spacefun-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/spacefun
	install -d $(DESTDIR)/usr/share/desktop-base/spacefun-theme
	cd $(DESTDIR)/usr/share/desktop-base/spacefun-theme && ln -s /usr/share/plymouth/themes/spacefun plymouth
	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/spacefun-theme/login
	$(INSTALL_DATA) $(wildcard spacefun-theme/login/*) $(DESTDIR)/usr/share/desktop-base/spacefun-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/spacefun-theme/wallpaper/contents/images
	$(INSTALL_DATA) spacefun-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/spacefun-theme/wallpaper
	$(INSTALL_DATA) spacefun-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/spacefun-theme/wallpaper
	$(INSTALL_DATA) $(wildcard spacefun-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/spacefun-theme/wallpaper/contents/images/
	$(INSTALL_DATA) spacefun-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/debian-spacefun.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/spacefun-theme/wallpaper SpaceFun

	### Lockscreen (same as wallpaper)
	cd $(DESTDIR)/usr/share/desktop-base/spacefun-theme && ln -s wallpaper lockscreen


	# Joy theme (Wheezy’s default)
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/joy
	$(INSTALL_DATA) $(wildcard joy-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/joy
	install -d $(DESTDIR)/usr/share/desktop-base/joy-theme
	cd $(DESTDIR)/usr/share/desktop-base/joy-theme && ln -s /usr/share/plymouth/themes/joy plymouth
	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/joy-theme/login
	$(INSTALL_DATA) $(wildcard joy-theme/login/*) $(DESTDIR)/usr/share/desktop-base/joy-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/joy-theme/wallpaper/contents/images
	$(INSTALL_DATA) joy-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/joy-theme/wallpaper
	$(INSTALL_DATA) joy-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/joy-theme/wallpaper
	$(INSTALL_DATA) $(wildcard joy-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/joy-theme/wallpaper/contents/images/
	$(INSTALL_DATA) joy-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/debian-joy.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/joy-theme/wallpaper Joy

	### Lockscreen
	install -d $(DESTDIR)/usr/share/desktop-base/joy-theme/lockscreen/contents/images
	$(INSTALL_DATA) joy-theme/lockscreen/metadata.desktop $(DESTDIR)/usr/share/desktop-base/joy-theme/lockscreen
	$(INSTALL_DATA) joy-theme/lockscreen/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/joy-theme/lockscreen
	$(INSTALL_DATA) $(wildcard joy-theme/lockscreen/contents/images/*) $(DESTDIR)/usr/share/desktop-base/joy-theme/lockscreen/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/joy-theme/lockscreen JoyLockScreen

	# Joy Inksplat theme (Wheezy’s alternate theme)
	install -d $(DESTDIR)/usr/share/desktop-base/joy-inksplat-theme
	### Plymouth theme
	# Reuse « normal » joy theme
	cd $(DESTDIR)/usr/share/desktop-base/joy-inksplat-theme \
		&& ln -s /usr/share/plymouth/themes/joy plymouth \

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/joy-inksplat-theme/wallpaper/contents/images
	$(INSTALL_DATA) joy-inksplat-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/joy-inksplat-theme/wallpaper
	$(INSTALL_DATA) joy-inksplat-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/joy-inksplat-theme/wallpaper
	$(INSTALL_DATA) $(wildcard joy-inksplat-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/joy-inksplat-theme/wallpaper/contents/images/
	$(INSTALL_DATA) joy-inksplat-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/debian-joy-inksplat.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/joy-inksplat-theme/wallpaper JoyInksplat
	### Lockscreen (same as Joy)
	cd $(DESTDIR)/usr/share/desktop-base/joy-inksplat-theme && ln -s /usr/share/desktop-base/joy-theme/lockscreen lockscreen


	# Lines theme (Jessie’s default)
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/lines
	$(INSTALL_DATA) $(wildcard lines-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/lines
	install -d $(DESTDIR)/usr/share/desktop-base/lines-theme
	cd $(DESTDIR)/usr/share/desktop-base/lines-theme && ln -s /usr/share/plymouth/themes/lines plymouth
	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/lines-theme/login
	$(INSTALL_DATA) $(wildcard lines-theme/login/*) $(DESTDIR)/usr/share/desktop-base/lines-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/lines-theme/wallpaper/contents/images
	$(INSTALL_DATA) lines-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/lines-theme/wallpaper
	$(INSTALL_DATA) lines-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/lines-theme/wallpaper
	$(INSTALL_DATA) $(wildcard lines-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/lines-theme/wallpaper/contents/images/
	$(INSTALL_DATA) lines-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/debian-lines.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/lines-theme/wallpaper Lines

	### Lockscreen
	install -d $(DESTDIR)/usr/share/desktop-base/lines-theme/lockscreen/contents/images
	$(INSTALL_DATA) lines-theme/lockscreen/metadata.desktop $(DESTDIR)/usr/share/desktop-base/lines-theme/lockscreen
	$(INSTALL_DATA) lines-theme/lockscreen/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/lines-theme/lockscreen
	$(INSTALL_DATA) $(wildcard lines-theme/lockscreen/contents/images/*) $(DESTDIR)/usr/share/desktop-base/lines-theme/lockscreen/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/lines-theme/lockscreen LinesLockScreen


	# Soft waves theme (Stretch’s default)
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/softwaves
	$(INSTALL_DATA) $(wildcard softwaves-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/softwaves
	install -d $(DESTDIR)/usr/share/desktop-base/softwaves-theme
	cd $(DESTDIR)/usr/share/desktop-base/softwaves-theme && ln -s /usr/share/plymouth/themes/softwaves plymouth
	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/softwaves-theme/login
	$(INSTALL_DATA) $(wildcard softwaves-theme/login/*) $(DESTDIR)/usr/share/desktop-base/softwaves-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/softwaves-theme/wallpaper/contents/images
	$(INSTALL_DATA) softwaves-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/softwaves-theme/wallpaper
	$(INSTALL_DATA) softwaves-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/softwaves-theme/wallpaper
	$(INSTALL_DATA) $(wildcard softwaves-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/softwaves-theme/wallpaper/contents/images/
	$(INSTALL_DATA) softwaves-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/debian-softwaves.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/softwaves-theme/wallpaper SoftWaves

	### Lockscreen
	install -d $(DESTDIR)/usr/share/desktop-base/softwaves-theme/lockscreen/contents/images
	$(INSTALL_DATA) softwaves-theme/lockscreen/metadata.desktop $(DESTDIR)/usr/share/desktop-base/softwaves-theme/lockscreen
	$(INSTALL_DATA) softwaves-theme/lockscreen/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/softwaves-theme/lockscreen
	$(INSTALL_DATA) $(wildcard softwaves-theme/lockscreen/contents/images/*) $(DESTDIR)/usr/share/desktop-base/softwaves-theme/lockscreen/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/softwaves-theme/lockscreen SoftWavesLockScreen

	# futurePrototype theme (Buster’s default)
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/futureprototype
	$(INSTALL_DATA) $(wildcard futureprototype-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/futureprototype
	install -d $(DESTDIR)/usr/share/desktop-base/futureprototype-theme
	cd $(DESTDIR)/usr/share/desktop-base/futureprototype-theme && ln -s /usr/share/plymouth/themes/futureprototype plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/futureprototype-theme/login
	$(INSTALL_DATA) $(wildcard futureprototype-theme/login/*) $(DESTDIR)/usr/share/desktop-base/futureprototype-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/futureprototype-theme/wallpaper/contents/images
	$(INSTALL_DATA) futureprototype-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/futureprototype-theme/wallpaper
	$(INSTALL_DATA) futureprototype-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/futureprototype-theme/wallpaper
	$(INSTALL_DATA) $(wildcard futureprototype-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/futureprototype-theme/wallpaper/contents/images/
	$(INSTALL_DATA) futureprototype-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/debian-futureprototype.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/futureprototype-theme/wallpaper FuturePrototype

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/futureprototype-theme/lockscreen/contents/images
	$(INSTALL_DATA) futureprototype-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/futureprototype-theme/lockscreen
	$(INSTALL_DATA) futureprototype-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/futureprototype-theme/lockscreen
	$(INSTALL_DATA) $(wildcard futureprototype-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/futureprototype-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/futureprototype-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) futureprototype-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/futureprototype-theme/wallpaper-withlogo
	$(INSTALL_DATA) futureprototype-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/futureprototype-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard futureprototype-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/futureprototype-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/futureprototype-theme/wallpaper-withlogo FuturePrototypeWithLogo

	# Moonlight theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/moonlight
	$(INSTALL_DATA) $(wildcard moonlight-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/moonlight
	install -d $(DESTDIR)/usr/share/desktop-base/moonlight-theme
	cd $(DESTDIR)/usr/share/desktop-base/moonlight-theme && ln -s /usr/share/plymouth/themes/moonlight plymouth
	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/moonlight-theme/login
	$(INSTALL_DATA) $(wildcard moonlight-theme/login/*) $(DESTDIR)/usr/share/desktop-base/moonlight-theme/login
	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/moonlight-theme/wallpaper/contents/images
	$(INSTALL_DATA) moonlight-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/moonlight-theme/wallpaper
	$(INSTALL_DATA) moonlight-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/moonlight-theme/wallpaper
	$(INSTALL_DATA) $(wildcard moonlight-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/moonlight-theme/wallpaper/contents/images/
	$(INSTALL_DATA) moonlight-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/debian-moonlight.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/moonlight-theme/wallpaper moonlight

	### Lockscreen
	install -d $(DESTDIR)/usr/share/desktop-base/moonlight-theme/lockscreen/contents/images
	$(INSTALL_DATA) moonlight-theme/lockscreen/metadata.desktop $(DESTDIR)/usr/share/desktop-base/moonlight-theme/lockscreen
	$(INSTALL_DATA) moonlight-theme/lockscreen/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/moonlight-theme/lockscreen
	$(INSTALL_DATA) $(wildcard moonlight-theme/lockscreen/contents/images/*) $(DESTDIR)/usr/share/desktop-base/moonlight-theme/lockscreen/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/moonlight-theme/lockscreen MoonlightLockScreen

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

	# blackdragon theme (Other Kaisen Linux theme)
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/blackdragon
	$(INSTALL_DATA) $(wildcard blackdragon-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/blackdragon
	install -d $(DESTDIR)/usr/share/desktop-base/blackdragon-theme
	cd $(DESTDIR)/usr/share/desktop-base/blackdragon-theme && ln -s /usr/share/plymouth/themes/blackdragon plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/blackdragon-theme/login
	$(INSTALL_DATA) $(wildcard blackdragon-theme/login/*) $(DESTDIR)/usr/share/desktop-base/blackdragon-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/blackdragon-theme/wallpaper/contents/images
	$(INSTALL_DATA) blackdragon-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/blackdragon-theme/wallpaper
	$(INSTALL_DATA) blackdragon-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/blackdragon-theme/wallpaper
	$(INSTALL_DATA) $(wildcard blackdragon-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/blackdragon-theme/wallpaper/contents/images/
	$(INSTALL_DATA) blackdragon-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/debian-blackdragon.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/blackdragon-theme/wallpaper blackdragon

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/blackdragon-theme/lockscreen/contents/images
	$(INSTALL_DATA) blackdragon-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/blackdragon-theme/lockscreen
	$(INSTALL_DATA) blackdragon-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/blackdragon-theme/lockscreen
	$(INSTALL_DATA) $(wildcard blackdragon-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/blackdragon-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/blackdragon-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) blackdragon-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/blackdragon-theme/wallpaper-withlogo
	$(INSTALL_DATA) blackdragon-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/blackdragon-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard blackdragon-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/blackdragon-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/blackdragon-theme/wallpaper-withlogo blackdragonWithLogo

	# dragondown theme (Other Kaisen Linux theme)
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/dragondown
	$(INSTALL_DATA) $(wildcard dragondown-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/dragondown
	install -d $(DESTDIR)/usr/share/desktop-base/dragondown-theme
	cd $(DESTDIR)/usr/share/desktop-base/dragondown-theme && ln -s /usr/share/plymouth/themes/dragondown plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/dragondown-theme/login
	$(INSTALL_DATA) $(wildcard dragondown-theme/login/*) $(DESTDIR)/usr/share/desktop-base/dragondown-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/dragondown-theme/wallpaper/contents/images
	$(INSTALL_DATA) dragondown-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/dragondown-theme/wallpaper
	$(INSTALL_DATA) dragondown-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/dragondown-theme/wallpaper
	$(INSTALL_DATA) $(wildcard dragondown-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/dragondown-theme/wallpaper/contents/images/
	$(INSTALL_DATA) dragondown-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/dragondown.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/dragondown-theme/wallpaper dragondown

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/dragondown-theme/lockscreen/contents/images
	$(INSTALL_DATA) dragondown-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/dragondown-theme/lockscreen
	$(INSTALL_DATA) dragondown-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/dragondown-theme/lockscreen
	$(INSTALL_DATA) $(wildcard dragondown-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/dragondown-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/dragondown-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) dragondown-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/dragondown-theme/wallpaper-withlogo
	$(INSTALL_DATA) dragondown-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/dragondown-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard dragondown-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/dragondown-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/dragondown-theme/wallpaper-withlogo dragondownWithLogo

	# dragonmiror theme (Other Kaisen Linux theme)
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/dragonmiror
	$(INSTALL_DATA) $(wildcard dragonmiror-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/dragonmiror
	install -d $(DESTDIR)/usr/share/desktop-base/dragonmiror-theme
	cd $(DESTDIR)/usr/share/desktop-base/dragonmiror-theme && ln -s /usr/share/plymouth/themes/dragonmiror plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/dragonmiror-theme/login
	$(INSTALL_DATA) $(wildcard dragonmiror-theme/login/*) $(DESTDIR)/usr/share/desktop-base/dragonmiror-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/dragonmiror-theme/wallpaper/contents/images
	$(INSTALL_DATA) dragonmiror-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/dragonmiror-theme/wallpaper
	$(INSTALL_DATA) dragonmiror-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/dragonmiror-theme/wallpaper
	$(INSTALL_DATA) $(wildcard dragonmiror-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/dragonmiror-theme/wallpaper/contents/images/
	$(INSTALL_DATA) dragonmiror-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/dragonmiror.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/dragonmiror-theme/wallpaper dragonmiror

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/dragonmiror-theme/lockscreen/contents/images
	$(INSTALL_DATA) dragonmiror-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/dragonmiror-theme/lockscreen
	$(INSTALL_DATA) dragonmiror-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/dragonmiror-theme/lockscreen
	$(INSTALL_DATA) $(wildcard dragonmiror-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/dragonmiror-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/dragonmiror-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) dragonmiror-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/dragonmiror-theme/wallpaper-withlogo
	$(INSTALL_DATA) dragonmiror-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/dragonmiror-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard dragonmiror-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/dragonmiror-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/dragonmiror-theme/wallpaper-withlogo dragonmirorWithLogo

	# dragonup theme (Other Kaisen Linux theme)
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/dragonup
	$(INSTALL_DATA) $(wildcard dragonup-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/dragonup
	install -d $(DESTDIR)/usr/share/desktop-base/dragonup-theme
	cd $(DESTDIR)/usr/share/desktop-base/dragonup-theme && ln -s /usr/share/plymouth/themes/dragonup plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/dragonup-theme/login
	$(INSTALL_DATA) $(wildcard dragonup-theme/login/*) $(DESTDIR)/usr/share/desktop-base/dragonup-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/dragonup-theme/wallpaper/contents/images
	$(INSTALL_DATA) dragonup-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/dragonup-theme/wallpaper
	$(INSTALL_DATA) dragonup-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/dragonup-theme/wallpaper
	$(INSTALL_DATA) $(wildcard dragonup-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/dragonup-theme/wallpaper/contents/images/
	$(INSTALL_DATA) dragonup-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/dragonup.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/dragonup-theme/wallpaper dragonup

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/dragonup-theme/lockscreen/contents/images
	$(INSTALL_DATA) dragonup-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/dragonup-theme/lockscreen
	$(INSTALL_DATA) dragonup-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/dragonup-theme/lockscreen
	$(INSTALL_DATA) $(wildcard dragonup-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/dragonup-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/dragonup-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) dragonup-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/dragonup-theme/wallpaper-withlogo
	$(INSTALL_DATA) dragonup-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/dragonup-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard dragonup-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/dragonup-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/dragonup-theme/wallpaper-withlogo dragonupWithLogo

	# logocenter theme (Other Kaisen Linux theme)
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/logocenter
	$(INSTALL_DATA) $(wildcard logocenter-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/logocenter
	install -d $(DESTDIR)/usr/share/desktop-base/logocenter-theme
	cd $(DESTDIR)/usr/share/desktop-base/logocenter-theme && ln -s /usr/share/plymouth/themes/logocenter plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/logocenter-theme/login
	$(INSTALL_DATA) $(wildcard logocenter-theme/login/*) $(DESTDIR)/usr/share/desktop-base/logocenter-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/logocenter-theme/wallpaper/contents/images
	$(INSTALL_DATA) logocenter-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/logocenter-theme/wallpaper
	$(INSTALL_DATA) logocenter-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/logocenter-theme/wallpaper
	$(INSTALL_DATA) $(wildcard logocenter-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/logocenter-theme/wallpaper/contents/images/
	$(INSTALL_DATA) logocenter-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/logocenter.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/logocenter-theme/wallpaper logocenter

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/logocenter-theme/lockscreen/contents/images
	$(INSTALL_DATA) logocenter-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/logocenter-theme/lockscreen
	$(INSTALL_DATA) logocenter-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/logocenter-theme/lockscreen
	$(INSTALL_DATA) $(wildcard logocenter-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/logocenter-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/logocenter-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) logocenter-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/logocenter-theme/wallpaper-withlogo
	$(INSTALL_DATA) logocenter-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/logocenter-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard logocenter-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/logocenter-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/logocenter-theme/wallpaper-withlogo logocenterWithLogo

	# logoright theme (Other Kaisen Linux theme)
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/logoright
	$(INSTALL_DATA) $(wildcard logoright-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/logoright
	install -d $(DESTDIR)/usr/share/desktop-base/logoright-theme
	cd $(DESTDIR)/usr/share/desktop-base/logoright-theme && ln -s /usr/share/plymouth/themes/logoright plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/logoright-theme/login
	$(INSTALL_DATA) $(wildcard logoright-theme/login/*) $(DESTDIR)/usr/share/desktop-base/logoright-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/logoright-theme/wallpaper/contents/images
	$(INSTALL_DATA) logoright-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/logoright-theme/wallpaper
	$(INSTALL_DATA) logoright-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/logoright-theme/wallpaper
	$(INSTALL_DATA) $(wildcard logoright-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/logoright-theme/wallpaper/contents/images/
	$(INSTALL_DATA) logoright-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/logoright.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/logoright-theme/wallpaper logoright

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/logoright-theme/lockscreen/contents/images
	$(INSTALL_DATA) logoright-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/logoright-theme/lockscreen
	$(INSTALL_DATA) logoright-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/logoright-theme/lockscreen
	$(INSTALL_DATA) $(wildcard logoright-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/logoright-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/logoright-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) logoright-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/logoright-theme/wallpaper-withlogo
	$(INSTALL_DATA) logoright-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/logoright-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard logoright-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/logoright-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/logoright-theme/wallpaper-withlogo logorightWithLogo

	# debian10 theme (Other Kaisen Linux theme)
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/debian10
	$(INSTALL_DATA) $(wildcard debian10-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/debian10
	install -d $(DESTDIR)/usr/share/desktop-base/debian10-theme
	cd $(DESTDIR)/usr/share/desktop-base/debian10-theme && ln -s /usr/share/plymouth/themes/debian10 plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/debian10-theme/login
	$(INSTALL_DATA) $(wildcard debian10-theme/login/*) $(DESTDIR)/usr/share/desktop-base/debian10-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/debian10-theme/wallpaper/contents/images
	$(INSTALL_DATA) debian10-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/debian10-theme/wallpaper
	$(INSTALL_DATA) debian10-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/debian10-theme/wallpaper
	$(INSTALL_DATA) $(wildcard debian10-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/debian10-theme/wallpaper/contents/images/
	$(INSTALL_DATA) debian10-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/debian10.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/debian10-theme/wallpaper debian10

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/debian10-theme/lockscreen/contents/images
	$(INSTALL_DATA) debian10-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/debian10-theme/lockscreen
	$(INSTALL_DATA) debian10-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/debian10-theme/lockscreen
	$(INSTALL_DATA) $(wildcard debian10-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/debian10-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/debian10-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) debian10-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/debian10-theme/wallpaper-withlogo
	$(INSTALL_DATA) debian10-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/debian10-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard debian10-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/debian10-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/debian10-theme/wallpaper-withlogo debian10WithLogo

		# kaisen-block-black-dragon theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/kaisen-block-black-dragon
	$(INSTALL_DATA) $(wildcard kaisen-block-black-dragon-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/kaisen-block-black-dragon
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-block-black-dragon-theme
	cd $(DESTDIR)/usr/share/desktop-base/kaisen-block-black-dragon-theme && ln -s /usr/share/plymouth/themes/kaisen-block-black-dragon plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-block-black-dragon-theme/login
	$(INSTALL_DATA) $(wildcard kaisen-block-black-dragon-theme/login/*) $(DESTDIR)/usr/share/desktop-base/kaisen-block-black-dragon-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-block-black-dragon-theme/wallpaper/contents/images
	$(INSTALL_DATA) kaisen-block-black-dragon-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-block-black-dragon-theme/wallpaper
	$(INSTALL_DATA) kaisen-block-black-dragon-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-block-black-dragon-theme/wallpaper
	$(INSTALL_DATA) $(wildcard kaisen-block-black-dragon-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-block-black-dragon-theme/wallpaper/contents/images/
	$(INSTALL_DATA) kaisen-block-black-dragon-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/kaisen-block-black-dragon.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-block-black-dragon-theme/wallpaper kaisen-block-black-dragon

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-block-black-dragon-theme/lockscreen/contents/images
	$(INSTALL_DATA) kaisen-block-black-dragon-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-block-black-dragon-theme/lockscreen
	$(INSTALL_DATA) kaisen-block-black-dragon-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-block-black-dragon-theme/lockscreen
	$(INSTALL_DATA) $(wildcard kaisen-block-black-dragon-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-block-black-dragon-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-block-black-dragon-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) kaisen-block-black-dragon-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-block-black-dragon-theme/wallpaper-withlogo
	$(INSTALL_DATA) kaisen-block-black-dragon-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-block-black-dragon-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard kaisen-block-black-dragon-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-block-black-dragon-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-block-black-dragon-theme/wallpaper-withlogo kaisen-block-black-dragonWithLogo

		# kaisen-block-white-dragon theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/kaisen-block-white-dragon
	$(INSTALL_DATA) $(wildcard kaisen-block-white-dragon-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/kaisen-block-white-dragon
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-block-white-dragon-theme
	cd $(DESTDIR)/usr/share/desktop-base/kaisen-block-white-dragon-theme && ln -s /usr/share/plymouth/themes/kaisen-block-white-dragon plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-block-white-dragon-theme/login
	$(INSTALL_DATA) $(wildcard kaisen-block-white-dragon-theme/login/*) $(DESTDIR)/usr/share/desktop-base/kaisen-block-white-dragon-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-block-white-dragon-theme/wallpaper/contents/images
	$(INSTALL_DATA) kaisen-block-white-dragon-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-block-white-dragon-theme/wallpaper
	$(INSTALL_DATA) kaisen-block-white-dragon-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-block-white-dragon-theme/wallpaper
	$(INSTALL_DATA) $(wildcard kaisen-block-white-dragon-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-block-white-dragon-theme/wallpaper/contents/images/
	$(INSTALL_DATA) kaisen-block-white-dragon-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/kaisen-block-white-dragon.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-block-white-dragon-theme/wallpaper kaisen-block-white-dragon

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-block-white-dragon-theme/lockscreen/contents/images
	$(INSTALL_DATA) kaisen-block-white-dragon-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-block-white-dragon-theme/lockscreen
	$(INSTALL_DATA) kaisen-block-white-dragon-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-block-white-dragon-theme/lockscreen
	$(INSTALL_DATA) $(wildcard kaisen-block-white-dragon-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-block-white-dragon-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-block-white-dragon-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) kaisen-block-white-dragon-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-block-white-dragon-theme/wallpaper-withlogo
	$(INSTALL_DATA) kaisen-block-white-dragon-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-block-white-dragon-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard kaisen-block-white-dragon-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-block-white-dragon-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-block-white-dragon-theme/wallpaper-withlogo kaisen-block-white-dragonWithLogo

		# kaisen-line-red theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/kaisen-line-red
	$(INSTALL_DATA) $(wildcard kaisen-line-red-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/kaisen-line-red
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-line-red-theme
	cd $(DESTDIR)/usr/share/desktop-base/kaisen-line-red-theme && ln -s /usr/share/plymouth/themes/kaisen-line-red plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-line-red-theme/login
	$(INSTALL_DATA) $(wildcard kaisen-line-red-theme/login/*) $(DESTDIR)/usr/share/desktop-base/kaisen-line-red-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-line-red-theme/wallpaper/contents/images
	$(INSTALL_DATA) kaisen-line-red-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-line-red-theme/wallpaper
	$(INSTALL_DATA) kaisen-line-red-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-line-red-theme/wallpaper
	$(INSTALL_DATA) $(wildcard kaisen-line-red-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-line-red-theme/wallpaper/contents/images/
	$(INSTALL_DATA) kaisen-line-red-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/kaisen-line-red.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-line-red-theme/wallpaper kaisen-line-red

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-line-red-theme/lockscreen/contents/images
	$(INSTALL_DATA) kaisen-line-red-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-line-red-theme/lockscreen
	$(INSTALL_DATA) kaisen-line-red-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-line-red-theme/lockscreen
	$(INSTALL_DATA) $(wildcard kaisen-line-red-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-line-red-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-line-red-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) kaisen-line-red-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-line-red-theme/wallpaper-withlogo
	$(INSTALL_DATA) kaisen-line-red-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-line-red-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard kaisen-line-red-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-line-red-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-line-red-theme/wallpaper-withlogo kaisen-line-redWithLogo

		# kaisen-line-white theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/kaisen-line-white
	$(INSTALL_DATA) $(wildcard kaisen-line-white-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/kaisen-line-white
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-line-white-theme
	cd $(DESTDIR)/usr/share/desktop-base/kaisen-line-white-theme && ln -s /usr/share/plymouth/themes/kaisen-line-white plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-line-white-theme/login
	$(INSTALL_DATA) $(wildcard kaisen-line-white-theme/login/*) $(DESTDIR)/usr/share/desktop-base/kaisen-line-white-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-line-white-theme/wallpaper/contents/images
	$(INSTALL_DATA) kaisen-line-white-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-line-white-theme/wallpaper
	$(INSTALL_DATA) kaisen-line-white-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-line-white-theme/wallpaper
	$(INSTALL_DATA) $(wildcard kaisen-line-white-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-line-white-theme/wallpaper/contents/images/
	$(INSTALL_DATA) kaisen-line-white-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/kaisen-line-white.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-line-white-theme/wallpaper kaisen-line-white

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-line-white-theme/lockscreen/contents/images
	$(INSTALL_DATA) kaisen-line-white-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-line-white-theme/lockscreen
	$(INSTALL_DATA) kaisen-line-white-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-line-white-theme/lockscreen
	$(INSTALL_DATA) $(wildcard kaisen-line-white-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-line-white-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-line-white-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) kaisen-line-white-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-line-white-theme/wallpaper-withlogo
	$(INSTALL_DATA) kaisen-line-white-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-line-white-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard kaisen-line-white-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-line-white-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-line-white-theme/wallpaper-withlogo kaisen-line-whiteWithLogo

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

	# kaisen-picto-red theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/kaisen-picto-red
	$(INSTALL_DATA) $(wildcard kaisen-picto-red-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/kaisen-picto-red
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-picto-red-theme
	cd $(DESTDIR)/usr/share/desktop-base/kaisen-picto-red-theme && ln -s /usr/share/plymouth/themes/kaisen-picto-red plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-picto-red-theme/login
	$(INSTALL_DATA) $(wildcard kaisen-picto-red-theme/login/*) $(DESTDIR)/usr/share/desktop-base/kaisen-picto-red-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-picto-red-theme/wallpaper/contents/images
	$(INSTALL_DATA) kaisen-picto-red-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-picto-red-theme/wallpaper
	$(INSTALL_DATA) kaisen-picto-red-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-picto-red-theme/wallpaper
	$(INSTALL_DATA) $(wildcard kaisen-picto-red-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-picto-red-theme/wallpaper/contents/images/
	$(INSTALL_DATA) kaisen-picto-red-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/kaisen-picto-red.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-picto-red-theme/wallpaper kaisen-picto-red

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-picto-red-theme/lockscreen/contents/images
	$(INSTALL_DATA) kaisen-picto-red-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-picto-red-theme/lockscreen
	$(INSTALL_DATA) kaisen-picto-red-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-picto-red-theme/lockscreen
	$(INSTALL_DATA) $(wildcard kaisen-picto-red-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-picto-red-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-picto-red-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) kaisen-picto-red-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-picto-red-theme/wallpaper-withlogo
	$(INSTALL_DATA) kaisen-picto-red-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-picto-red-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard kaisen-picto-red-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-picto-red-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-picto-red-theme/wallpaper-withlogo kaisen-picto-redWithLogo

	# kaisen-picto-white theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/kaisen-picto-white
	$(INSTALL_DATA) $(wildcard kaisen-picto-white-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/kaisen-picto-white
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-picto-white-theme
	cd $(DESTDIR)/usr/share/desktop-base/kaisen-picto-white-theme && ln -s /usr/share/plymouth/themes/kaisen-picto-white plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-picto-white-theme/login
	$(INSTALL_DATA) $(wildcard kaisen-picto-white-theme/login/*) $(DESTDIR)/usr/share/desktop-base/kaisen-picto-white-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-picto-white-theme/wallpaper/contents/images
	$(INSTALL_DATA) kaisen-picto-white-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-picto-white-theme/wallpaper
	$(INSTALL_DATA) kaisen-picto-white-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-picto-white-theme/wallpaper
	$(INSTALL_DATA) $(wildcard kaisen-picto-white-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-picto-white-theme/wallpaper/contents/images/
	$(INSTALL_DATA) kaisen-picto-white-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/kaisen-picto-white.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-picto-white-theme/wallpaper kaisen-picto-white

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-picto-white-theme/lockscreen/contents/images
	$(INSTALL_DATA) kaisen-picto-white-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-picto-white-theme/lockscreen
	$(INSTALL_DATA) kaisen-picto-white-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-picto-white-theme/lockscreen
	$(INSTALL_DATA) $(wildcard kaisen-picto-white-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-picto-white-theme/lockscreen/contents/images/

	### Alternate wallpaper with Debian swirl
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-picto-white-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) kaisen-picto-white-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-picto-white-theme/wallpaper-withlogo
	$(INSTALL_DATA) kaisen-picto-white-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-picto-white-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard kaisen-picto-white-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-picto-white-theme/wallpaper-withlogo/contents/images/
	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-picto-white-theme/wallpaper-withlogo kaisen-picto-whiteWithLogo

include Makefile.inc