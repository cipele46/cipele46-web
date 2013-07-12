# Cipele46 Web [![Code Climate](https://codeclimate.com/github/cipele46/cipele46-web.png)](https://codeclimate.com/github/cipele46/cipele46-web) [![Build Status](https://travis-ci.org/cipele46/cipele46-web.png?branch=master)](https://travis-ci.org/cipele46/cipele46-web)

Source kod http://cipele46.org.

## Instalacija

Nakon kloniranja:

```shell
bundle install
cp config/application.yml.example config/application.yml
cp config/database.yml.example config/database.yml
foreman start
open http://localhost:3000
```

Editiraj `application.yml` i namjesti svoj gmail username/password (bit će korišten za slanja mailova u developmentu) te `database.yml` za konfiguraciju baze.

rake db:migrate
