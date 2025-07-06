---
layout: page
title:  "Paperless-NGX"
teaser: "Your Digital Filing Cabinet"
date:   2025-04-19 20:00:01 -0700
categories: web software server
tags: software web self-host docker
published: true
header: no
---
<div class="panel radius" markdown="1">
**Table of Contents**
{: #toc }
*  TOC
{:toc}
</div>

# Intro
Dealing with paper is so last century. During my self-hosted journey, I recently came across the [paperless-ngx][paperless-ngx] project. It claims to used advanced OCR and smart tagging to help you declutter, or digitize all of your paper documents. Another appealing point is being able to securely store these files _and_ have access to them wherever I am, something you cannot do with traditional filing cabinets.

# Prep
I will be utilizing docker to run paperless, but will not be hosting the actual files there. I have a NAS for that. So, to start, create a share on your NAS just for paperless. I named mine paperless. It's very creative.

Next, create a new user and/or group for the docker container to be able to access the share.

Now, create folders for the paperless server to access:
* data - where data will be stored (configs, etc)
* media - where the actual files will be saved
* consume - a directory that will be monitored by the service to auto-import documents for processing

Now, on your docker host, edit fstab (/etc/fstab) to create mounts to tie back to the NAS:
```//NAS_IP/share/path /mnt/paperless/data cifs x-systemd.automount,dir_mode=0777,creds=.paperlesscreds 0 0```

Add two more lines, one each for media and consume. Don't forget to actually create the mount directories (`mkdir paperless`, etc)!

For the credentials file, create a file using nano or another editor in ~ (your home) with the same name as above with the following in it:
{% highlight sh %}
user=USERNAME
pass=PASSWORD
directory=WORKGROUP
{% endhighlight %}

Write out the file and exit. Next, `chown` it to `600`.

Now, mount the new shares using `mount -a` and get ready to compose paperless itself.

# Install
I used docker-compose to create the stack for paperless, as it also depends on a database and a data platform.

Here is my compose:

{% highlight yaml %}
services:
  broker:
    image: docker.io/library/redis:7
    restart: unless-stopped
    volumes:
      - redisdata:/data
  
  db:
    image: docker.io/library/postgres:17
    restart: unless-stopped
    volumes:
      - pgdata:/var/lib/postgresql/data
    environment:
      POSTGRES_DB: paperless
      POSTGRES_USER: paperless
      POSTGRES_PASSWORD: paperless
  
  webserver:
    image: ghcr.io/paperless-ngx/paperless-ngx:latest
    restart: unless-stopped
    depends_on:
      - db
      - broker
    ports:
      - "8010:8000"
    volumes:
      - /mnt/paperless/data:/usr/src/paperless/data
      - /mnt/paperless/media:/usr/src/paperless/media
      - ./export:/usr/src/paperless/export
      - /mnt/paperless/consume:/usr/src/paperless/consume
    environment:
      PAPERLESS_REDIS: redis://broker:6379
      PAPERLESS_DBHOST: db
    env_file:
      - stack.env

volumes:
  paperless_data:
  paperless_media:
  pgdata:
  redisdata:
{% endhighlight %}

I also have these environment variables from stack.env:
`COMPOSE_PROJECT_NAME=paperless`

and from docker-compose.env:
{% highlight sh %}
USERMAP_UID=0
USERMAP_GID=0
PAPERLESS_TIME_ZONE=America/Denver
PAPERLESS_OCR_LANGUAGE=eng
PAPERLESS_CONSUMER_RECURSIVE=true
PAPERLESS_CONSUMER_ENABLE_COLLATE_DOUBLE_SIDED=true
PAPERLESS_CONSUMER_COLLATE_DOUBLE_SIDED_SUBDIR_NAME=double
PAPERLESS_CONSUMER_COLLATE_DOUBLE_SIDED_TIFF_SUPPORT=true
PAPERLESS_CONSUMER_POLLING=60
{% endhighlight %}

Finally, on the docker host, `adduser paperless` to complete the install (note: I can't remember if this last step was actually needed, or if I had already done it while banging my head against the 0/0 UID/GID problem).

Why user and group IDs set to zero? Because I could not for the life of me get the permissions right with the IDs matching its actual user and group of 1001. So, root it is!


# References
* [https://docs.paperless-ngx.com/setup/#docker_script](https://docs.paperless-ngx.com/setup/#docker_script)
* [https://github.com/paperless-ngx/paperless-ngx/tree/main/docker/compose](https://github.com/paperless-ngx/paperless-ngx/tree/main/docker/compose)
* [https://www.reddit.com/r/Paperlessngx/comments/1g2ovoi/paperless_docker_user_permissions_or_usermap/](https://www.reddit.com/r/Paperlessngx/comments/1g2ovoi/paperless_docker_user_permissions_or_usermap/)

[paperless-ngx]: https://docs.paperless-ngx.com