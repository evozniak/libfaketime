# libfaketime

Testing how to change the time inside a docker container.

To run

```
dotnet build
docker build --rm --pull . -t "libfaketime:latest"
docker run -it libfaketime
```
