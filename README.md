# libfaketime

Testing how to change the time inside a docker container with a running application written in .net core 3.2
Origial library repository https://github.com/wolfcw/libfaketime

To run

```
dotnet build
docker build --rm --pull . -t "libfaketime:latest"
docker run -it libfaketime
```
