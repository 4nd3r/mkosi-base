.PHONY: build uidcheck install uninstall reinstall

NAME?=dev
PROFILE?=sid

_UID=$(shell id -u)
_USER=$(USER)
_GID=$(shell id -g)
_GROUP=$(shell id -gn)
_HOME=$(HOME)

_OUTPUT_DIR=mkosi.output
_IMAGE_SRC=$(_OUTPUT_DIR)/$(NAME).tar
_NSPAWN_SRC=$(_OUTPUT_DIR)/$(NAME).nspawn
_NSPAWN_DIR=/etc/systemd/nspawn
_NSPAWN_DST=$(_NSPAWN_DIR)/$(NAME).nspawn

build:
	mkdir -p $(_OUTPUT_DIR)
	_UID="$(_UID)" _USER="$(_USER)" _GID="$(_GID)" _GROUP="$(_GROUP)" _HOME="$(_HOME)" mkosi --image-id $(NAME) --profile $(PROFILE) -f
	./mkosi.nspawn.make > $(_NSPAWN_SRC)

uidcheck:
	@if [ "$(_UID)" != 0 ]; then echo 'use sudo'; exit 1; fi

install: uidcheck
	mkdir -p $(_NSPAWN_DIR)
	importctl -m import-tar $(_IMAGE_SRC) $(NAME)
	if [ -f $(_NSPAWN_SRC) ]; then cp $(_NSPAWN_SRC) $(_NSPAWN_DST); fi
	systemctl daemon-reload
	machinectl start $(NAME)

uninstall: uidcheck
	if machinectl status $(NAME) > /dev/null 2>&1; then machinectl terminate $(NAME); sleep 3; fi
	if machinectl image-status $(NAME) > /dev/null 2>&1; then machinectl remove $(NAME); fi
	rm -f $(_NSPAWN_DST)
	rmdir --ignore-fail-on-non-empty $(_NSPAWN_DIR)
	systemctl daemon-reload

reinstall: uninstall install
