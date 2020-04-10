cat database.sql.gz |ssh shiva-ratri.infra.boldcode.io 'docker exec -i customer-sans-a-site.web.1 sh -c "cat > adminer.sql.gz"'

cat database.sql |ssh shiva-ratri.infra.boldcode.io 'dokku mariadb:import customer-sans-a-wpsandbox'

# TODO

* verify target app exist
* verify target database exist

