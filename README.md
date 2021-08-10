# Running Podman in Ubuntu 20.04 Docker Container

Start container

```
docker run --detach --name=podmanctr --net=host --security-opt label=disable --security-opt seccomp=unconfined --device /dev/fuse:rw -v /var/lib/mycontainer:/var/lib/containers:Z --privileged piu:latest sh -c 'sleep infinity'
```

Exec into container
```
docker exec -it podmanctr /bin/sh
```

Based on the work from https://github.com/containers/podman/tree/main/contrib/podmanimage