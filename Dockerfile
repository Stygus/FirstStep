# ---------- ETAP 1: BUILD FLUTTER ----------
FROM instrumentisto/flutter:3.32.2-androidsdk35-r0 AS builder

# Ustaw katalog roboczy
WORKDIR /app

# Skopiuj tylko pliki pubspec, żeby cache'ować 'flutter pub get'
COPY pubspec.* ./
RUN flutter pub get --no-precompile

# Skopiuj resztę aplikacji
COPY . .
 
# Zbuduj aplikację Android (lub iOS, jeśli masz odpowiednie certyfikaty/narzędzia)
# RUN flutter build apk --release

# Zbuduj wersję web
RUN flutter build web --target lib/main_web.dart --release

RUN rm .env


# ---------- ETAP 2: SERWUJ WEB PRZEZ NGINX ----------
FROM nginx:1.28-alpine AS web

# Usuń domyślną konfigurację (opcjonalnie)
RUN rm /etc/nginx/conf.d/default.conf

# Skopiuj własny plik konfiguracji NGINX
COPY nginx.conf /etc/nginx/conf.d/

# Skopiuj wybudowaną wersję web z poprzedniego etapu
COPY --from=builder /app/build/web /usr/share/nginx/html

# Otwórz port
EXPOSE 80

# Domyślne polecenie
CMD ["nginx", "-g", "daemon off;"]
