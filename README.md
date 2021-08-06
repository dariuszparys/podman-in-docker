# Running Podman in Ubuntu 20.04 Docker Container

Start container

```
docker run --detach --name=podmanctr --net=host --security-opt label=disable --security-opt seccomp=unconfined --device /dev/fuse:rw -v /var/lib/mycontainer:/var/lib/containers:Z --privileged piu:latest sh -c 'while true ;do sleep 100000 ; done'
```

Exec into container
```
docker exec -it podmanctr /bin/sh
```