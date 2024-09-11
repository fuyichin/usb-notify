PROJECT=usb-notify
CC=gcc
BIN=bin

CFLAGS = -ansi \
		 -pedantic \
		 -g \
		 -std=c99 \
		 -W \
		 -Wextra \
		 -Wall \
		 `pkg-config --cflags libnotify` \
		 -DUSB_NOTIFY_PLAY_SOUND

LIBS     =  -ludev

SRC_MAIN := src/usb-notify.o
SRC      :=

USB_NOTIFY_TMP := $(shell mktemp)
ARCH := $(shell dpkg --print-architecture)

all: usb-notify

usb-notify: $(SRC_MAIN) $(SRC)
		 $(CC) $(CFLAGS) -o $(BIN)/$(PROJECT) $^ `pkg-config --libs libnotify` $(LIBS)

clean:
		 rm -f $(BIN)/*
		 rm -f src/*.o

install:
		 install -m 755 ./bin/usb-notify /usr/local/bin/usb-notify

## make debian package
debian: ./bin/usb-notify
	echo -e $(USB_NOTIFY_TMP)
	rm -f $(USB_NOTIFY_TMP)
	mkdir -p $(USB_NOTIFY_TMP)/usr/bin
	install -m 755 ./bin/usb-notify $(USB_NOTIFY_TMP)/usr/bin/usb-notify
	mkdir -p $(USB_NOTIFY_TMP)/DEBIAN
	sed s/i386/$(ARCH)/ control >$(USB_NOTIFY_TMP)/DEBIAN/control
	mkdir -p $(USB_NOTIFY_TMP)/usr/lib/usb-notify/asset
	install asset/usb-insert.wav $(USB_NOTIFY_TMP)/usr/lib/usb-notify/asset/usb-notify.wav
	dpkg -b $(USB_NOTIFY_TMP)/ usb-notify-0.1.0.$(ARCH).deb
	@rm -rf $(USB_NOTIFY_TMP)
