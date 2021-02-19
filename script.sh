EKSCTL='https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz' 
KUBECTL_VER="`(curl -L -s https://dl.k8s.io/release/stable.txt)`" 
KUBECTL="https://dl.k8s.io/release/v1.20.2/bin/linux/amd64/kubectl" 
HELM="https://get.helm.sh/helm-v3.5.2-linux-amd64.tar.gz" 
TERRAFORM="https://releases.hashicorp.com/terraform/0.14.6/terraform_0.14.6_linux_amd64.zip" 
SAMURL="https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" 
AWSCLI2="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"

curl --silent -LO ""$KUBECTL"" \
&& chmod +x ./kubectl && mv -v ./kubectl /usr/local/bin/kubectl \
&& curl --silent --location ""$HELM"" | tar xz -C /tmp \
&& mv -v /tmp/linux-amd64/helm /usr/local/bin/helm \
&& curl --silent -LO ""$TERRAFORM"" \
&& unzip terraform_0.14.6_linux_amd64.zip \
&& chmod +x ./terraform && mv -v ./terraform /usr/local/bin/terraform \
&& curl "$AWSCLI2" -o "awscliv2.zip" \
&& unzip awscliv2.zip && ./aws/install --update\
&& curl --silent -LO "$SAMURL" -o "aws-sam-cli-linux-x86_64.zip" \
&& unzip aws-sam-cli-linux-x86_64.zip -d sam-installation && ./sam-installation/install \
&& echo "source /etc/bash_completion" > ~/.bashrc \
&& echo "complete -C '/usr/local/bin//aws_completer' aws" >> ~/.bashrc \
&& eksctl completion bash >> ~/.bash_completion \
&& echo 'source <(kubectl completion bash)' >>~/.bashrc \
&& echo 'source <(helm completion bash)' >>~/.bashrc \
&& terraform -install-autocomplete
