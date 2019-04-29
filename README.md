# Dockerized php7-fpm

Docker build file for php7-fpm with the `gd` and `pdo_mysql` extensions which are essential for Content Management Systems (CMS) such as `Drupal` and `WordPress`.

## Usage

```
git pull https://github.com/sunnyplum/docker-php7fpm
cd docker-php7fpm
```
For production
```
docker build -t php:7-fpm-gd-prod --target prod .
```
For development
```
docker build -t php:7-fpm-gd-dev --target dev .
```

## Contributor
[Sunnyplum](https://github.com/sunnyplum)

## License
[MIT License](https://github.com/sunnyplum/docker-php7fpm/blob/master/LICENSE)
