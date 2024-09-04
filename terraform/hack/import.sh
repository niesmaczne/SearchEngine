#!/usr/bin/env bash

export GITHUB_TOKEN="$(gh auth token)"

TF="${TF:-tofu}"

"${TF}" import github_repository.SearchEngine                                   SearchEngine

"${TF}" import github_issue_labels.SearchEngine                                 SearchEngine

"${TF}" import github_branch_protection.SearchEngine                            SearchEngine:main
