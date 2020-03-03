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

## Contributing

1. Fork it (<https://github.com/glenux/pushokku/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Glenn Y. Rolland](https://github.com/glenux) - creator and maintainer

