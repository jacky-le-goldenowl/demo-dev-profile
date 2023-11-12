FROM ruby:3.1.2

ARG RAILS_MASTER_KEY

ENV RACK_ENV=production
ENV RAILS_ENV=production
ENV NODE_ENV=production

RUN apt-get update && \
    apt-get install apt-utils && \
    apt-get install -y cmake pkg-config

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs
RUN npm install --global yarn

# install cron
RUN apt-get install -y cron

# install ffmpeg & poppler
RUN apt-get install -y --no-install-recommends \
    ffmpeg \
    poppler-utils

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock /app/
COPY ./config/database.yml.sample /app/config/database.yml

RUN bundle config --local without 'development:test' && \
    bundle install --jobs 4 --retry 3 && \
    bundle clean --force && \
    rm -rf /usr/local/bundle/cache/*.gem && \
    find /usr/local/bundle/gems/ -name "*.c" -delete && \
    find /usr/local/bundle/gems/ -name "*.o" -delete

RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["docker/entrypoint.sh"]

EXPOSE 3000

CMD rails s -p 3000 -b 0.0.0.0
