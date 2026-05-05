# Switched from ubuntu:questing-20251217 to alpine:3.19 because GitHub-hosted
# runners repeatedly fail to reach apt mirrors during container build:
#  - launchpad.net (when the old ppa:git-core/ppa was used)
#  - archive.ubuntu.com (questing-updates InRelease, after dropping the PPA)
# Alpine's apk fetches from dl-cdn.alpinelinux.org which is CDN-fronted and
# has been far more reliable from GHA runner egress. All three required
# tools (git, github-cli, jq) plus bash are in alpine main+community repos,
# so the install collapses to a single apk call.
FROM alpine:3.19

# entrypoint.sh has #!/usr/bin/env bash and uses [[ ]], arrays, herestrings;
# alpine ships with busybox sh by default, so we install bash explicitly.
# ca-certificates is needed by gh for HTTPS to api.github.com.
RUN apk add --no-cache \
      bash \
      ca-certificates \
      git \
      github-cli \
      jq

# Copy entrypoint after package install so package-cache layer is reusable
# across entrypoint.sh edits.
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /github/workspace
# GitHub Actions docker container actions must run as root: the runner mounts
# /github/workspace with root-owned files and the entrypoint needs to read /
# write that volume and run git operations on it.
# nosemgrep: dockerfile.security.missing-user-entrypoint.missing-user-entrypoint
ENTRYPOINT ["/entrypoint.sh"]
