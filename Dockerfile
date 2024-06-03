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

# set nginx configuration
COPY default.config /etc/nginx/conf.d/default.config

# where dist is where build static files are located
COPY --from=build-stage /app/dist usr/share/nginx/html

# expose the port that railway will use
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]