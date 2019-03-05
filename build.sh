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

    docker build \
      -f Dockerfile \
      --build-arg docker_arch=${docker_arch} \
      --build-arg qemu_arch=./qemu-${qemu_arch}-static \
      -t adamhf/mumble:${docker_arch}-latest \
      .
    docker push adamhf/mumble:${docker_arch}-latest
done

docker manifest create --amend adamhf/mumble:latest adamhf/mumble:amd64-latest adamhf/mumble:arm32v7-latest adamhf/mumble:arm64v8-latest
docker manifest annotate adamhf/mumble:latest adamhf/mumble:arm32v7-latest --os linux --arch arm --variant v7
docker manifest annotate adamhf/mumble:latest adamhf/mumble:arm64v8-latest --os linux --arch arm64 --variant v8
docker manifest push adamhf/mumble:latest
