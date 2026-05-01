FROM ubuntu:questing-20251217

# Disable interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Copy all needed files
COPY entrypoint.sh /

# Install needed packages.
# Ubuntu 25.10 (questing) already ships a recent git (>=2.50), so the
# git-core PPA on Launchpad is no longer needed — dropping it removes
# a third-party network dependency at build time and avoids a known
# Launchpad-connectivity flake on GitHub-hosted runners.
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]
# hadolint ignore=DL3008
RUN chmod +x /entrypoint.sh ;\
  apt-get update -y ;\
  apt-get install --no-install-recommends -y \
    curl \
    ca-certificates ;\
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg ;\
  chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg ;\
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null ;\
  apt-get update -y ;\
  apt-get install --no-install-recommends -y \
    git \
    gh \
    jq ;\
  apt-get clean ;\
  rm -rf /var/lib/apt/lists/*

# Finish up
WORKDIR /github/workspace
ENTRYPOINT ["/entrypoint.sh"]
