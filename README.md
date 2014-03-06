# Embeddable Rails API

This spike is motivated by the impending death of ember-appkit-rails.

Certain parts of this spike (marked where necessary) will be extracted into a gem that is reusable
for any app that wants a lighter-weight solution similar to this.

The folder structure will be something like:


```
api/          Rails-API app
app/          Ember-CLI app
config/       Ember config
public/       Build assets served by Rails in development
vendor/       Bower install directory
```

Run it with:

```
bundle exec rackup api/config.ru
```

More to come soon.
