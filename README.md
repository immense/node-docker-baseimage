# Node.js 0.12.x Baseimage #
## Usage

- Create a Dockerfile in your nodejs application directory with the following content:

        FROM immense/node-baseimage
        ADD ./site.nginx.conf /etc/nginx/site.conf
        ADD ./package.json /home/app/src/package.json
        ADD ./bower.json /home/app/src/bower.json

        RUN npm install
        ADD . /home/app/src

        RUN npm run build


Note: It is assumed that in your start command (specified in the Dockerfile or in a docker-compose.yml), you will call `sudo service nginx start` before starting your application.
