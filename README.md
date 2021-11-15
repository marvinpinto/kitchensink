# A Kitchen Sink Development Environment

<img alt="kitchen sink logo" height="200px" src="logo.png">

![[Build Status](https://github.com/marvinpinto/kitchensink/actions/workflows/latest.yml/badge.svg?branch=main)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square)](LICENSE.txt)

Wouldn't it be nice if you didn't have to install a kitchen-sink worth of tools
on your host dev machine? Well, you don't have to with Docker!

The nice thing about these throwaway environments is that I can mess around and
install all the crap I need inside an environment and only persist it if I want
to. It's like a clean slate every time!

## Maybe install these tools on the host instead?

So, I did this out of desperation. I got tired of installing a kitchen-sink
worth of dev tools on my host machine, and dealing with the mess that comes
with updating all these tools, and all their inter-dependencies.

## Why not a bunch of vagrant machines?

That works too! I found it easier for me to be able to *quickly* bring one of
these up and destroy it when I'm done. A vagrant setup works for this too. Just
not for me.

## What about OSX?

I don't actually know how this would work or if this would even be useful on
OSX. Sorry :dissapointed:

## Where can I get a hold of this Docker image?
```
docker pull ghcr.io/marvinpinto/kitchensink:20.04-latest
```

## How do I use it?

I created a bashrc function to handle bringing these up whenever I need them
(function example below).

So, issuing something like:

```
$ sink rails-is-fun
```

will bring up a named docker container called `rails-is-fun`. And if I issue
the same command again in another terminal window, it will connect to the
*same* container! Neat, right?

Here is an example of the `sink` function. You can find the current version
of the function _I_ use over in my [dotfiles][1] repo!

```bash
# Bash function to attach to, or spin up a new (named) docker container
function sink () {
  local boxname=$1
  local workdir="/home/dev"

  if [ -z "$boxname" ]; then
    echo "usage: sink <box name>"
    return 1
  fi

  local dockerid=$(docker ps -aq --filter=name=$boxname)
  if [ "$dockerid" != "" ]; then
    echo "Attaching to existing docker container ${dockerid}"
  else
    echo "Creating new docker container"
    dockerid=$(docker run -dit \
      -e "HOSTNAME=${boxname}" \
      --name $boxname \
      --hostname ${boxname} \
      -v /home/marvin:/var/shared \
      -v $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK) \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
      -w $workdir \
      ghcr.io/marvinpinto/kitchensink:20.04-latest)
  fi
  docker exec -it $dockerid /bin/bash
}
```

## Credit

This idea was very much inspired by [github.com/shykes/devbox][2].

The logo was made by [github.com/des4maisons][4].

[1]: https://github.com/marvinpinto/dotfiles/blob/master/roles/bash/files/bashrc
[2]: https://github.com/shykes/devbox
[4]: https://github.com/des4maisons
