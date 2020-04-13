# Pushokku

![Build](https://github.com/glenux/pushokku/workflows/Build/badge.svg)

Push docker image to remote dokku server then deploy it


## Prerequisites

Make sure you have crystal (>= 0.31) installed on your system.


## Installation

Run the following command:

    make build


## Usage

Show help

```shell-session
$ ./pushokku --help
Welcome to Pushokku!
    -c CONFIG, --config=CONFIG       Use the following config file
    -f DOCKER_COMPOSE_YML, --config=DOCKER_COMPOSE_YML
                                     Use the following docker-compose file
    -v, --version                    Show version
    -h, --help                       Show help
```

## Configuration

Add a `.pushokku.yml` file to the root directory of your projet, with the
following content:

```
---
version: "2"

locals:

  # Some container you want to deploy
  - name: my-app
    type: docker_image
    docker_image: my-site-v2-wordpress_wordpress

  # Some database dump you want to deploy
  - name: my-db
    type: mysql_dump
    path: database.sql

remotes:

  # Some remote dokku server
  - name: testing-server
    user: debian
    host: dokku02.infra.example.com

deployments:

  # Associate local container with remote app
  - local: my-app
    remote: dokku-dokku02
    dokku_app:
      name: customer-my-site

  # Associate local dump with remote mariadb
  - local: my-db
    remote: testing-server
    dokku_mariadb:
      name: customer-my-appsandbox

  # Simply run `pushokku` and that's done!

```

## Contributing

1. Fork it (<https://github.com/glenux/pushokku/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Glenn Y. Rolland](https://github.com/glenux) - creator and maintainer

