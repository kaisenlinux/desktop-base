GRUB_THEMES=kaisen-theme/grub\
	lightdm/grub \
	lightdm-blue/grub \
	lockscreen/grub \
	additional1/grub \
	additional2/grub \
	additional3/grub \
	additional4/grub \
	additional5/grub \
	additional6/grub \
	additional7/grub \
DEFAULT_BACKGROUND=desktop-background

PIXMAPS_AVATARS=$(wildcard pixmaps/avatars/*.[ps][vn]g)
PIXMAPS_LOGOS=$(wildcard pixmaps/logos/*.[ps][vn]g)
PIXMAPS_MENUS=$(wildcard pixmaps/menus/*.[ps][vn]g)
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
	mkdir -p $(DESTDIR)/usr/share/pixmaps/kaisen-pics/avatars
	$(INSTALL_DATA) $(PIXMAPS_AVATARS) $(DESTDIR)/usr/share/pixmaps/kaisen-pics/avatars
	mkdir -p $(DESTDIR)/usr/share/pixmaps/kaisen-pics/logos
	$(INSTALL_DATA) $(PIXMAPS_LOGOS) $(DESTDIR)/usr/share/pixmaps/kaisen-pics/logos
	mkdir -p $(DESTDIR)/usr/share/pixmaps/kaisen-pics/menus
	$(INSTALL_DATA) $(PIXMAPS_MENUS) $(DESTDIR)/usr/share/pixmaps/kaisen-pics/menus

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

	# lightdm-blue theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/kaisen-lightdm-blue
	$(INSTALL_DATA) $(wildcard kaisen-lightdm-blue-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/kaisen-lightdm-blue
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-blue-theme
	cd $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-blue-theme && ln -s /usr/share/plymouth/themes/kaisen-lightdm-blue plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-blue-theme/login
	$(INSTALL_DATA) $(wildcard kaisen-lightdm-blue-theme/login/*) $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-blue-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-blue-theme/wallpaper/contents/images
	$(INSTALL_DATA) kaisen-lightdm-blue-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-blue-theme/wallpaper
	$(INSTALL_DATA) kaisen-lightdm-blue-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-blue-theme/wallpaper
	$(INSTALL_DATA) $(wildcard kaisen-lightdm-blue-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-blue-theme/wallpaper/contents/images/
	$(INSTALL_DATA) kaisen-lightdm-blue-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/kaisen-lightdm-blue.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-lightdm-blue-theme/wallpaper kaisen-lightdm-blue

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-blue-theme/lockscreen/contents/images
	$(INSTALL_DATA) kaisen-lightdm-blue-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-blue-theme/lockscreen
	$(INSTALL_DATA) kaisen-lightdm-blue-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-blue-theme/lockscreen
	$(INSTALL_DATA) $(wildcard kaisen-lightdm-blue-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-lightdm-blue-theme/lockscreen/contents/images/

	# lockscreen theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/kaisen-lockscreen
	$(INSTALL_DATA) $(wildcard kaisen-lockscreen-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/kaisen-lockscreen
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-lockscreen-theme
	cd $(DESTDIR)/usr/share/desktop-base/kaisen-lockscreen-theme && ln -s /usr/share/plymouth/themes/kaisen-lockscreen plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-lockscreen-theme/login
	$(INSTALL_DATA) $(wildcard kaisen-lockscreen-theme/login/*) $(DESTDIR)/usr/share/desktop-base/kaisen-lockscreen-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-lockscreen-theme/wallpaper/contents/images
	$(INSTALL_DATA) kaisen-lockscreen-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-lockscreen-theme/wallpaper
	$(INSTALL_DATA) kaisen-lockscreen-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-lockscreen-theme/wallpaper
	$(INSTALL_DATA) $(wildcard kaisen-lockscreen-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-lockscreen-theme/wallpaper/contents/images/
	$(INSTALL_DATA) kaisen-lockscreen-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/kaisen-lockscreen.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-lockscreen-theme/wallpaper kaisen-lockscreen

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-lockscreen-theme/lockscreen/contents/images
	$(INSTALL_DATA) kaisen-lockscreen-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-lockscreen-theme/lockscreen
	$(INSTALL_DATA) kaisen-lockscreen-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-lockscreen-theme/lockscreen
	$(INSTALL_DATA) $(wildcard kaisen-lockscreen-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-lockscreen-theme/lockscreen/contents/images/

	# additional1 theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/kaisen-additional1
	$(INSTALL_DATA) $(wildcard kaisen-additional1-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/kaisen-additional1
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional1-theme
	cd $(DESTDIR)/usr/share/desktop-base/kaisen-additional1-theme && ln -s /usr/share/plymouth/themes/kaisen-additional1 plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional1-theme/login
	$(INSTALL_DATA) $(wildcard kaisen-additional1-theme/login/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additional1-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional1-theme/wallpaper/contents/images
	$(INSTALL_DATA) kaisen-additional1-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-additional1-theme/wallpaper
	$(INSTALL_DATA) kaisen-additional1-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-additional1-theme/wallpaper
	$(INSTALL_DATA) $(wildcard kaisen-additional1-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additional1-theme/wallpaper/contents/images/
	$(INSTALL_DATA) kaisen-additional1-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/kaisen-additional1.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-additional1-theme/wallpaper kaisen-additional1

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional1-theme/lockscreen/contents/images
	$(INSTALL_DATA) kaisen-additional1-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-additional1-theme/lockscreen
	$(INSTALL_DATA) kaisen-additional1-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-additional1-theme/lockscreen
	$(INSTALL_DATA) $(wildcard kaisen-additional1-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additional1-theme/lockscreen/contents/images/

	# additional2 theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/kaisen-additional2
	$(INSTALL_DATA) $(wildcard kaisen-additional2-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/kaisen-additional2
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional2-theme
	cd $(DESTDIR)/usr/share/desktop-base/kaisen-additional2-theme && ln -s /usr/share/plymouth/themes/kaisen-additional2 plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional2-theme/login
	$(INSTALL_DATA) $(wildcard kaisen-additional2-theme/login/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additional2-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional2-theme/wallpaper/contents/images
	$(INSTALL_DATA) kaisen-additional2-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-additional2-theme/wallpaper
	$(INSTALL_DATA) kaisen-additional2-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-additional2-theme/wallpaper
	$(INSTALL_DATA) $(wildcard kaisen-additional2-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additional2-theme/wallpaper/contents/images/
	$(INSTALL_DATA) kaisen-additional2-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/kaisen-additional2.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-additional2-theme/wallpaper kaisen-additional2

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional2-theme/lockscreen/contents/images
	$(INSTALL_DATA) kaisen-additional2-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-additional2-theme/lockscreen
	$(INSTALL_DATA) kaisen-additional2-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-additional2-theme/lockscreen
	$(INSTALL_DATA) $(wildcard kaisen-additional2-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additional2-theme/lockscreen/contents/images/

	# additional3 theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/kaisen-additional3
	$(INSTALL_DATA) $(wildcard kaisen-additional2-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/kaisen-additional3
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional3-theme
	cd $(DESTDIR)/usr/share/desktop-base/kaisen-additional3-theme && ln -s /usr/share/plymouth/themes/kaisen-additional3 plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional3-theme/login
	$(INSTALL_DATA) $(wildcard kaisen-additional3-theme/login/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additional3-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional3-theme/wallpaper/contents/images
	$(INSTALL_DATA) kaisen-additional3-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-additional3-theme/wallpaper
	$(INSTALL_DATA) kaisen-additional3-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-additional3-theme/wallpaper
	$(INSTALL_DATA) $(wildcard kaisen-additional3-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additional3-theme/wallpaper/contents/images/
	$(INSTALL_DATA) kaisen-additional3-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/kaisen-additional3.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-additional3-theme/wallpaper kaisen-additional3

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional3-theme/lockscreen/contents/images
	$(INSTALL_DATA) kaisen-additional3-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-additional3-theme/lockscreen
	$(INSTALL_DATA) kaisen-additional3-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-additional3-theme/lockscreen
	$(INSTALL_DATA) $(wildcard kaisen-additional3-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additional3-theme/lockscreen/contents/images/

	# additional4 theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/kaisen-additional4
	$(INSTALL_DATA) $(wildcard kaisen-additional5-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/kaisen-additional4
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional4-theme
	cd $(DESTDIR)/usr/share/desktop-base/kaisen-additional4-theme && ln -s /usr/share/plymouth/themes/kaisen-additional4 plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional4-theme/login
	$(INSTALL_DATA) $(wildcard kaisen-additional4-theme/login/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additional4-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional4-theme/wallpaper/contents/images
	$(INSTALL_DATA) kaisen-additional4-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-additional4-theme/wallpaper
	$(INSTALL_DATA) kaisen-additional4-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-additional4-theme/wallpaper
	$(INSTALL_DATA) $(wildcard kaisen-additional4-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additional4-theme/wallpaper/contents/images/
	$(INSTALL_DATA) kaisen-additional4-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/kaisen-additional4.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-additional4-theme/wallpaper kaisen-additional4

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional4-theme/lockscreen/contents/images
	$(INSTALL_DATA) kaisen-additional4-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-additional4-theme/lockscreen
	$(INSTALL_DATA) kaisen-additional4-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-additional4-theme/lockscreen
	$(INSTALL_DATA) $(wildcard kaisen-additional4-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additional4-theme/lockscreen/contents/images/

	# additional5 theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/kaisen-additional5
	$(INSTALL_DATA) $(wildcard kaisen-additional5-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/kaisen-additional5
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional5-theme
	cd $(DESTDIR)/usr/share/desktop-base/kaisen-additional5-theme && ln -s /usr/share/plymouth/themes/kaisen-additional5 plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional5-theme/login
	$(INSTALL_DATA) $(wildcard kaisen-additional5-theme/login/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additional5-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional5-theme/wallpaper/contents/images
	$(INSTALL_DATA) kaisen-additional5-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-additional5-theme/wallpaper
	$(INSTALL_DATA) kaisen-additional5-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-additional5-theme/wallpaper
	$(INSTALL_DATA) $(wildcard kaisen-additional5-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additional5-theme/wallpaper/contents/images/
	$(INSTALL_DATA) kaisen-additional5-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/kaisen-additional5.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-additional5-theme/wallpaper kaisen-additional5

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional5-theme/lockscreen/contents/images
	$(INSTALL_DATA) kaisen-additional5-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-additional5-theme/lockscreen
	$(INSTALL_DATA) kaisen-additional5-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-additional5-theme/lockscreen
	$(INSTALL_DATA) $(wildcard kaisen-additional5-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additional5-theme/lockscreen/contents/images/

	# additional6 theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/kaisen-additional6
	$(INSTALL_DATA) $(wildcard kaisen-additional6-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/kaisen-additional6
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional6-theme
	cd $(DESTDIR)/usr/share/desktop-base/kaisen-additional6-theme && ln -s /usr/share/plymouth/themes/kaisen-additional6 plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional6-theme/login
	$(INSTALL_DATA) $(wildcard kaisen-additional6-theme/login/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additional6-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional6-theme/wallpaper/contents/images
	$(INSTALL_DATA) kaisen-additional6-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-additional6-theme/wallpaper
	$(INSTALL_DATA) kaisen-additional6-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-additional6-theme/wallpaper
	$(INSTALL_DATA) $(wildcard kaisen-additional6-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additional6-theme/wallpaper/contents/images/
	$(INSTALL_DATA) kaisen-additional6-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/kaisen-additional6.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-additional6-theme/wallpaper kaisen-additional6

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional6-theme/lockscreen/contents/images
	$(INSTALL_DATA) kaisen-additional6-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-additional6-theme/lockscreen
	$(INSTALL_DATA) kaisen-additional6-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-additional6-theme/lockscreen
	$(INSTALL_DATA) $(wildcard kaisen-additional6-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additional6-theme/lockscreen/contents/images/

	# additional7 theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/kaisen-additional7
	$(INSTALL_DATA) $(wildcard kaisen-additional7-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/kaisen-additional7
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional7-theme
	cd $(DESTDIR)/usr/share/desktop-base/kaisen-additional7-theme && ln -s /usr/share/plymouth/themes/kaisen-additional7 plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional7-theme/login
	$(INSTALL_DATA) $(wildcard kaisen-additional7-theme/login/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additional7-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional7-theme/wallpaper/contents/images
	$(INSTALL_DATA) kaisen-additional7-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-additional7-theme/wallpaper
	$(INSTALL_DATA) kaisen-additional7-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-additional7-theme/wallpaper
	$(INSTALL_DATA) $(wildcard kaisen-additional7-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additional7-theme/wallpaper/contents/images/
	$(INSTALL_DATA) kaisen-additional7-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/kaisen-additional7.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/kaisen-additional7-theme/wallpaper kaisen-additional7

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/kaisen-additional7-theme/lockscreen/contents/images
	$(INSTALL_DATA) kaisen-additional7-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/kaisen-additional7-theme/lockscreen
	$(INSTALL_DATA) kaisen-additional7-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/kaisen-additional7-theme/lockscreen
	$(INSTALL_DATA) $(wildcard kaisen-additional7-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/kaisen-additional7-theme/lockscreen/contents/images/

include Makefile.inc
