FROM node:slim

RUN apt-get update
RUN apt-get install -y git

COPY "entrypoint.sh" "/entrypoint.sh"
ENTRYPOINT ["/entrypoint.sh"]
