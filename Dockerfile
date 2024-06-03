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

# set configurations
COPY nginx.conf.template /etc/nginx/nginx.conf.template

# substitute
RUN envsubst '${PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/conf.d/default.conf

# where dist is where build static files are located
COPY --from=build-stage /app/dist etc/share/nginx/html

# expose the port that railway will use
EXPOSE ${PORT}
CMD ["nginx", "-g", "daemon off;"]