# Fetch latest changes from Github
FROM alpine/git:latest as repo
RUN git clone -b master --depth 1 https://github.com/alseambusher/crontab-ui.git /crontab-ui

# Build Image
FROM node:alpine
ENV CRON_PATH /etc/crontabs
RUN touch $CRON_PATH/root; chmod +x $CRON_PATH/root
RUN apk --no-cache add wget curl supervisor tzdata

WORKDIR /crontab-ui

COPY --from=repo --chown=1000:1000 /crontab-ui/supervisord.conf /etc/supervisord.conf
COPY --from=repo --chown=1000:1000 /crontab-ui /crontab-ui

RUN npm --verbose install --no-optional

ENV   HOST 0.0.0.0

ENV   CRON_IN_DOCKER true

EXPOSE 8000/tcp

CMD ["supervisord", "-c", "/etc/supervisord.conf"]