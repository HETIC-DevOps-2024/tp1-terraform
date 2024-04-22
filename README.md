# Terraform Workshop

## Preambule

La suite de ce workshop/TP est ecrite en anglais, je ne l'ai pas copiee d'internet, ce n'est pas ChatGPT qui l'a generee.

C'est un choix delibere, car dans le monde du travail, vous serez amenes a lire et ecrire de la documentation technique en anglais.

Le documentation de Terraform que ce TP va vous faire utiliser a outrance est egalement disponible en anglais.

La plupart des resources que vous trouverez pour vous aider (Issues GitHub, Forums terraform, Slacks...) sont egalement en anglais.

:warning: Se limiter aux resources en francais c'est brider votre connaissance a une fraction infime de ce qui est disponible.

Essayez de jouer le jeu, ne copiez collez pas betement dans ChatGPT ou Google Translate, ca ne traduira que les mots, pas mes intentions.

Si l'anglais est vraiment un probleme insurmontable, alors demandez moi et je vous ecrirais les instructions en francais.

## Introduction

This workshop is intended to students of HETIC.

In this workshop you will:
  - Install Terraform CLI on your machine
  - Create a PAT (Personal access token)
  - Create a GitHub repo using Terraform
  - Learn how to read documentation
  - Fall into a few traps
  - Get out of the traps
  - Learn how to avoid falling into traps

## Step 1 - Install Terraform

Follow the [official instructions](https://developer.hashicorp.com/terraform/install) on how to install Terraform for your specific platform.

## Step 2 - Create a GitHub PAT

In order for Terraform to use your GitHub account as a provider, you need to provide it with some form of programatic access.

There are multiple ways of doing this, but the Personal Access Token (PAT) is the one that you will generally use in a real job.

Go to the [Settings page](https://github.com/settings/profile) (top right profile icon, then click on settings).

Click on [Developer settings](https://github.com/settings/apps) at the bottom.

Click on Personal access tokens, then [Tokens (classic)](https://github.com/settings/tokens)

Finally click on [Generate new token (classic)](https://github.com/settings/tokens/new)

:warning: GitHub really wants you to create newer Fine-grained access tokens but today is not a security course.

Fill in the details:

Token name: `tp1-terraform`

Expiration: up to you

Select scopes: select 
  - `repo` and it will automatically select all sub options too, grants full access to all repos
  - `read:org` to allow reading the global GitHub settings

Click on `Generate token`

:warning: The token will be displayed only once ! Immediately copy it to a safe place (password manager, or `passwords.txt` on your desktop...)

## Step 3 - Expose the GitHub PAT

For Terraform to be able to interact with GitHUb, we need to provide it our fresh PAT.

The easiest way is to export the new token as the `GITHUB_TOKEN` environment variable.

How do we know that ? I'm glad you asked, it's in the [GitHub provider documentation](https://registry.terraform.io/providers/integrations/github/latest/docs#oauth--personal-access-token) of course...

Now is a good time to get familiar with the Terraform documentation, you are going to use it quite a bit.

Linux / Mac: `export GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxx`

Windows: `SET GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxx`

:warning: The environment variable is only available in your current terminal session, unless...

## Bonus 1 - Make it permanent

Linux / Mac: add the `export GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxx` command in your `~/.zshrc` or `~/.bashrc` file.

Windows: Press the windows key and search for `Environment Variables` In your personal environment variables, clickity click here and there, and add a new one called `GITHUB_TOKEN` with the value `ghp_xxxxxxxxxxxxxxxx`.

## Bonus 2 - Interact with GitHub using the CLI

Our PAT can be used for many things, including communicating with GitHub through the CLI tool they provide for automation.

You can try to use your PAT with the GitHub command line utility (CLI).

Install [GitHub CLI](https://github.com/cli/cli#installation) for your platform to automate interactions with GitHub.

Try out `gh repo list HETIC-DevOps-2024`.

## Challenge #1 - Create a GitHub repo

Objective: Create a GitHub repo that has the following configuration:
  - Repo is private
  - It does NOT allow rebase merge operations
  - Branches will be automatically deleted after a merge operation
  - It should NOT have
    - a Wiki
    - Projects
  - Should be initialized with
    - a commit
    - a `README.md` file
    - a `.gitignore` file setup for a Node.JS project
    - an `MIT` license
  - It should be archived instead of being deleted in case we make a mistake

Once the resource is created, I want terraform to show the clone URL of the repository in the console.

### Instructions

First of all, using `git`, clone this repository somewhere on your machine with the clone url `https://github.com/HETIC-DevOps-2024/tp1-terraform.git`.

You can use the command line or any other graphical tool.

Example: `git clone https://github.com/HETIC-DevOps-2024/tp1-terraform.git`

For this workshop, all you will need the official documentation for the [`github_repository`](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) resource.

This is the only resource we will be using for this challenge.

First in your terminal navigate inside the repository that you just cloned: `cd tp1-terraform`.

Inside you will find a few files, but the most important one for now is `repo.tf`.

All the definitions should go in the `repo.tf` file, inside of the resource block:

```hcl
resource "github_repository" "repo" {
    add things here
}
```

First of all, you will have to run `terraform init` to initialize terraform with the GitHub provider.

You will have to run `terraform plan`, `terraform apply` and `terraform destroy` multiple times turing the process.

You will also need an `output` block to display the clone URL.

### Hint #1

Use an alias to make typing faster:

Linux / Mac: `alias t='terraform'`, then use `t apply`

Windows users: Sorry, you will have to type the whole word.

### Hint #2

Use the flag `-auto-approve` to avoid having to type `yes` every time you `apply` or `destroy`.

### :warning: Trap #1

When running `destroy` you will likely run into a problem, or maybe more than one problem, do you have an idea what it could be ?

## Optional challenge #1 - Variable repo name

Objective: The repo name should be configurable to create multiple repos with the same configuration.

I want to be able to run the following commands to create multiple repos:

```bash
terraform apply -var repo_name=test-repo1 -auto-approve
terraform apply -var repo_name=test-repo2 -auto-approve
terraform apply -var repo_name=test-repo3 -auto-approve
...
```

Can this work ?

### :warning: Trap 2

This might work, but not as expect... do you have an idea why ?

Maybe it was not a good idea after all, let's rename the variable to repo_description and use it to configure the description instead.

Let's give it a default value so we don't have to specify `-var repo_description=something` every time.

## Challenge #2: Change the default branch

Change the default branch of the repo to `hetic`. Sounds simple, right ?

### Instructions

For this, you might need other resources that you haven't used yet.

You can create more resources blocks in the same `repo.tf` file.

Terraform is smart enough to resolve resources dependencies (most of the time).

### Hint #1

Browse the documentation, searh bar on the left column.

Maybe use the `hashicorp.terraform` extension with VSCode, it can give you some ideas. Some way it can even read your mind...

## Optional Warrior Challenge #2 - Add branch protection

I want to add branch protection on the `hetic` branch to:
  - Enforce signed commits
  - Enforce PRs to have 2 reviews before they can be merged
  - Prevent people to force push

### Instructions

You're on your own this time...

You might have to change things up...

## Optional Curiosity Challenge

What do we need to do to convert our code to be compatible with [OpenTofu](https://opentofu.org/) ?

## Cleanup

Once the workshop over, delete the repo(s) that were created during the workshop, and remove the Personal Access Token from the [Tokens (classic) list](https://github.com/settings/tokens).