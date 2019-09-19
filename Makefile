.PHONY: deps-vendor-cli deps-lint deps lint release init watch pull-latest-release list-releases

channel ?= Unstable
working_dir ?= `pwd`
lint_reporter ?= console
replicated_lint ?= `npm bin`/replicated-lint
SHELL := /bin/bash -o pipefail

deps-vendor-cli:
	@if [[ -x deps/replicated ]]; then exit 0; else \
	echo '-> Downloading Replicated CLI... '; \
	mkdir -p deps/; \
	if [[ "`uname`" == "Linux" ]]; then curl -fsSL https://github.com/replicatedhq/replicated/releases/download/v0.13.0/replicated_0.13.0_linux_amd64.tar.gz | tar xvz -C deps; exit 0; fi; \
	if [[ "`uname`" == "Darwin" ]]; then curl -fsSL https://github.com/replicatedhq/replicated/releases/download/v0.13.0/replicated_0.13.0_darwin_amd64.tar.gz | tar xvz -C deps; exit 0; fi; fi;

deps-lint:
	@[ -x `npm bin`/replicated-lint ] || npm install --no-save replicated-lint

deps-watch:
	@[ -x `npm bin`/gazer-color ] || npm install --no-save gazer-color

deps: deps-lint deps-vendor-cli deps-watch

lint: deps-lint
	$(replicated_lint) validate --infile replicated.yaml --reporter $(lint_reporter)
	# check k8s for valid yaml, no schema checks yet
	$(replicated_lint) validate --infile replicated.yaml --reporter $(lint_reporter) --excludeDefaults --multidocIndex=1

release: deps-vendor-cli
	cat replicated.yaml | deps/replicated release create --promote $(channel) --yaml -

watch: deps
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

pull-latest-release: deps-vendor-cli
	deps/replicated release ls | head -n 2 | tail -n 1 | cut -d' ' -f 1 | xargs deps/replicated release inspect  | sed '1,/---/d'  > replicated.yaml

list-releases: deps-vendor-cli
	deps/replicated release ls

docker-release:
	docker run \
  -e REPLICATED_APP \
  -e REPLICATED_API_TOKEN \
  --mount src=$(working_dir),target=/working_dir,type=bind \
  replicated/vendor-cli \
  release create --promote $(channel) --yaml-file /working_dir/replicated.yaml

docker-list-releases:
	docker run \
  -e REPLICATED_APP \
  -e REPLICATED_API_TOKEN \
  replicated/vendor-cli \
  release ls

