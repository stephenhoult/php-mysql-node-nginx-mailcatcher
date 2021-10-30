# docker-dev-env

A php, mysql, node and mailcatcher enabled local dev environment

## Usage

Add the following to your hosts file.

```
127.0.0.1 docker-dev-env.test
```

From the project root directory run `docker-compose up`.

Browse to http://docker-dev-env.test:8080/ and you should see `It works!`.

To ssh into one of the containers, e.g. the php container

run `docker ps` to get a list of containers.

Find the name of the container you wish to ssh into. E.g. `docker-dev-env_php_1` and run `docker exec -it docker-dev-env_php_1 bash` to connect to the container and run bash.

If using mailcatcher for emails, any sent emails will be viewable at http://docker-dev-env.test:1080

## Customisation

If not using docker-dev-env.test as your development domain, update the `docker/nginx.conf` file with your development domain.

```
server_name .docker-dev-env.test
```

Don't forget to update your hosts file with your development domain.

To change the database name, user or password update the applicable values in `docker-compose.override.yml` with the desired values.

The defaults are as follows:

```
MYSQL_DATABASE: docker-dev-env-db
MYSQL_PASSWORD: docker-dev-env-db-password
MYSQL_ROOT_PASSWORD: docker-dev-env-db-root-password
MYSQL_USER: docker-dev-env-user
```

To change the port nginx listens on update `docker-compose.yml` to reference the new port number.

E.g.

To listen on port 8181 change the below

```
ports:
      - "8080:80"
```

to

```
ports:
      - "8181:80"
```

## Troubleshooting

When changing an environment variable you must rebuild the php container before running `docker-compose up`.

```
docker-compose build --no-cache php
```
