terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

provider "github" {
  token = "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"      # Provide here your Git Hub Personal Access Token generated from Github --> Settings --> Developer Settings"
}
