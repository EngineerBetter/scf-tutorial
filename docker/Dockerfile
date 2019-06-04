FROM gcr.io/cloudshell-images/cloudshell

RUN mkdir /var/tutorial
# Student service account kubeconfig
COPY kube.config /var/tutorial/kube.config
RUN chmod -R 755 /var/tutorial

# Make env var available in Google Cloud Shell
RUN echo "$KUBECONFIG=/var/tutorial/kube.config" >> /etc/environment

RUN curl -L "https://packages.cloudfoundry.org/stable?release=linux64-binary&source=github" | tar -zx && \
  mv cf /usr/local/bin && \
  chmod +x /usr/local/bin/cf && \
  cf --version
