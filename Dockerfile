FROM ubuntu:20.04

COPY provision-container.sh /tmp/provision-container.sh
RUN yes | unminimize 2>&1 \
    && bash /tmp/provision-container.sh

RUN useradd podman; \
echo podman:100000:65536 > /etc/subuid; \
echo podman:100000:65536 > /etc/subgid;

VOLUME /var/lib/containers
VOLUME /home/podman/.local/share/containers
RUN mkdir -p /home/podman/.local/share/containers

ADD containers.conf /etc/containers/containers.conf
ADD podman-containers.conf /home/podman/.config/containers/containers.conf
ADD podman-storage.conf /home/podman/.config/containers/storage.conf

RUN chown podman:podman -R /home/podman

# chmod containers.conf and adjust storage.conf to enable Fuse storage.
RUN chmod 644 /etc/containers/containers.conf; sed -i -e 's|^#mount_program|mount_program|g' -e '/additionalimage.*/a "/var/lib/shared",' -e 's|^mountopt[[:space:]]*=.*$|mountopt = "nodev,fsync=0"|g' /etc/containers/storage.conf
RUN mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers /var/lib/shared/vfs-images /var/lib/shared/vfs-layers; touch /var/lib/shared/overlay-images/images.lock; touch /var/lib/shared/overlay-layers/layers.lock; touch /var/lib/shared/vfs-images/images.lock; touch /var/lib/shared/vfs-layers/layers.lock

ENV _CONTAINERS_USERNS_CONFIGURED=""
ENV HOME /home/podman