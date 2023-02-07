.PHONY: make build clean install uninstall

NAME?=docker

make: build install

build:
	sudo mkosi build

clean:
	sudo mkosi clean
	sudo find \
		./mkosi.workspace/ \
		./mkosi.cache/ \
		./mkosi.output/ \
		-mindepth 1 \
		-not -name .gitignore \
		-delete

install:
	sudo mkdir -p \
		/etc/systemd/nspawn \
		/var/lib/machines
	sudo mv \
		./mkosi.output/debian~sid/image \
		/var/lib/machines/${NAME}
	sudo mv \
		./mkosi.output/image.nspawn \
		/etc/systemd/nspawn/${NAME}.nspawn
	sudo machinectl start ${NAME}

uninstall:
	sudo machinectl terminate ${NAME} || true
	sleep 3
	sudo machinectl remove ${NAME} || true
	sudo rm -rf \
		/var/lib/machines/${NAME} \
		/etc/systemd/nspawn/${NAME}.nspawn
	sudo rmdir --ignore-fail-on-non-empty \
		/etc/systemd/nspawn \
		/var/lib/machines
