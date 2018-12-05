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

First, clone the repo and re-initialize it

```
git clone github.com/replicatedhq/replicated-starter-kubernetes.git
cd replicated-starter-kubernetes
rm -rf .git
git init
git remote add origin <your git repo>
```

#### Configure environment

You'll need to set up two environment variables to interact with vendor.replicated.com,
`REPLICATED_APP` and `REPLICATED_API_TOKEN`. `REPLICATED_APP` should be set to the
app name in the URL path at https://vendor.replicated.com/apps:

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
make release channel=Unstable
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

### Integrating with CI

Often teams will use one channel per developer, and then keep the `master` branch of this repo in sync with their `Unstable` branch.

The project includes CI configs for [Travis CI](https://travis-ci.org) and [CircleCI](https://circleci.com).

Both configs will:

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
