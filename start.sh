#!/bin/bash

CHECKSUM_FILE=".dockerfile_checksum"
IMAGE_NAME="cli-skeleton/php:latest"

NEW_CHECKSUM=$(sha256sum Dockerfile | cut -d " " -f 1)
if [ -f $CHECKSUM_FILE ]; then
    OLD_CHECKSUM=$(cat $CHECKSUM_FILE)
else
    OLD_CHECKSUM=""
fi

if [ "$NEW_CHECKSUM" != "$OLD_CHECKSUM" ]; then
    echo "Dockerfile has changed. Removing old image."
    echo $NEW_CHECKSUM >$CHECKSUM_FILE
    docker image rm -f $IMAGE_NAME >/dev/null 2>&1
fi

IMAGE_EXISTS=$(docker images -q $IMAGE_NAME)

if [ -z "$IMAGE_EXISTS" ]; then
    echo "Image does not exist. Building image."
    docker build -t $IMAGE_NAME .
else
    echo "Image exists. Using existing image."
fi

docker rm -f php >/dev/null 2>&1

docker run -d --name php \
    -v $(pwd):/app \
    -w /app \
    $IMAGE_NAME bash -c "tail -f /dev/null"

echo -e "Container started.";

vendorExists=false
if [ ! -d vendor ]; then
    echo -e "Directory \033[34;1mvendor\033[0m doesn't exist. Installing dependencies."
    docker exec php composer install
    echo "Dependencies installed."
else
    vendorExists=true
fi

docker exec php composer create-project pbaszak/skeleton --no-interaction

rm -rf skeleton/src
rm -rf skeleton/config/routes.yaml
cp -r src/src skeleton/src
rm -rf skeleton/public

docker exec php php scripts/Setup.php
docker stop php >/dev/null 2>&1
docker rm -f php >/dev/null 2>&1
docker rmi -f $IMAGE_NAME >/dev/null 2>&1

chown -R $USER .

rm -rf node_modules scripts src .gitignore CHANGELOG.md composer.json composer.lock README.md LICENSE .git vendor start.sh package.json package-lock.json Dockerfile
mv skeleton/{,.[^.]}* ./
rm -rf skeleton

rm -rf CHANGELOG.md

bash start.sh
docker exec php composer update || composer update
