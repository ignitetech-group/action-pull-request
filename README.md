# 🚀 GitHub Action for creating Pull Requests
**GitHub Action that will create a pull request from the currently selected branch.**

> [!NOTE]
> This is the IgniteTech fork of [`devops-infra/action-pull-request`](https://github.com/devops-infra/action-pull-request). It builds the action image from the local `Dockerfile` on every consumer run (no pre-built third-party image is pulled), uses the `gh` CLI plus the GitHub REST API instead of the deprecated `hub` binary, and pins all CI third-party actions to commit SHAs.
>
> **Always pin to a full commit SHA**, never to a branch (`@master`) or a version tag (`@v1`, `@v1.0.2`). Branches move with every push and tags can be force-moved by maintainers, so both are mutable references that let upstream changes silently flow into your CI. A 40-character commit SHA is immutable and reproducible. Find the SHA you want at [github.com/ignitetech-group/action-pull-request/commits/master](https://github.com/ignitetech-group/action-pull-request/commits/master) and substitute it in the examples below.


## 📦 Source

This fork does not publish a pre-built image. `action.yml` uses `image: Dockerfile`, so consumers build the image from source on the runner.


## ✨ Features
* Creates pull request if triggered from a current branch or any specified by `source_branch` to a `target_branch`
* Title and body of a pull request can be specified with `title` and `body`
* Can assign `assignee`, `reviewer`, one or more `label`, a `milestone` or mark it as a `draft`
* Can replace any `old_string` inside a pull request template with a `new_string`. Or put commits' subjects in place of `old_string`
* When `get_diff` is `true` will add list of commits in place of `<!-- Diff commits -->` and list of modified files in place of `<!-- Diff files -->` in a pull request template
* When `allow_no_diff` is set to true will continue execution and create pull request even if both branches have no differences, e.g. having only a merge commit
* Supports both `amd64` and `arm64` architectures


## 🔗 Related Actions
**Useful in combination with my other action [devops-infra/action-commit-push](https://github.com/devops-infra/action-commit-push).**


## 📊 Badges
[
![GitHub repo](https://img.shields.io/badge/GitHub-devops--infra%2Faction--pull--request-blueviolet.svg?style=plastic&logo=github)
![GitHub last commit](https://img.shields.io/github/last-commit/devops-infra/action-pull-request?color=blueviolet&logo=github&style=plastic&label=Last%20commit)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/devops-infra/action-pull-request?color=blueviolet&label=Code%20size&style=plastic&logo=github)
![GitHub license](https://img.shields.io/github/license/devops-infra/action-pull-request?color=blueviolet&logo=github&style=plastic&label=License)
](https://github.com/devops-infra/action-pull-request "shields.io")
<br>
[
![DockerHub](https://img.shields.io/badge/DockerHub-devopsinfra%2Faction--pull--request-blue.svg?style=plastic&logo=docker)
![Docker version](https://img.shields.io/docker/v/devopsinfra/action-pull-request?color=blue&label=Version&logo=docker&style=plastic&sort=semver)
![Image size](https://img.shields.io/docker/image-size/devopsinfra/action-pull-request/latest?label=Image%20size&style=plastic&logo=docker)
![Docker Pulls](https://img.shields.io/docker/pulls/devopsinfra/action-pull-request?color=blue&label=Pulls&logo=docker&style=plastic)
](https://hub.docker.com/r/devopsinfra/action-pull-request "shields.io")


## 🏷️ Pinning the action

This fork is published only as source. Always pin consumers to a full 40-character commit SHA — branch names and tags are mutable and let upstream changes silently land in your CI. To upgrade, look up a newer commit on [the master history](https://github.com/ignitetech-group/action-pull-request/commits/master), update the SHA, and let CodeRabbit / your own review catch any behavior changes before merging.




## 📖 API Reference
```yaml
    - name: Run the Action
      uses: ignitetech-group/action-pull-request@16d9d8a4a76364d19ba585492a2bc5776e05be4a # replace with a current SHA from github.com/ignitetech-group/action-pull-request/commits/master
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        source_branch: development
        target_branch: master
        title: My pull request
        template: .github/PULL_REQUEST_TEMPLATE.md
        body: "**Automated pull request**"
        reviewer: octocat
        assignee: octocat
        label: enhancement
        milestone: My milestone
        draft: true
        old_string: "<!-- Add your description here -->"
        new_string: "** Automatic pull request**"
        get_diff: true
        ignore_users: "dependabot"
        allow_no_diff: false
```


### 🔧 Input Parameters
| Input Variable  | Required | Default                       | Description                                                                                                             |
|-----------------|----------|-------------------------------|-------------------------------------------------------------------------------------------------------------------------|
| `github_token`  | **Yes**  | `""`                          | GitHub token `${{ secrets.GITHUB_TOKEN }}`                                                                              |
| `source_branch` | No       | *current branch*              | Name of the source branch                                                                                               |
| `target_branch` | No       | `master`                      | Name of the target branch. Change it if you use `main`                                                                  |
| `title`         | No       | *subject of the first commit* | Pull request title                                                                                                      |
| `template`      | No       | `""`                          | Template file location                                                                                                  |
| `body`          | No       | *list of commits*             | Pull request body                                                                                                       |
| `reviewer`      | No       | `""`                          | Reviewer's username                                                                                                     |
| `assignee`      | No       | `""`                          | Assignee's usernames                                                                                                    |
| `label`         | No       | `""`                          | Labels to apply, comma separated                                                                                        |
| `milestone`     | No       | `""`                          | Milestone                                                                                                               |
| `draft`         | No       | `false`                       | Whether to mark it as a draft                                                                                           |
| `old_string`    | No       | `""`                          | Old string for the replacement in the template                                                                          |
| `new_string`    | No       | `""`                          | New string for the replacement in the template. If not specified, but `old_string` was, it will gather commits subjects |
| `get_diff`      | No       | `false`                       | Whether to replace predefined comments with differences between branches - see details below                            |
| `ignore_users`  | No       | `"dependabot"`                | List of users to ignore, comma separated                                                                                |
| `allow_no_diff` | No       | `false`                       | Allows to continue on merge commits with no diffs                                                                       |


### 📤 Outputs Parameters
| Output      | Description                   |
|-------------|-------------------------------|
| `url`       | Pull request URL              |
| `pr_number` | Number of GitHub pull request |


### ➿ How get_diff works
In previous versions occurrences of following strings in a template result with replacing them with list of commits and list of modified files (`<!-- Diff commits -->` and `<!-- Diff files -->`).

Now this action will expect to have three types of comment blocks. Meaning anything between `START` and `END` comment will get replaced. This is especially important when updating pull request with new commits.

* `<!-- Diff summary - START -->` and `<!-- Diff summary - END -->` - show first lines of each commit in the pull request
* `<!-- Diff commits - START -->` and `<!-- Diff commits - END -->` - show graph of commits in the pull request, with authors' info and time
* `<!-- Diff files - START -->` and `<!-- Diff files - END -->` - show list of modified files

If your template uses old comment strings it will try to adjust them in the pull request body to a new standard when pull request is created. It will not modify the template.

**CAUTION**: Remember to not use default `fetch-depth` for [actions/checkout](https://github.com/actions/checkout) action. Rather set it to `0` - see example below.


## 💻 Usage Examples

Red areas show fields that can be dynamically expanded based on commits to the current branch.
Blue areas show fields that can be set in action configuration.

![Example screenshot](https://github.com/devops-infra/action-pull-request/raw/master/action-pull-request.png)


### 📝 Basic Example
Create pull request for non-master branches:

```yaml
name: Run the Action
on:
  push:
    branches-ignore: master
jobs:
  action-pull-request:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@1af3b93b6815bc44a9784bd300feb67ff0d1eeb3 # actions/checkout@v6.0.0

      - name: Create pull request
        uses: ignitetech-group/action-pull-request@16d9d8a4a76364d19ba585492a2bc5776e05be4a # replace with a current SHA from github.com/ignitetech-group/action-pull-request/commits/master
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          title: Automatic pull request
```

### 🔀 Advanced Example
Use first commit as a title and part of body, add a label based on a branch name, add git differences in the template:

```yaml
name: Run the Action
on:
  push:
    branches-ignore: master
jobs:
  action-pull-request:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@1af3b93b6815bc44a9784bd300feb67ff0d1eeb3 # actions/checkout@v6.0.0
        with:
          fetch-depth: 0

      - name: Run the Action
        if: startsWith(github.ref, 'refs/heads/feature')
        uses: ignitetech-group/action-pull-request@16d9d8a4a76364d19ba585492a2bc5776e05be4a # replace with a current SHA from github.com/ignitetech-group/action-pull-request/commits/master
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          title: ${{ github.event.commits[0].message }}
          assignee: ${{ github.actor }}
          label: automatic,feature
          template: .github/PULL_REQUEST_TEMPLATE/FEATURE.md
          old_string: "**Write your description here**"
          new_string: ${{ github.event.commits[0].message }}
          get_diff: true
```

### 🎯 Pinning to a specific commit

Pin to a full commit SHA. The trailing comment is a convention from `actions/checkout` and other widely-used actions: it lets readers see which version they're on at a glance, while the SHA stays the source of truth.

```yaml
name: Run the Action
on:
  push:
    branches-ignore: master
jobs:
  action-pull-request:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@1af3b93b6815bc44a9784bd300feb67ff0d1eeb3 # actions/checkout@v6.0.0

      # Pick the SHA you want from
      # https://github.com/ignitetech-group/action-pull-request/commits/master
      - uses: ignitetech-group/action-pull-request@<commit-sha> # ignitetech-group/action-pull-request@<descriptor>
```


## 🤝 Contributing
Contributions are welcome! See [CONTRIBUTING](https://github.com/devops-infra/.github/blob/master/CONTRIBUTING.md).
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


## 💬 Support
If you have any questions or need help, please:
- 📝 For issues with this fork (the `gh`/REST-API entrypoint, the hardened workflows, the local-Dockerfile build model): file an [issue on the fork](https://github.com/ignitetech-group/action-pull-request/issues).
- 📝 For issues with the upstream behaviour that this fork inherits unchanged: see [`devops-infra/action-pull-request` issues](https://github.com/devops-infra/action-pull-request/issues).

## Forking
To publish images from a fork, set these variables so Task uses your registry identities:
`DOCKER_USERNAME`, `DOCKER_ORG_NAME`, `GITHUB_USERNAME`, `GITHUB_ORG_NAME`.

Two supported options (environment variables take precedence over `.env`):
```bash
# .env (local only, not committed)
DOCKER_USERNAME=your-dockerhub-user
DOCKER_ORG_NAME=your-dockerhub-org
GITHUB_USERNAME=your-github-user
GITHUB_ORG_NAME=your-github-org
```

```bash
# Shell override
DOCKER_USERNAME=your-dockerhub-user \
DOCKER_ORG_NAME=your-dockerhub-org \
GITHUB_USERNAME=your-github-user \
GITHUB_ORG_NAME=your-github-org \
task docker:build
```

Recommended setup:
- Local development: use a `.env` file.
- GitHub Actions: set repo variables for the four values above, and secrets for `DOCKER_TOKEN` and `GITHUB_TOKEN`.

Publishing images:
- This fork builds the action image from the local `Dockerfile` at runtime (`image: Dockerfile` in `action.yml`), so consumers do not need a pre-built image.
- To publish manually, run `task docker:build:local` then push with your registry credentials. CI here only verifies that the build succeeds; it does not push.
