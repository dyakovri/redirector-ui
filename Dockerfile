FROM node:16 AS build
WORKDIR /app
ADD . /app
RUN npm install && npm run build

FROM nginx
COPY ./default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
