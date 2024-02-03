# gpuowl-docker-cuda

- This just builds [gpuowl](https://github.com/preda/gpuowl) on top of a CUDA container.
- No real version pinning at the moment, but there is a `GPUOWL_REFERENCE` build argument.
- I may do the same for [CUDALucas](https://sourceforge.net/projects/cudalucas/)
- PrimeNet is not included at the moment.

## Build

```shell
docker build -t gpuowl-docker-cuda:latest .
```

## Run

```shell
mkdir -p {workdir,tmpdir}
docker run -it --rm \
  -v ./workdir:/workdir \
  -v ./tmpdir:/tmpdir \
  --gpus=all \
  gpuowl-docker-cuda:latest -yield -dir /workdir -tmpDir /tmpdir
```

- You'll want to follow the [gpuowl usage instructions](https://github.com/preda/gpuowl#usage).
- To populate your `worktodo.txt`, use `workdir/worktodo.txt`.
