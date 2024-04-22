resource "github_repository" "repo" {
  # name                   = var.repo_name
  name                   = "test-repo"
  description            = var.repo_description
  # Challenge #1
  visibility             = "private"  # Repo is private
  #
  # Optional Warrior Challenge #2 
  # visibility             = "public"
  allow_rebase_merge     = false      # It does NOT allow rebase merge operations
  delete_branch_on_merge = true       # Branches will be automatically deleted after a merge operation
  has_wiki               = false      # It should NOT have a wiki
  has_projects           = false      # It should NOT have projects
  auto_init              = true       # Should be initialized with a README
  gitignore_template     = "Node"     # a `.gitignore` file setup for a Node.JS project
  license_template       = "mit"      # an `MIT` license
  # Trap #1
  # Will block terraform destroy completely
  # Good for prod, but disable it when setting things up
  # 
  # archive_on_destroy     = true
  #
  # Challenge #2 Trap: Deprecated ! RTFM
  # https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository#default_branch
  # It will work but not for long
  #
  # default_branch         = "WRONG!" 
}

# Challenge #2 Trap
# Wrong !
# The Ref doens't exist won't work
#
# resource "github_branch_default" "hetic" {
#   repository = github_repository.repo.name
#   branch     = "hetic"
# }

# Challenge #2
# Right !
# Create the branch first
#
# resource "github_branch" "hetic" {
#   repository = github_repository.repo.name
#   branch     = "hetic"
#   # source_branch needed if the default branch is not main
#   source_branch = "master"
# }

# Challenge #2
# Now set the default branch
#
# resource "github_branch_default" "default" {
#   repository = github_repository.repo.name
#   branch     = github_branch.hetic.branch
# }

# Branch protection doesn't work on private repos unless you 
# give GitHub the $$$. Turn the repo public to allow it
# Optional Warrior Challenge #2
#
# resource "github_branch_protection" "hetic" {
#   repository_id          = github_repository.repo.name
#   pattern                = github_branch_default.default.branch
#   require_signed_commits = true
#   allows_force_pushes    = false

#   required_pull_request_reviews {
#     required_approving_review_count = 2
#   }
# }

output "clone_url" {
  value = github_repository.repo.ssh_clone_url
}

output "repo_id" {
  value = github_repository.repo.repo_id
}
