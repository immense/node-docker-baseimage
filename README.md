# Node.js 0.12.x Baseimage #
## Usage

- Create a Dockerfile in your nodejs application directory with the following content:

        FROM immense/node-baseimage
        ADD ./site.nginx.conf /etc/nginx/conf.d/default.conf
        ADD package.json bower.json /webapp/

        RUN npm install
        ADD . /webapp

        RUN npm run build


Note: It is assumed that in your applications entrypoint command, you will call `nginx` before starting your application.
