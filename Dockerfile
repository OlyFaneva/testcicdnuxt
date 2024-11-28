# Étape de construction
FROM node:18-alpine AS builder

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers package.json et package-lock.json
COPY package*.json ./

# Installer les dépendances
RUN npm install

# Copier le reste des fichiers du projet
COPY . .

# Construire le projet Next.js
RUN npm run build

# Étape de production
FROM node:18-alpine

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers nécessaires depuis l'étape builder
COPY --from=builder /app ./

# Installer les dépendances de production uniquement (facultatif pour optimiser)
RUN npm install --omit=dev

# Exposer le port 3000
EXPOSE 3000

# Commande de démarrage
CMD ["npm", "start"]

