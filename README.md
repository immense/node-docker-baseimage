# Node.js 0.12.x Baseimage #

Usage:

```Dockerfile
FROM immense/node-baseimage
ADD ./site.nginx.conf /etc/nginx/site.conf
ADD ./package.json /home/app/src/package.json
ADD ./bower.json /home/app/src/bower.json

RUN npm install
ADD . /home/app/src

RUN npm run build
```
