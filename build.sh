#!/usr/bin/env bash

docker run --rm --privileged multiarch/qemu-user-static:register --reset
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

for docker_arch in amd64 arm32v7 arm64v8; do
    case ${docker_arch} in
        amd64   ) qemu_arch="x86_64" ;;
        arm32v7 ) qemu_arch="arm" ;;
        arm64v8 ) qemu_arch="aarch64" ;;    
    esac
    wget -N https://github.com/multiarch/qemu-user-static/releases/download/v3.1.0-2/x86_64_qemu-${qemu_arch}-static.tar.gz
    tar -xvf x86_64_qemu-${qemu_arch}-static.tar.gz

    cat Dockerfile.cross | \
        sed -e "s|__BASEIMAGE_ARCH__|${docker_arch}|g" | \
        sed -e "s|__QEMU_ARCH__|${qemu_arch}|g" > Dockerfile.${docker_arch}
    if [ ${docker_arch} == "amd64" ]; then
        sed -i -e "/__CROSS_/d" Dockerfile.${docker_arch}
    else
        sed -i -e "s/__CROSS_//g" Dockerfile.${docker_arch}
    fi

    docker build -f Dockerfile.${docker_arch} -t adamhf/mumble_arm:${docker_arch}-latest .
    docker push adamhf/mumble_arm:${docker_arch}-latest
done

docker manifest create --amend adamhf/mumble_arm:latest adamhf/mumble_arm:amd64-latest adamhf/mumble_arm:arm32v7-latest adamhf/mumble_arm:arm64v8-latest
docker manifest annotate adamhf/mumble_arm:latest adamhf/mumble_arm:arm32v7-latest --os linux --arch arm --variant v7
docker manifest annotate adamhf/mumble_arm:latest adamhf/mumble_arm:arm64v8-latest --os linux --arch arm64 --variant v8
docker manifest push adamhf/mumble_arm:latest
