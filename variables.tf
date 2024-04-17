# Optional Challenge 1
# And Trap 2
# Terraform keeps the state, changing the name of the repo only renames it
# because the name of the terraform resource "repo" is the same
# Optional challenge 1 cannot be completed
#
variable "repo_description" {
  type = string
  default = "A simple demo repo"
}