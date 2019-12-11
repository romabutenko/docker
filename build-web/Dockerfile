FROM node:lts-alpine as build-stage
WORKDIR /var/www/palantir/web/
COPY ./web ./
RUN npm install --production
#
#COPY ../web .
#RUN npm run build
#
## этап production (production-stage)
#FROM nginx:stable-alpine as production-stage
#COPY --from=build-stage /var/www/palantir/web/dist /usr/share/nginx/html
#EXPOSE 80
#CMD ["nginx", "-g", "daemon off;"]


#ARG STAGE=${STAGE}
#ARG PROJECT_NAME=${PROJECT_NAME}
#FROM ${PROJECT_NAME}/${STAGE}/builder:latest
#
#USER root
#
#ARG REPOSITORY
#ARG WEB_CODE_PATH_CONTAINER=/var/www/palantir/web
#
#RUN mkdir -p ${WEB_CODE_PATH_CONTAINER}
#
#RUN git clone ${WEB_REPO} ${WEB_CODE_PATH_CONTAINER}
#
#WORKDIR ${WEB_CODE_PATH_CONTAINER}
#
#RUN npm install && \
#    npm run build
#
#WORKDIR ${WEB_CODE_PATH_CONTAINER}