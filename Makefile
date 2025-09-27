# Makefile (all relative paths; safe for open-source)
EMACS ?= emacs
PKG   ?= btc-ticker

# Load list: project root & test dir only (no absolute paths)
LOAD  := -L . -L test -l $(PKG).el -l test/$(PKG)-test.el
# Prefer newer .el over stale .elc when running tests
PREF  := --eval "(setq load-prefer-newer t)"

.PHONY: test test-all test-nonetwork run-ert compile clean echo-cmd

# Default: string-only tests (no network/API)
test: SELECT=(tag string)
test: run-ert

# Everything
test-all: SELECT=t
test-all: run-ert

# All except network-tagged tests
test-nonetwork: SELECT=(not (tag network))
test-nonetwork: run-ert

run-ert: echo-cmd
	$(EMACS) -Q --batch $(PREF) $(LOAD) \
	  --eval "(ert-run-tests-batch-and-exit '$(SELECT))"

# Debug: show the exact command Emacs will receive
echo-cmd:
	@echo $(EMACS) -Q --batch $(PREF) $(LOAD) --eval "(ert-run-tests-batch-and-exit '$(SELECT))"

# Optional: byte-compile project (excluding tests)
compile:
	$(EMACS) -Q --batch -L . -f batch-byte-compile $(filter-out test/%, $(wildcard *.el))

clean:
	rm -f *.elc test/*.elc
