FROM node:18 AS build
WORKDIR /app
ADD ./package.json ./pnpm-lock.yaml /app/
RUN npm i -g pnpm && pnpm install
ADD . /app
RUN pnpm run build

FROM nginx:1.23
LABEL org.opencontainers.image.source = "https://github.com/dyakovri/redirector-ui"
ADD ./default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
