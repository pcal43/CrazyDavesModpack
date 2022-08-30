PATH := ${HOME}/go/bin/:$(PATH)
BUILD_DIR = $(realpath .)/build
MOD_VERSION = 0.0.10
MC_VERSION = 1.19.2
BUILD_DIR = $(realpath .)/build
PACK_BUILD_DIR = $(BUILD_DIR)/$(MOD_VERSION)
RELEASE_VERSION = $(MOD_VERSION)+$(MC_VERSION)

.PHONY: all
all: reinit export


.PHONY: export
export:
	mkdir -p ${PACK_BUILD_DIR}
	cd client && packwiz modrinth export --output ${PACK_BUILD_DIR}/CrazyDavesModpack-${RELEASE_VERSION}-client.mrpack
	cd server && packwiz modrinth export --output ${PACK_BUILD_DIR}/CrazyDavesModpack-${RELEASE_VERSION}-server.mrpack
	cd host   && packwiz modrinth export --output ${PACK_BUILD_DIR}/CrazyDavesModpack-${RELEASE_VERSION}-host.mrpack

.PHONY: refresh
refresh:
	cd client && packwiz refresh
	cd server && packwiz refresh
	cd host && packwiz refresh

.PHONY: reinit
reinit:
	cd client && packwiz init -r --version ${RELEASE_VERSION} --name "CrazyDavesModpack-client" --author "pcal" --mc-version ${MC_VERSION} --fabric-latest --modloader fabric
	cd server && packwiz init -r --version ${RELEASE_VERSION} --name "CrazyDavesModpack-server" --author "pcal" --mc-version ${MC_VERSION} --fabric-latest --modloader fabric
	cd host   && packwiz init -r --version ${RELEASE_VERSION} --name "CrazyDavesModpack-host"   --author "pcal" --mc-version ${MC_VERSION} --fabric-latest --modloader fabric

.PHONY: update
update: reinit
	cd client && packwiz update --all
	cd server && packwiz update --all
	cd host && packwiz update --all

# 'host' is the union of the client and server mods.  Used for local multiplayer.
.PHONY: host-merge
host-merge:
	cp -R client/mods/* host/mods/
	cp -R client/config/* host/config/
	cp -R client/resourcepacks/* host/resourcepacks/
	cp -R client/shaderpacks/* host/shaderpacks/
	cp -R server/mods/* host/mods/
	cp -R server/config/* host/config/

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

.PHONY: release
release: clean export
	gh release create --notes '' ${RELEASE_VERSION} ${PACK_BUILD_DIR}/*.mrpack
