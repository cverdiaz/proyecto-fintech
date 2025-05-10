# --- Etapa 1: Construcción del proyecto Vue ---

# Utilizamos una imagen oficial de Node.js versión 18 para compilar el proyecto
FROM node:18 AS builder

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia los archivos de dependencias (package.json y package-lock.json) al contenedor
COPY package*.json ./

COPY .env .env

# Instala las dependencias del proyecto
RUN npm install

# Copia todos los archivos del proyecto al contenedor
COPY . .

# Compila el proyecto Vue para producción y genera la carpeta dist/
RUN npm run build


# --- Etapa 2: Servir los archivos construidos con Nginx ---

# Utilizamos una imagen liviana de Nginx como servidor web
FROM nginx:alpine

# Copia los archivos compilados desde la etapa anterior al directorio raíz de Nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Copia nuestra configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expone el puerto 80 para acceder al servidor Nginx
EXPOSE 80

# Inicia el servidor Nginx en primer plano
CMD ["nginx", "-g", "daemon off;"]
