# OC Releaser

An automated release utility for [Ansible Collections](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html) with transferrable support to any git organization and repository. This release utility ensures standardized release processes across multiple teams or individuals.

Versioning is handled via conformance to [`conventionalcommits`](https://www.conventionalcommits.org). See [#versioning].

## Usage

Easily usable:
- Locally via the [`release-it`](https://github.com/release-it/release-it) utility
- Via travis with a single import

*Note*: Must use Ansible >2.10 to ensure that building ansible collections can properly use the [`build_ignore`](https://docs.ansible.com/ansible/devel/dev_guide/developing_collections_distributing.html#ignoring-files-and-folders) feature.

### Local Setup:
The `release-it` tool can also be used locally as long as you have the following packages installed on your machine and are using Ansible v2.10 or later.

```bash
npm install -g release-it
npm install -g @release-it/conventional-changelog
# Uses yq v4 syntax (may need a local update)
brew install yq
```

Execute
```bash
# Use -d for a dry-run, or --help to look at all options
GITHUB_TOKEN=<foo> release-it
```
### Travis Setup
In order for `release-it` to properly run in Travis automation, you only need to configure Travis to use a [Personal Access Token](https://github.ibm.com/settings/tokens).

1. Create a [Personal Access Token](https://github.ibm.com/settings/tokens). Only `repo` level access is needed.
2. Copy this token for potential local usage, you will need to set it in Travis repo-level settings.
3. Navigate to the Travis repo that will be built by this project and set a new `Environment Variable`
   1. Name: `GITHUB_TOKEN` 
   2. Value: `{copied_token}`
   3. Display value in build log: `OFF`

## Versioning
Releases are managed through [`release-it`](https://github.com/release-it/release-it). 

The `release-it` utility performs the following actions sequentially:
1. Ensure a local "clean" `git` environment (nothing shown in `git status`)
2. Ensure automation is being triggered from the `main` branch
3. Determines the last version number based on the latest `git tags`
4. Determine the next version using `git commit` messages that confrom to the [`conventionalcommits`](https://www.conventionalcommits.org) specification
   - If no commits match the `conventionalcommits` specification, the next version will increment the semver `PATCH` value
   - If a commit exists with a message beginning with `fix:`, the next version will increment the semver `PATCH` value
   - If a commit exists with a message beginning with `feat:`, the next version will increment the semver `MINOR` value
   - If a commit exists with a message beginning with *any* `type` with a `!` appended, the next version will increment the semver `MAJOR` value
     - Other formats are accepted to denote a `BREAKING CHANGE`, reference the [`conventionalcommits`](https://www.conventionalcommits.org) specification
5. Update `CHANGELOG.md` with sections based on `conventionalcommits` types
6. Use the `@release-it/bumper` plugin to update the `galaxy.yml` and `operator-config.yaml` files' `version` field
7. Set the unique `namespace`, `domain`, and `name` values in `galaxy.yml` and `operator-config.yaml`
8. Create and push a new git `tag` and `commit`
9. Run the `ansible-galaxy collection build` to create a newly version archive (asset)
10. Create a new Github Release, append the changelog and created archive as an asset