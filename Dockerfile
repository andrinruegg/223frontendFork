# Nutze Node.js 16 für den Build-Prozess
FROM node:18-alpine AS builder

# Setze das Arbeitsverzeichnis im Container
WORKDIR /app

# Kopiere package.json und installiere Abhängigkeiten
COPY react_frontend/package.json react_frontend/yarn.lock ./
RUN yarn install --production

# Kopiere den gesamten Code aus `react_frontend`
COPY react_frontend /app

# Baue das Frontend
RUN yarn build

# Nutze Nginx als Webserver für das React-Frontend
FROM nginx:alpine

# Kopiere das gebaute React-Projekt nach Nginx
COPY --from=builder /app/build /usr/share/nginx/html

# Falls du eine eigene Nginx-Konfiguration hast, füge sie hinzu
COPY react_frontend/nginx.conf /etc/nginx/conf.d/default.conf

# Exponiere Port 80
EXPOSE 80

# Starte Nginx
CMD ["nginx", "-g", "daemon off;"]
