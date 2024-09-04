##########################################################################################
# SearchEngine - https://github.com/niesmaczne/SearchEngine
##########################################################################################

resource "github_repository" "SearchEngine" {
  name               = "SearchEngine"
  archive_on_destroy = true

  visibility      = "public"
  has_issues      = true
  has_discussions = false
  has_projects    = true
  has_wiki        = false

  allow_merge_commit = false
  allow_squash_merge = true
  allow_rebase_merge = false
  allow_auto_merge   = true

  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "PR_BODY"

  delete_branch_on_merge = true

  web_commit_signoff_required = true
  auto_init                   = false

  topics = [
    "python",
    "go",
    "kubernetes",
    "docker",
    "terraform",
  ]

  vulnerability_alerts                    = true
  ignore_vulnerability_alerts_during_read = true

  allow_update_branch = true
}

resource "github_branch_protection" "SearchEngine" {
  depends_on = [
    github_repository.SearchEngine,
  ]

  repository_id = github_repository.SearchEngine.node_id

  pattern                         = "main"
  enforce_admins                  = false
  require_signed_commits          = true
  required_linear_history         = true
  require_conversation_resolution = true

  required_status_checks {
    strict = true
    contexts = []
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    restrict_dismissals             = false
    require_code_owner_reviews      = false
    required_approving_review_count = 0
    require_last_push_approval      = false
  }

  allows_deletions    = false
  allows_force_pushes = false
}

resource "github_issue_labels" "SearchEngine" {
  depends_on = [
    github_repository.SearchEngine,
  ]

  repository = github_repository.SearchEngine.name

  label {
    name        = "feature"
    color       = "f88379"
    description = "Issues or PRs related to new features."
  }

  label {
    name        = "docs"
    color       = "795659"
    description = "Issues related to documentation updates or improvements."
  }

  label {
    name        = "bug"
    color       = "ff2c2c"
    description = "Categorizes issue or PR as related to a bug."
  }

  label {
    name        = "fix"
    color       = "00008B"
    description = "Improvement or fix."
  }

  label {
    name        = "wontfix"
    color       = "ffffff"
    description = "This will not be worked on."
  }

  label {
    name        = "P1"
    color       = "780606"
    description = "Critical change."
  }

  label {
    name        = "P2"
    color       = "ffa500"
    description = "Significant change."
  }

  label {
    name        = "P3"
    color       = "008000"
    description = "Valuable change."
  }

  label {
    name        = "P4"
    color       = "43A6C6"
    description = "Optional change."
  }
}
