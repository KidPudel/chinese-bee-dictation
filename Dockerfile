# build stage (pre-requisite)
FROM node:21.6.1-alpine AS build-stage

ENV NODE_ENV=production

WORKDIR /app

# cache dependencies (what won't change often)
COPY package*.json ./

RUN npm install

COPY . .

# build an application
RUN npm run build --include=dev

# serve stage
FROM nginx:stable-alpine AS production-stage

# where dist is where build static files are located
COPY --from=build-stage /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]