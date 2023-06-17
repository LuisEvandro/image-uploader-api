FROM node:18-alpine as base
# Install dependences
RUN apk add --update --no-cache openssl1.1-compat
RUN apk add --no-cache git python3 gcc make libc-dev libgcc libstdc++ g++ build-base openssl1.1-compat && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN apk add --no-cache --upgrade bash terraform
RUN pip3 install --no-cache --upgrade pip setuptools
RUN pip3 install awscli
WORKDIR /app

FROM base as default
WORKDIR /app
COPY ["package.json", "./"]
COPY aplication_init.sh .
RUN chmod +x aplication_init.sh

FROM default as dev
WORKDIR /app
RUN npm install

# CI layer
FROM dev as ci
WORKDIR /app/
COPY . .

# Local layer
FROM base as local
WORKDIR /app/
COPY --from=ci /app/ .
COPY --from=dev /app/node_modules node_modules/
EXPOSE 3030
CMD ["./aplication_init.sh"]
