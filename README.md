# ethminer
This container is a CUDA enabled build of ethereum-mining/ethminer. It tracks the head of the
master branch at build time. I used the guidance provided in the
[build.md](https://github.com/ethereum-mining/ethminer/blob/master/docs/BUILD.md)
of the repository to put this image together.

## Tip Jar
If you're using this container image, tips in <a
href="ethereum:%30%78%41%65%32%36%43%64%31%35%37%33%37%34%35%32%33%36%38%30%37%45%36%37%63%45%33%62%65%33%34%43%61%34%32%32%36%66%34%63%46%33%3f%76%61%6c%75%65%3d%31%65%31%38">eth</a>
are appreciated! :bowtie:


## Overview
To minimize the complexity of pulling in the required dependencies and
minimizing the size of the image, I use the
nvidia/cuda devel image to build the ethminer binary. In the second
stage, I copy the build artifacts to a new image dependent on
nvidia/cuda runtime.

The entrypoint for the final image is /opt/ethminer/ethminer.

This provides the ability to pass arguments at container execution time. For
example:

```
$ docker run --gpus all -it kriation/ethminer:latest --list-devices


ethminer 0.19.0+commit.47ae149e
Build: linux/release/gnu

 Id Pci Id    Type Name                          CUDA SM   Total Memory
 --- --------- ---- ----------------------------- ---- ---  ------------
   0 01:00.0   Gpu  GeForce GTX 1660 SUPER        Yes  7.5       1.52 GB
```

The prerequisite to using this image is that the NVIDIA container toolkit is
configured properly on the container host. The
[documentation](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/user-guide.html)
from NVIDIA on setting the toolkit up is straightforward.

## Build
For those interested in building a custom image that isn't available in Docker
Hub, you can pass a build argument of CUDA_VERSION set to any of the tags
listed in the [CUDA Supported Tags](https://gitlab.com/nvidia/container-images/cuda/blob/master/doc/supported-tags.md) documentation.

An example is below:

```
$ docker build --build-arg CUDA_VERSION=10.0 -t kriation/ethminer:10.0 .
```

The resulting image will be based off of the CUDA 10.0 base.
