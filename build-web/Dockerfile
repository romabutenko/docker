ARG CONTEXT=local
ARG COMPOSE_PROJECT_NAME=palantir
FROM ${COMPOSE_PROJECT_NAME}/${CONTEXT}/builder:latest

USER root

ARG WEB_REPO=https://romabutenko@bitbucket.org/romabutenko/web.git
ARG WEB_CONTAINER_PATH=/var/www/palantir/web

RUN mkdir -p ${WEB_CONTAINER_PATH}

RUN git clone https://romabutenko@bitbucket.org/romabutenko/web.git ${WEB_CONTAINER_PATH}

WORKDIR ${WEB_CONTAINER_PATH}

RUN npm install
RUN npm run build:prod

#FROM node:lts-alpine as build-stage
#WORKDIR /var/www/palantir/web/
#COPY ./web ./
#RUN npm install --production
#
#COPY ../web .
#RUN npm run build
#
## этап production (production-stage)
#FROM nginx:stable-alpine as production-stage
#COPY --from=build-stage /var/www/palantir/web/dist /usr/share/nginx/html
#EXPOSE 80
#CMD ["nginx", "-g", "daemon off;"]
