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
	cd server && packwiz modrinth export
