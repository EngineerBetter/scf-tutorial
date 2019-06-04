FROM gcr.io/cloudshell-images/cloudshell

RUN mkdir -p /var/tutorial

COPY kube.config /var/tutorial/kube.config

RUN chmod -R 755 /var/tutorial

RUN echo 'KUBECONFIG=/var/tutorial/kube.config' >> /etc/environment

RUN curl -L "https://packages.cloudfoundry.org/stable?release=linux64-binary&source=github" | tar -zx && \
  mv cf /usr/local/bin && \
  chmod +x /usr/local/bin/cf && \
  cf --version
