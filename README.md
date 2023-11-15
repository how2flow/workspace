# workspace

### script

Run:

```
$ cd workspace
$ ./set --target=<TARGET>
```

TARGET list:

- docker
- opencv
- python3
- ros2
- vi (default)

help:

```
$ ./set --help
```

### docker image

pull & run image
```
$ docker pull how2flow/workspace:latest
$ docker run -it how2flow/workspace:latest
```

easy install
```
$ cd workspace/docker-ubuntu/latest
$ sudo ./INSTALL 'distro_you_want_to_install'
$ docker attach work-distro
```
