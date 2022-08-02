PATH := ${HOME}/go/bin/:$(PATH)
BUILD_DIR = $(realpath .)/build
MOD_VERSION = 0.0.4
MC_VERSION = 1.19
RELEASE_VERSION = $(MOD_VERSION)+$(MC_VERSION)

.PHONY: all
all: reinit export


# 'host' is the union of the client and server mods.  Used for local multiplayer.
.PHONY: host
host:

.PHONY: export
export:
	mkdir -p ${BUILD_DIR}
	cd client && packwiz modrinth export --output ${BUILD_DIR}/CrazyDavesModpack-${RELEASE_VERSION}-client.mrpack
	cd server && packwiz modrinth export --output ${BUILD_DIR}/CrazyDavesModpack-${RELEASE_VERSION}-server.mrpack
	rm -rf host/mods/* host/resourcepacks/* host/config.*
	cp -R client/mods/* host/mods/
	cp -R client/config/* host/config/
	cp -R client/resourcepacks/* host/resourcepacks/
	cp -R server/mods/* host/mods/
	cp -R server/config/* host/config/
	cd host && packwiz modrinth export --output ${BUILD_DIR}/CrazyDavesModpack-${RELEASE_VERSION}-host.mrpack


.PHONY: reinit
reinit:
	cd client && packwiz init -r --version ${RELEASE_VERSION} --name "CrazyDavesModpack-client" --author "pcal" --mc-version ${MC_VERSION} --fabric-latest --modloader fabric
	cd server && packwiz init -r --version ${RELEASE_VERSION} --name "CrazyDavesModpack-server" --author "pcal" --mc-version ${MC_VERSION} --fabric-latest --modloader fabric
	cd host && packwiz init -r --version ${RELEASE_VERSION} --name "CrazyDavesModpack-host" --author "pcal" --mc-version ${MC_VERSION} --fabric-latest --modloader fabric


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
