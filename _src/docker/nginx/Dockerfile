FROM debian:stable-slim

# Install requirements
RUN apt update && \
    apt install -y curl gnupg2 ca-certificates lsb-release debian-archive-keyring

# nginx署名keyのインポート
RUN curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

# aptリポジトリの設定
RUN echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/debian `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list

RUN apt update && apt install -y nginx

CMD ["nginx", "-g", "daemon off;"]
