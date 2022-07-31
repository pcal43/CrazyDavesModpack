PATH := ${HOME}/go/bin/:$(PATH)
BUILD_DIR = $(realpath .)/build

.PHONY: install
install:
	brew install golang
	go install github.com/packwiz/packwiz@latest

.PHONY: client
client:
	mkdir -p ${BUILD_DIR}
	cd client && packwiz modrinth export --output ${BUILD_DIR}/CrazyDavesModpack-client.mrpack

.PHONY: server
server:
	mkdir -p ${BUILD_DIR}
	cd server && packwiz modrinth export --output ${BUILD_DIR}/CrazyDavesModpack-server.mrpack

.PHONY: host
host:
	rm -rf host/mods/* host/resourcepacks/* host/config.*
	cp -R client/mods/* host/mods/
	cp -R client/config/* host/config/
	cp -R server/mods/* host/mods/
	cp -R server/config/* host/config/
	cd host && packwiz modrinth export --output ${BUILD_DIR}/CrazyDavesModpack-host.mrpack

.PHONY: clean
clean:
	rm -rf ${BUILD_DIR}

.PHONY: clean-cache
clean-cache:
	rm -rf ${HOME}/Library/Caches/packwiz/cache
