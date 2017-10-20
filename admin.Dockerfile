FROM groovy:latest

MAINTAINER hunterm@liatrio.com

COPY resources/api /home/groovy/api

USER root

RUN chmod +x /home/groovy/api/provision.sh

USER groovy

WORKDIR /home/groovy/api

CMD ["./provision.sh"]
