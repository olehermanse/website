# Personal website

https://oleherman.com

Run locally with docker:

```sh
docker build --tag oleherman-com . && docker run -it -p 8000:80 --name oleherman-com --rm oleherman-com
```

Or with podman:

```sh
podman build --tag oleherman-com . && podman run -it -p 8000:80 --name oleherman-com --rm oleherman-com
```

http://127.0.0.1:8000
