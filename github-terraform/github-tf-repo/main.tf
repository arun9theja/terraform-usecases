resource "github_repository" "cnl-github" {
  count       = length(var.repo_names)
  name        = var.repo_names[count.index]
  description = "Testing terraform github integrations"

  visibility = "public"
}