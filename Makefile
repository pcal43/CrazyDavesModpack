PATH := ${HOME}/go/bin/:$(PATH)
BUILD_DIR = $(realpath .)/build
MOD_VERSION = 0.0.3
MC_VERSION = 1.19
RELEASE_VERSION = $(MOD_VERSION)+$(MC_VERSION)

.PHONY: all
all: server client host

.PHONY: client
client:
	mkdir -p ${BUILD_DIR}
	cd client &&\
        packwiz modrinth export --output ${BUILD_DIR}/CrazyDavesModpack-${RELEASE_VERSION}-client.mrpack &&\
        packwiz init -r --version ${RELEASE_VERSION} --name "CrazyDavesModpack-client" --author "pcal" --mc-version ${MC_VERSION} --fabric-latest --modloader fabric

.PHONY: server
server:
	mkdir -p ${BUILD_DIR}
	cd server &&\
        packwiz modrinth export --output ${BUILD_DIR}/CrazyDavesModpack-${RELEASE_VERSION}-server.mrpack &&\
        packwiz init -r --version ${RELEASE_VERSION} --name "CrazyDavesModpack-server" --author "pcal" --mc-version ${MC_VERSION} --fabric-latest --modloader fabric

# 'host' is the union of the client and server mods.  Used for local multiplayer.
.PHONY: host
host:
	rm -rf host/mods/* host/resourcepacks/* host/config.*
	cp -R client/mods/* host/mods/
	cp -R client/config/* host/config/
	cp -R client/resourcepacks/* host/resourcepacks/
	cp -R server/mods/* host/mods/
	cp -R server/config/* host/config/
	mkdir -p ${BUILD_DIR}
	cd host && \
        packwiz init -r --version ${RELEASE_VERSION} --name "CrazyDavesModpack-host" --author "pcal" --mc-version ${MC_VERSION} --fabric-latest --modloader fabric && \
        packwiz modrinth export --output ${BUILD_DIR}/CrazyDavesModpack-${RELEASE_VERSION}-host.mrpack

.PHONY: update
update:
	cd client && packwiz update --all
	cd server && packwiz update --all

.PHONY: clean
clean:
	rm -rf ${BUILD_DIR}

.PHONY: install
install:
	brew install golang
	go install github.com/packwiz/packwiz@latest

.PHONY: clean-cache
clean-cache:
	rm -rf ${HOME}/Library/Caches/packwiz/cache
