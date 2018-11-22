.PHONY: deps-vendor-cli deps-lint deps lint release init watch pull-latest-release list-releases

channel ?= Unstable
lint_reporter ?= console
replicated_lint ?= `npm bin`/replicated-lint
SHELL := /bin/bash -o pipefail

deps-vendor-cli:
	mkdir -p deps/
	if [[ "`uname`" == "Linux" ]]; then curl -fsSL https://github.com/replicatedhq/replicated/releases/download/v0.4.0/cli_0.4.0_linux_amd64.tar.gz | tar xvz -C deps; exit 0; fi; \
	if [[ "`uname`" == "Darwin" ]]; then curl -fsSL https://github.com/replicatedhq/replicated/releases/download/v0.4.0/cli_0.4.0_darwin_amd64.tar.gz | tar xvz -C deps; exit 0; fi;

deps-lint:
	npm install --save-dev replicated-lint gazer-color
deps: deps-lint deps-vendor-cli

lint:
	$(replicated_lint) validate --infile replicated.yaml --reporter $(lint_reporter)
	# check k8s for valid yaml, no schema checks yet
	$(replicated_lint) validate --infile replicated.yaml --reporter $(lint_reporter) --excludeDefaults --multidocIndex=1

release:
	cat replicated.yaml | deps/replicated release create --promote $(channel) --yaml -

watch:
	: ┌───────────────────────────────────────────
	: │ This command will watch replicated.yaml for
	: │ changes and publish a new release to the
	: │ "$(channel)" channel on changes.
	: │
	: │ You will need to set the following
	: │ environment variables, both of which
	: │ can be obtained at https://vendor.replicated.com
	: │
	: │  $$REPLICATED_APP -- The ID or url slug of your application
	: │  $$REPLICATED_API_TOKEN -- An API token with write access to releases.
	: │
	: │ You can set the channel by passing a
	: │ "channel" to "make watch", e.g.
	: │
	: │    make watch channel=dev
	: │
	: └────────────────────────────────────────────
	`npm bin`/gazer-color --pattern replicated.yaml ${MAKE} lint release

pull-latest-release:
	deps/replicated release ls | head -n 2 | tail -n 1 | cut -d' ' -f 1 | xargs deps/replicated release inspect  | sed '1,/---/d'  > replicated.yaml

list-releases:
	deps/replicated release ls

