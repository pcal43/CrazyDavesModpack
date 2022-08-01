PATH := ${HOME}/go/bin/:$(PATH)
BUILD_DIR = $(realpath .)/build
VERSION = 0.0.2+1.19

.PHONY: all
all: server client host

.PHONY: install
install:
	brew install golang
	go install github.com/packwiz/packwiz@latest

.PHONY: client
client:
	mkdir -p ${BUILD_DIR}
	cd client && packwiz modrinth export --output ${BUILD_DIR}/CrazyDavesModpack-${VERSION}-client.mrpack

.PHONY: server
server:
	mkdir -p ${BUILD_DIR}
	cd server && packwiz modrinth export --output ${BUILD_DIR}/CrazyDavesModpack-${VERSION}-server.mrpack


# 'host' is the union of the client and server mods.  Used for local multiplayer.
.PHONY: host
host:
	rm -rf host/mods/* host/resourcepacks/* host/config.*
	cp -R client/mods/* host/mods/
	cp -R client/config/* host/config/
	cp -R server/mods/* host/mods/
	cp -R server/config/* host/config/
	mkdir -p ${BUILD_DIR}
	cd host && packwiz modrinth export --output ${BUILD_DIR}/CrazyDavesModpack-${VERSION}-host.mrpack

.PHONY: clean
clean:
	rm -rf ${BUILD_DIR}

.PHONY: clean-cache
clean-cache:
	rm -rf ${HOME}/Library/Caches/packwiz/cache
