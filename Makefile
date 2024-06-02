.PHONY: build uidcheck install uninstall reinstall

NAME?=dev
PROFILE?=sid

_UID=$(shell id -u)
_USER=$(USER)
_GID=$(shell id -g)
_GROUP=$(shell id -gn)
_HOME=$(HOME)

_OUTPUT_DIR=mkosi.output
_NSPAWN_DIR=/etc/systemd/nspawn
_SERVICE_DIR=/etc/systemd/system/systemd-nspawn@$(NAME).service.d

_IMAGE_SRC=$(_OUTPUT_DIR)/$(NAME).tar
_NSPAWN_SRC=$(_OUTPUT_DIR)/$(NAME).nspawn
_SERVICE_SRC=$(_OUTPUT_DIR)/$(NAME).service

_NSPAWN_DST=$(_NSPAWN_DIR)/$(NAME).nspawn
_SERVICE_DST=$(_SERVICE_DIR)/drop-in.conf

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
	if [ -f $(_SERVICE_SRC) ]; then mkdir -p $(_SERVICE_DIR); cp $(_SERVICE_SRC) $(_SERVICE_DST); fi
	systemctl daemon-reload
	machinectl start $(NAME)

uninstall: uidcheck
	if machinectl status $(NAME) > /dev/null 2>&1; then machinectl terminate $(NAME); sleep 3; fi
	if machinectl image-status $(NAME) > /dev/null 2>&1; then machinectl remove $(NAME); fi
	rm -rf $(_NSPAWN_DST) $(_SERVICE_DIR)
	rmdir --ignore-fail-on-non-empty $(_NSPAWN_DIR)
	systemctl daemon-reload

reinstall: uninstall install
