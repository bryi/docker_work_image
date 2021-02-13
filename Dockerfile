FROM debian AS compile-image

RUN apt-get update \
&& apt-get install -y --no-install-recommends python3 python3-pip python3-setuptools\
&& pip3 install --upgrade pip \
&& apt-get clean autoclean \
&& apt-get autoremove --yes \
&& rm -rf /var/lib/{apt,dpkg,cache,log}/

COPY requirements.txt .

RUN pip3 install --user -r requirements.txt

FROM debian AS build-image

COPY --from=compile-image /root/.local /root/.local

ENV EKSCTL='https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz' \
    KUBECTL_VER="`(curl -L -s https://dl.k8s.io/release/stable.txt)`" \
    KUBECTL="https://dl.k8s.io/release/v1.20.2/bin/linux/amd64/kubectl" \
    HELM="https://get.helm.sh/helm-v3.5.2-linux-amd64.tar.gz" \
    TERRAFORM="https://releases.hashicorp.com/terraform/0.14.6/terraform_0.14.6_linux_amd64.zip"

RUN apt-get update && apt-get clean autoclean \
&& apt-get install -y --no-install-recommends python3 python3-pip python3-setuptools bash nano bash-completion git wget gzip unzip tar curl ca-certificates\
&& apt-get autoremove --yes \
&& rm -rf /var/lib/{apt,dpkg,cache,log}/ \
&& curl --silent --location ""$EKSCTL"" | tar xz -C /tmp \
&& mv -v /tmp/eksctl /usr/local/bin \
&& curl --silent -LO ""$KUBECTL"" \
&& chmod +x ./kubectl && mv -v ./kubectl /usr/local/bin/kubectl \
&& curl --silent --location ""$HELM"" | tar xz -C /tmp \
&& mv -v /tmp/linux-amd64/helm /usr/local/bin/helm \
&& curl --silent -LO ""$TERRAFORM"" \
&& unzip terraform_0.14.6_linux_amd64.zip \
&& chmod +x ./terraform && mv -v ./terraform /usr/local/bin/terraform \
&& apt-get clean autoclean \
&& apt-get autoremove --yes \
&& rm -rf /var/lib/{apt,dpkg,cache,log}/ \
&& mkdir -p /home/workdir

RUN echo "source /etc/bash_completion" > ~/.bashrc \
&& echo "complete -C '/root/.local/bin//aws_completer' aws" >> ~/.bashrc \
&& eksctl completion bash >> ~/.bash_completion \
&& echo 'source <(kubectl completion bash)' >>~/.bashrc \
&& echo 'source <(helm completion bash)' >>~/.bashrc \
&& terraform -install-autocomplete

ENV PATH=$PATH:/root/.local/:/root/.local/bin

WORKDIR /home/workdir

CMD ["bash"]