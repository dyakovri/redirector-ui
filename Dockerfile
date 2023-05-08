FROM node:18 AS build
ARG API_ROOT
WORKDIR /app
ADD ./package.json ./pnpm-lock.yaml /app/
RUN npm i -g pnpm && pnpm install
ADD . /app
RUN echo VUE_APP_API_ROOT=${API_ROOT} > /app/.env
RUN pnpm run build

FROM nginx:1.23
LABEL org.opencontainers.image.source = "https://github.com/dyakovri/redirector-ui"
ADD ./default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
