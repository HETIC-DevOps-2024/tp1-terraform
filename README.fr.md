# Terraform Workshop

## Introduction

Ce TP est a l'attention des etudiants HETIC.

Dans ce workshop vous allez
  - Installer terraform CLI sur votre machine
  - Creer un PAT (Personal access token)
  - Creer un repo GitHub en utilisant Terraform
  - Apprendre a lire de la documenation
  - Tomber dans des pieges
  - Sortir des pieges
  - Apprendre a eviter les pieges

## Step 1 - Installer Terraform

Suivre les [instructions officielles](https://developer.hashicorp.com/terraform/install) Pour votre platforme specifique.

## Step 2 - Create a GitHub PAT

Pour que Terraform puisse utiliser votre compte GitHub comme un provider, vous devez lui fournir une forme d'access programatique.

Il y'a plusieurs facon de le faire, mais le Personal Access Token (PAT) et le plus communement utilise en entreprise.

Aller dans les [Settings](https://github.com/settings/profile) (Icone de profile en haut a droite puis clicker sur settings).

Clicker sur [Developer settings](https://github.com/settings/apps) en bas.

Clicker sur Personal access tokens, puis [Tokens (classic)](https://github.com/settings/tokens)

Enfin clicker sur [Generate new token (classic)](https://github.com/settings/tokens/new)

:warning: GitHub veut vraiment vous faire creer un nouvea Fine-grained access tokens mais le cours d'aujourd'hui n'est pas un cours de securite, un simple suffira.

Remplir les details:

Token name: `tp1-terraform`

Expiration: a vous de choisir

Select scopes: select 
  - `repo` le cocher cochera aussi toutes les sous-cases. Donne un access total a tous les repos.
  - `read:org` autorise a lire les settings globaux GitHub

:warning: Eviter le piege #1: donner egalement `delete_repo` qui sera necessaire pour faire un `terraform destroy`.

Clicker sur `Generate token`

:warning: Le token ne sera affichq qu'une seule fois, stockez le dans un endroit sur (password manager, or `passwords.txt` sur votre bureau...)

## Step 3 - Exposer le PAT GitHub

Pour que Terraform puisse acceder a GitHub nous devons lui fournir le PAT fraichement cree.

Le plus simple est d'exporter le token comme variable d'environment `GITHUB_TOKEN`.

Comment est ce que je sais ca ? C'est ecrit dans la [documentation du provider GitHub](https://registry.terraform.io/providers/integrations/github/latest/docs#oauth--personal-access-token) bien sur...

C'est le bon moment de vous familiariser avec la documentation Terraform car vous allez beaucoup l'utiliser.

Linux / Mac: `export GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxx`

Windows `cmd`: `SET GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxx`
Windows `powershell`:  `$env:GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxx`

:warning: La variable d'environment sera disponible uniquement pour votre session courante, sauf...

## Bonus 1 - La rendre permanente

Linux / Mac: Ajouter `export GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxx` a la fin de votre fichier `~/.zshrc` or `~/.bashrc`.

Windows: Appuyer sur la touche Windows et chercher `Environment Variables` Dans vos variable d'environment personelles, Clicker sur ajouter puis ajouter `GITHUB_TOKEN` avec comme valeur votre token `ghp_xxxxxxxxxxxxxxxx`.

## Bonus 2 - Interagir avec GitHub en ligne de commande

Le PAT peut faire beaucoup de chose, comme communiquer avec GitHub en utilisant le CLI qu'ils fournissent pour automatiser les taches.

Vous pouvez essayer d'utiliser votre PAT avec `gh` CLI.

Installer [GitHub CLI](https://github.com/cli/cli#installation) pour votre platforme en suivant les instructions.

Essayez la commande `gh repo list HETIC-DevOps-2024` qui va vous lister le repo avec le TP1.

## Challenge #1 - Creer un repo GitHub

Objectif: Creer un repo GH avec la configuration suivante:
  - Le repo est prive
  - Il n'autorise pas de merge avec rebase
  - Les branches seront automatiquement supprimees apres un merge
  - Il ne doit PAS avoir
    - de Wiki
    - de Projects
  - Il doit etre initialise avec
    - un commit
    - un `README.md` (peu importe le contenu)
    - un `.gitignore` predefini pour Node.JS
    - une license `MIT`
  - Il devrait ere archive au lien d'etre detruit pour eviter de le supprimer par erreur

Une fois la resource cree, je souhaite que Terraform affiche un des URL utilisables pour cloner le repo.

### Instructions

D'abord en utilisant `git`, cloner ce repository sur votre machine avec l'URL `https://github.com/HETIC-DevOps-2024/tp1-terraform.git`.

Vous pouvez utiliser le command line ou n'importe quel autre outil.

Example: `git clone https://github.com/HETIC-DevOps-2024/tp1-terraform.git`

Pour ce workshop vous aurez besoin de la documentation officielle de la ressource [`github_repository`](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository).

C'est la seule resource dont nous auront besoin pour ce challenge.

Dans votre terminal navigues dans le repo que vous venez de cloner: `cd tp1-terraform`.

A l'interieur il y'a plusieurs fichiers, le plus important est `repo.tf`.

Toutes les definitions requises pour ce challenge iront dans le fichier `repo.tf`, a l'interieur de ce bloc ressource:

```hcl
resource "github_repository" "repo" {
    add things here
}
```

Tout d'abord lancez `terraform init` pour inotialiser Terraform avec le provider GitHub.

Vous allez lancer plusieurs fois `terraform plan`, `terraform apply` and `terraform destroy` pendant le processus.

Vous allez avoir besoin d'un bloc `output` pour affichier l'URL de clone.

### Astuce #1

Utiliser un alias pour ne pas avoir a taper terraform a chaque fois:

Linux / Mac: `alias t='terraform'`, puis taper `t apply`

Windows users: Desole, pas d'alias pour vous.

### Astuce #2

Utilisez le flag `-auto-approve` pour eviter de devoir taper `yes` a chaque `apply` or `destroy`.

### :warning: Piege #1

Quand vous allez lancer `destroy` vous allez sans doute vous confronter a un problem, peut etre meme plus qu'un, avez vous une idee de ce que ca peut etre ? (Reponses sur le discord !)

## Challenge Optionnel #1 - Le nom du repo Variable

Objectif: Je souhaite que le nom du repo soit configurable avec une variable.

Je veux pouvoir creer plusieurs repos en lancant les commandes suivantes:

```bash
terraform apply -var repo_name=test-repo1 -auto-approve
terraform apply -var repo_name=test-repo2 -auto-approve
terraform apply -var repo_name=test-repo3 -auto-approve
...
```

Est ce que ca peut fonctionner comme je le souhaite ?

### :warning: Piege 2

Peut etre que ca marchera (sans renvoyer d'erreurs), mais pas comme prevu... avez vous une idee de ce qui se passe ?

Peut etre ce n'est pas une bonne idee, renommez la variable en `repo_description` et utilisons la pour configurer la description a la place.

Donnez lui une valeur par defaut pour ne pas avoir a taper `-var repo_description=something` a chaque fois.

## Challenge #2: Changer la default branch

Changer la branche par defaut du repo pour une branche qui s'appelle `hetic`. Ca doit etre simple non ?

### Instructions

Pour ce challenge il faudra d'autres ressources que vous n'avez pas encore utilise.

Vous pouvez creer plusieurs blocs resource. dans le fichier `repo.tf`.

La plupart du temps, terraform est assez malin pour resoudre lui meme les rependances entre les resources.

### Astuce #1

Naviguez dans la documentation, la barre de recherche est dans la colonne du menu de gauche.

Utilisez l'extension VSCode `hashicorp.terraform` elle pourra vous donner des idees. Certains disent qu'elle peut meme lire vos pensees...

## Challenge Guerrier Optionnel #2 - Ajouter de la protection de branche

Je souhaite proteger la branche `hetic` pour:
  - s'assurer que les commits sont toujours signes
  - que les PR ait au moins toujours 2 reviews avant d'etre merge
  - que personne ne puisse force push

### Instructions

Cette fois vous etes tout seul...

Il faudra surement changer certaines choses que vous avez deja faites...

## Challenge Curiosite

Que devons nous faire pour convertir notre code pour etre compatible avec [OpenTofu](https://opentofu.org/) ?

## Nettoyage

Une fois le TP termine, supprimez le ou les repos que vous avez cree pendant le TP, ainsi que le Personal Access Token de la [liste des tokens (classic)](https://github.com/settings/tokens).