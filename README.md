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
```
