FROM ubuntu:20.04 AS stage1

RUN apt-get update \
 && apt-get install -y build-essential

WORKDIR /src
COPY pause.c pause.c
RUN gcc -static pause.c -o /pause

FROM ubuntu:20.04

ARG BUILD_DATE
ARG VCS_REF
LABEL maintainer="James Hunt <images@huntprod.com>" \
      summary="A jumpbox for settling in at home, away from home" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/filefrog/jumpbox.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0"

COPY --from=stage1 /pause /usr/bin/pause
CMD [pause]

ARG bbr_version
ARG bosh_version
ARG boss_version
ARG cf_version
ARG credhub_version
ARG fly_version
ARG genesis_version
ARG gotcha_version
ARG jq_version
ARG kubectl_version
ARG osb_version
ARG s3_version
ARG safe_version
ARG shield_version
ARG spruce_version
ARG terraform_version
ARG vault_version

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
      curl wget \
      vim-nox nano \
      build-essential \
      iproute2 iputils-ping iputils-tracepath dnsutils net-tools \
      nmap mtr tcpdump ipgrab tshark iptraf-ng \
      nmap mtr tcpdump ipgrab tshark iptraf-ng \
      netcat netrw cryptcat \
      rsync \
      git \
      tmux tmate screen \
      tree file \
      bzip2 zip unzip \
      lsof \
      htop \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 \
 && echo "Installing 'bbr' v${bbr_version}" \
 &&   curl -sLo /usr/bin/bbr https://github.com/cloudfoundry-incubator/bosh-backup-and-restore/releases/download/v${bbr_version}/bbr-${bbr_version}-linux-amd64 \
 &&   chmod 0755 /usr/bin/bbr \
 &&   /usr/bin/bbr -v \
 \
 && echo "Installing 'bosh' v${bosh_version}" \
 &&   curl -sLo /usr/bin/bosh https://github.com/cloudfoundry/bosh-cli/releases/download/v${bosh_version}/bosh-cli-${bosh_version}-linux-amd64 \
 &&   chmod 0755 /usr/bin/bosh \
 &&   /usr/bin/bosh -v \
 \
 && echo "Installing 'cf' v${cf_version}" \
 &&   curl -sLo cf.tar.gz "https://packages.cloudfoundry.org/stable?release=linux64-binary&version=${cf_version}" \
 &&   tar -xzf cf.tar.gz \
 &&   mv cf /usr/bin/cf \
 &&   chmod 0755 ./usr/bin/cf \
 &&   rm -f cf.tar.gz \
 &&   /usr/bin/cf --version \
 \
 && echo "Installing 'credhub' v${credhub_version}" \
 &&   curl -sLo credhub.tar.gz https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/${credhub_version}/credhub-linux-${credhub_version}.tgz \
 &&   tar -xzf credhub.tar.gz \
 &&   mv credhub /usr/bin/credhub \
 &&   chmod 0755 /usr/bin/credhub \
 &&   rm -f credhub.tar.gz \
 &&   /usr/bin/credhub --version \
 \
 && echo "Installing 'fly v${fly_version}'" \
 &&   curl -sLo fly.tar.gz https://github.com/concourse/concourse/releases/download/v${fly_version}/fly-${fly_version}-linux-amd64.tgz \
 &&   tar -xzf fly.tar.gz \
 &&   mv fly /usr/bin/fly \
 &&   chmod 0755 /usr/bin/fly \
 &&   rm -f fly.tar.gz \
 &&   /usr/bin/fly -v \
 \
 && echo "Installing 'jq' ${jq_version}" \
 &&   curl -sLo /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-${jq_version}/jq-linux64 \
 &&   chmod 0755 /usr/bin/jq \
 &&   /usr/bin/jq --version \
 \
 && echo "Installing 'kubectl' v${kubectl_version}" \
 &&   curl -sLo /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${kubectl_version}/bin/linux/amd64/kubectl \
 &&   chmod 0755 /usr/bin/kubectl \
 &&   /usr/bin/kubectl version --client \
 \
 && echo "Installing 'safe' v${safe_version}" \
 &&   curl -sLo /usr/bin/safe https://github.com/starkandwayne/safe/releases/download/v${safe_version}/safe-linux-amd64 \
 &&   chmod 0755 /usr/bin/safe \
 &&   /usr/bin/safe -v \
 \
 && echo "Installing 'spruce' v${spruce_version}" \
 &&   curl -sLo /usr/bin/spruce https://github.com/geofffranks/spruce/releases/download/v${spruce_version}/spruce-linux-amd64 \
 &&   chmod 0755 /usr/bin/spruce \
 &&   /usr/bin/spruce -v \
 \
 && echo "Installing 'terraform' v${terraform_version}" \
 &&   curl -sLo terraform.zip https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip \
 &&   unzip -q terraform.zip \
 &&   mv terraform /usr/bin/terraform \
 &&   chmod 0755 /usr/bin/terraform \
 &&   rm terraform.zip \
 &&   /usr/bin/terraform -v \
 \
 && echo "Installing 'vault' v${vault_version}" \
 &&   curl -sLo vault.zip https://releases.hashicorp.com/vault/${vault_version}/vault_${vault_version}_linux_amd64.zip \
 &&   unzip -q vault.zip \
 &&   mv vault /usr/bin/vault \
 &&   chmod 0755 /usr/bin/vault \
 &&   rm vault.zip \
 &&   /usr/bin/vault -v \
 \
 && echo "Installing 'genesis' ${genesis_version}" \
 &&   curl -sLo /usr/bin/genesis https://github.com/genesis-community/genesis/releases/download/v${genesis_version}/genesis \
 &&   chmod 0755 /usr/bin/genesis \
 &&   /usr/bin/genesis -v \
 \
 && echo "Installing 'botherhub'" \
 &&   curl -sLo /usr/bin/botherhub https://raw.githubusercontent.com/jhunt/botherhub/master/botherhub \
 &&   chmod 0755 /usr/bin/botherhub \
 \
 && echo "Installing 's3' ${s3_version}" \
 &&   curl -sLo /usr/bin/s3 https://github.com/jhunt/s3/releases/download/v${s3_version}/s3-linux-amd64 \
 &&   chmod 0755 /usr/bin/s3 \
 &&   /usr/bin/s3 -v \
 \
 && echo "Installing 'osb' ${osb_version}" \
 &&   curl -sLo /usr/bin/osb https://github.com/jhunt/osb/releases/download/v${osb_version}/osb-linux-amd64 \
 &&   chmod 0755 /usr/bin/osb \
 &&   /usr/bin/osb -v \
 \
 && echo "Installing 'boss' ${boss_version}" \
 &&   curl -sLo /usr/bin/boss https://github.com/jhunt/boss/releases/download/v${boss_version}/boss-linux-amd64 \
 &&   chmod 0755 /usr/bin/boss \
 &&   /usr/bin/boss -v \
 \
 && echo "Installing 'gotcha' ${gotcha_version}" \
 &&   curl -sLo /usr/bin/gotcha https://github.com/starkandwayne/gotcha/releases/download/v${gotcha_version}/gotcha-linux-amd64 \
 &&   chmod 0755 /usr/bin/gotcha \
 &&   /usr/bin/gotcha -v \
 \
 && echo "Installing 'shield' ${shield_version}" \
 &&   curl -sLo /usr/bin/shield https://github.com/shieldproject/shield/releases/download/v${shield_version}/shield-linux-amd64 \
 &&   chmod 0755 /usr/bin/shield \
 &&   /usr/bin/shield -v \
 \
 && echo "DONE"
