# Criar certificado autoassinado
openssl req -nodes -x509 -days 3650 -newkey rsa:2048 -keyout cert/private.key -out cert/cert.crt

# Subir container Docker
docker run --name=nginx --rm -p 80:80 -p 443:443 -v /home/evertonagilar/study/nginx.conf:/etc/nginx/nginx.conf -v /home/evertonagilar/study/cert:/etc/nginx/cert nginx:alpine
