Rails application for [Cafira](http://www.cafira.com/)
### General info
* **Ruby version:** 2.2.2

* **Rails version:** 4.2.4

* **System dependencies:** Check out [Gemfile](https://github.com/cran-io/cafira/blob/master/Gemfile)

###Usage:
Clone this repo, then run:
```{r, engine='bash', count_lines}
$ bundle install
$ rake db:create && rake db:migrate
```

#### Crontab:
```
@weekly sh /home/path/to/cron_script/weekly_status.sh > /home/path/to/cron_log/cron_task.log 2>&1
=======

###Setup with docker
To use [Docker](http://www.docker.com) (requires [docker-compose](https://docs.docker.com/compose/))
```sh
git clone https://github.com/cran-io/cafira.git
cd cafira
cp config/database.docker.yml config/database.yml
docker-compose up
```
We wait until ```docker-compose up``` show us the familiar output:
```sh
web_1 | [2015-07-06 17:39:19] INFO  going to shutdown ...
web_1 | [2015-07-06 17:39:19] INFO  WEBrick::HTTPServer#start done.
web_1 | => Booting WEBrick
web_1 | => Rails 4.2.1 application starting in development on http://0.0.0.0:3000
web_1 | => Run `rails server -h` for more startup options
web_1 | => Ctrl-C to shutdown server
```
In a new terminal, we "login" to the docker container y and load the db schema.
```sh
docker exec -i -t cafira_web_1 /bin/bash
rake db:schema:load RAILS_ENV=development
rake db:create RAILS_ENV=test
rake db:schema:load RAILS_ENV=test
rake db:seed RAILS_ENV=development
exit
```
We use ```docker-compose up``` only the first time. After that, we can use ```docker-compose start``` or ```docker-compose stop```.
```sh
docker-compose <start|stop>
```
