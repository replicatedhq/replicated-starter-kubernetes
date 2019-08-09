Replicated Kubernetes Starter
==================

Example project showcasing how power users can combine several Replicated tools in order to manage
Replicated YAML using a git repository.

[Kubernetes](https://github.com/replicatedhq/replicated-starter-kubernetes)
| [Swarm](https://github.com/replicatedhq/replicated-starter-swarm)


### Prequisites

- [node](https://nodejs.org/en/download/)
- `make`
- A git repository created to manage your Replicated YAML. We'll use github in this example.

### Get started

This repo is a [GitHub Template Repository](https://help.github.com/en/articles/creating-a-repository-from-a-template). You can create a private copy by using the "Use this Template" link in the repo:

![Template Repo](https://help.github.com/assets/images/help/repository/use-this-template-button.png)

You should use the template to create a new **private** repo in your org, for example `mycompany/replicated` or `mycompany/replicated-starter-kubernetes`.

Once you've created a repository from the template, you'll want to `git clone` your new repo and `cd` into it locally.

#### Configure environment

You'll need to set up two environment variables to interact with vendor.replicated.com:

```
export REPLICATED_APP=...
export REPLICATED_API_TOKEN=...
```

`REPLICATED_APP` should be set to the app slug from the Settings page:

<p align="center"><img src="./doc/REPLICATED_APP.png" width=600></img></p>

Next, create an API token from the [Teams and Tokens](https://vendor.replicated.com/team/tokens) page:

<p align="center"><img src="./doc/REPLICATED_API_TOKEN.png" width=600></img></p>

Ensure the token has "Write" access or you'll be unable create new releases. Once you have the values,
set them in your environment.

```
export REPLICATED_APP=...
export REPLICATED_API_TOKEN=...
```

You can ensure this is working with

```
make list-releases
```

#### Iterating on your release

Once you've made changes to `replicated.yaml`, you can push a new release to a channel with

```
make release
```

By default the `Unstable` channel will be used. You can override this with `channel`:

```
make release channel=Beta
```

If you have nodejs installated, you can lint your YAML before releasing with

```
make lint
```

or even

```
make lint release
```

For an integrated approach, you can use `make watch` to watch the `replicated.yaml` file, linting and
releasing whenever changes are made.

```
$ make watch channel=my-dev-channel
: ┌───────────────────────────────────────────
: │ This command will watch replicated.yaml for
: │ changes and publish a new release to the
: │ "my-dev-channel" channel on changes.
: │
: │ You will need to set the following
: │ environment variables, both of which
: │ can be obtained at https://vendor.replicated.com
: │
: │  REPLICATED_APP -- The ID or url slug of your application
: │  REPLICATED_API_TOKEN -- An API token with write access to releases.
: │
: │ You can set the channel by passing a
: │ "channel" to "make watch", e.g.
: │
: │    make watch channel=dev
: │
: └────────────────────────────────────────────
info gazer-color Watching 1 file[s] (replicated.yaml)
```
#### CLI in Docker

Use `replicated/vendor-cli` Docker image to execute the CLI inside a container. This is useful in environments where `make` and `replicated` cli are unsupported. If you have OS X or Linux continue using `make`.

List releases which will download `replicated/vendor-cli` and verify the environment variables are configured.
```
make docker-list-releases
```

Promote a release via Docker vendor CLI
```
make docker-release working_dir=/path/to/git/repo
```

Note: On Windows OS ensure the `working_dir` is shared and available in Docker (Settings -> Shared Drives).

### Integrating with CI

Often teams will use one channel per developer, and then keep the `master` branch of this repo in sync with their `Unstable` branch.

The project includes CI configs for [Travis CI](https://travis-ci.org), [CircleCI](https://circleci.com), [Jenkins CI](https://jenkins.io), and [GitLab CI](https://gitlab.com).

The configs will:

**On pull requests**:

- Install dependencies
- Lint yaml for syntax and logic errors

**On merges to the github `master` branch**:

- Install dependencies
- Lint yaml for syntax and logic errors
- Create a new release on the `Unstable` channel in Replicated

These behaviors are documented and demonstrated in the [replicated-ci-demo](https://github.com/replicatedhq/replicated-ci-demo) project.

### Tools reference

- [replicated-lint](https://github.com/replicatedhq/replicated-lint)
- [replicated vendor cli](https://github.com/replicatedhq/replicated)

### License

MIT
