#!/usr/bin/env bash

export GITHUB_TOKEN="$(gh auth token)"

TF="${TF:-tofu}"

"${TF}" apply
