FROM gcr.io/cloudshell-images/cloudshell

RUN curl -L "https://packages.cloudfoundry.org/stable?release=linux64-binary&source=github" | tar -zx && \
  mv cf /usr/local/bin && \
  chmod +x /usr/local/bin/cf && \
  cf --version
