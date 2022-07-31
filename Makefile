PATH := ${HOME}/go/bin/:$(PATH)

.PHONY: install
install:
	brew install golang
	go install github.com/packwiz/packwiz@latest

.PHONY: client
client:
	cd client && packwiz modrinth export
