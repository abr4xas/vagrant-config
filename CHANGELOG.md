# Lista de cambios

> Todos los cambios significativos serán registrados en éste documento.

## [3.0.1](https://github.com/abr4xas/vagrant-config/releases/tag/3.0.1) 2016-04-12

### Nuevo:

* Se agrega swap de 4GB para evitar posibles problemas con composer. (ver: este enlace para [más info](https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-ubuntu-14-04).)
* Se deshabilita de forma global la barra de progresos al usar npm install relacionado con: npm/npm#11283
* Se crea una wiki para referencias futuras.

## [3.0.0](https://github.com/abr4xas/vagrant-config/releases/tag/3.0.0) 2016-04-12

### Nuevo:

* NGINX
* php5-fpm

### Cambiado

Se elimina soporte a:

* Apache
* libapache2-mod-php5 ver #[4](https://github.com/abr4xas/vagrant-config/issues/4)
* rethinkdb
* mongodb

## [v2.0](https://github.com/abr4xas/vagrant-config/releases/tag/v2.0) 2015-10-11

### Nuevo:

* Se agrega soporte a `ubuntu/vivid64`
* Se agrega soporte a nodejs `v4.x`
