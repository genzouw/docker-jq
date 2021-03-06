# docker-jq

[![Docker Cloud build status](https://img.shields.io/docker/cloud/build/genzouw/jq?style=for-the-badge)](https://hub.docker.com/r/genzouw/jq/)
[![Docker Pulls](https://img.shields.io/docker/pulls/genzouw/jq.svg?style=for-the-badge)](https://hub.docker.com/r/genzouw/jq/)
[![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/genzouw/jq.svg?style=for-the-badge)](https://hub.docker.com/r/genzouw/jq/)

[![dockeri.co](https://dockeri.co/image/genzouw/jq)](https://hub.docker.com/r/genzouw/jq)

## Description

This is Dockerfile repository that wrap [jq](https://stedolan.github.io/jq) command.

**This docker image is very small to use comand line.**

* *Please refer to the official website of [jq](https://stedolan.github.io/jq) for how to use [jq](https://stedolan.github.io/jq) command.*
* *Please contact me anytime if you have a problem or request! My information is posted at the bottom of this document.*

Docker images can be referenced from the following page.

* [Docker Hub](https://hub.docker.com/r/genzouw/jq)

## Requirements

* [Docker](https://www.docker.com)

## Installation

```bash
$ docker pull genzouw/jq
```

## Usage

**Please refer to the official website of [jq](https://stedolan.github.io/jq) for how to use [jq](https://stedolan.github.io/jq) command.**


```bash
$ echo '{ "x":1, "y":"c" }' | docker run -i genzouw/jq .
{
  "x": 1,
  "y": "c"
}

$ echo '{ "x":1, "y":"c" }' | docker run -i genzouw/jq -c .
{"x":1,"y":"c"}

$ echo '{ "x":1, "y":"c" }' | docker run -i genzouw/jq -c .y
"c"

$ echo '{ "x":1, "y":"c" }' | docker run -i genzouw/jq -rc .y
c
```

It is more convenient to put the following aliases in the `~/.bashrc` or `~/.zshrc` file.

```bash
$ alias jq='docker run -i genzouw/jq'
```

## License

This software is released under the MIT License, see LICENSE.


## Author Information

[genzouw](https://genzouw.com)

* Twitter   : @genzouw ( https://twitter.com/genzouw )
* Facebook  : genzouw ( https://www.facebook.com/genzouw )
* LinkedIn  : genzouw ( https://www.linkedin.com/in/genzouw/ )
* Gmail     : genzouw@gmail.com
