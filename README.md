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

- ubuntu: 20.04, 22.04

pull image: 20.04
```
$ docker pull how2flow/ubuntu:20.04
```

run image: 20.04
```
$ docker run -it how2flow/ubuntu:20.04 bash
```
