# docker-jq

## Description

This is Dockerfile repository that wrap [jq](https://stedolan.github.io/jq) command.

**This docker image is very small to use comand line.**

*Please refer to the official website of [jq](https://stedolan.github.io/jq) for how to use [jq](https://stedolan.github.io/jq) command.*

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

## Relase Note

|date      |version|note          |
|---       |---    |---           |
|2019-10-16|0.1    |first release.|


## License

This software is released under the MIT License, see LICENSE.


## Author Information

[genzouw](https://genzouw.com)

* Twitter   : @genzouw ( https://twitter.com/genzouw )
* Facebook  : genzouw ( https://www.facebook.com/genzouw )
* LinkedIn  : genzouw ( https://www.linkedin.com/in/genzouw/ )
* Gmail     : genzouw@gmail.com
