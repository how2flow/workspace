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

**support list:**
- focal
- jammy

pull & run image: focal
```
$ docker pull how2flow/workspace:focal
$ docker run -it how2flow/workspace:focal bash
```
