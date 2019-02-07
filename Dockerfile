FROM linuxbrew/alpine

RUN brew upgrade
RUN brew update
RUN brew tap aws/tap
RUN brew install aws-sam-cli

ENV PORT 3001
ENV PATH="/root/.local/bin:/home/linuxbrew/.linuxbrew/bin:$PATH"
ENV DIR ""
ENV EXTRA_PARAMS ""

VOLUME /app

EXPOSE $PORT

WORKDIR /app

RUN sam --version
USER root
ENTRYPOINT sam local start-api -p $PORT --host 0.0.0.0 $EXTRA_PARAMS --docker-volume-basedir $DIR -n /app/lambda-env.json

# DIR needs to be the project root ON THE HOST

# SAM Requires access to docker itself.
# To make this work, you need 2 things:
#  - Run the container in privileged mode (`--privileged`)
#  - Attach /var/run/docker.sock to /var/run/docker.sock (`-v /var/run/docker.sock:/var/run/docker.sock`)
