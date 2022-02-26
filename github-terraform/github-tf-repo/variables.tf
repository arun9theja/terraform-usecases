variable "repo_names" {
  description = "Create github repos with these names"
  type        = list(string)
  default     = ["github-tf", "docker-tf", "aws-tf"]
}