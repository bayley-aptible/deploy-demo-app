# Dockerfile
FROM python:3.5

# PostgreSQL dev headers and client (uncomment if you use PostgreSQL)
#RUN apt-install libpq-dev postgresql-client-9.3 postgresql-contrib-9.3

# Add requirements.txt ONLY, then run pip install, so that Docker cache won't
# bust when changes are made to other repo files
ADD requirements.txt /app/
WORKDIR /app
RUN pip install -r requirements.txt

# Add repo contents to image
ADD app/ /app/

ENV PORT 5000
EXPOSE 5000

CMD ["honcho", "start", "-f", "/app/honcho.cnf"]

# Assume that you've already ADDed your repo:
ADD . /app
WORKDIR /app

# The bundle exec rake assets:precompile command
# will run with your configuration
RUN set -a && . /app/.aptible.env && \
        bundle exec rake assets:precompile

RUN mkdir /root/.ssh/
RUN set -a && . .aptible.env && echo "$BAYLEY_TEST" > /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa