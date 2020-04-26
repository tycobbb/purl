include ./Makefile.base.mk

# -- cosmetics --
help-column-width = 6

# -- context --
tools-cargo = cargo

# -- init --
## setup the dev environment
init: i/pre
.PHONY: init

i/pre:
ifeq ("$(shell command -v cargo)", "")
	$(info ✘ cargo is not installed, please install rust:)
	$(info - https://www.rust-lang.org/tools/install)
	$(error 1)
endif
.PHONY: i/pre

# -- build --
## alias for b/dev
build: b
.PHONY: build

b: b/dev
.PHONY: b

## build a dev binary
b/dev:
	$(tools-cargo) build --lib
.PHONY: b/dev

## build a release binary
b/prod:
	$(tools-cargo) build --lib --release
.PHONY: s/dev

# -- test --
## alias for t/unit
test: t
.PHONY: test

t: t/unit
.PHONY: t

## runs unit tests
t/unit:
	$(tools-cargo) test
.PHONY: t/unit
