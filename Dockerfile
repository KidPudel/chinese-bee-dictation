# build stage (pre-requisite)
FROM node:21.6.1-alpine AS build-stage

ENV NODE_ENV=production

WORKDIR /app

# cache dependencies (what won't change often)
COPY package*.json ./

RUN npm install --include=dev

COPY . .


# build an application
RUN npm run build

# serve stage
FROM nginx:stable-alpine AS production-stage

# where dist is where build static files are located
COPY --from=build-stage /app/dist /usr/share/nginx/html

# expose the port that railway will use
EXPOSE ${PORT}
CMD ["sh", "-c", "envsubst '${PORT}' < etc/nginx/conf.d/default.conf.template > etc/nginx/conf.d/default/conf && nginx -g 'daemon off;'"]