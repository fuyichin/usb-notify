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
	rm -rf /tmp/usb-notify
	mkdir -p /tmp/usb-notify/usr/bin
	install -m 755 ./bin/usb-notify /tmp/usb-notify/usr/bin/usb-notify
	mkdir -p /tmp/usb-notify/DEBIAN
	install control /tmp/usb-notify/DEBIAN/control
	mkdir -p /tmp/usb-notify/usr/lib/usb-notify/asset
	install asset/usb-insert.wav /tmp/usb-notify/usr/lib/usb-notify/asset/usb-notify.wav
	dpkg -b /tmp/usb-notify/ usb-notify-0.1.0.deb
