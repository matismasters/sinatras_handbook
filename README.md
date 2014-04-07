# Sinatra's handbook

## Short explanation

Sinatra's handbook its a superlight Wiki-like application. Its written in only
one .rb file, taking advantage of inline templates, rack csrf, one file routes,
and Markdown.

## Features

* Create any number of pages with its path as name
* Update existing pages by adding /edit at the end of the path
* Use markdown
* Link pages from one another by creating simple links with new paths
* Heroku-ready Rack Application

## Install

* Install mongodb
* ``bundle install``
* ``rackup``

## Usage

- Access any path within the app
- Create the Markdown content and click on the Save button
- Everytime you access that page, you will see the content you just created
- Click on the Edit link
- Edit the Markdown content and add a markdown link with the usual syntax,
pointing to a different path than the one you are right now.
- While viewing the content click on the link you just created
- Add the new Markdown content for that page, and click Save
- Repeat as many times as needed...

## Heroku install

Assumming you already created your heroku account, and you have the [Heroku
toolbelt](https://toolbelt.heroku.com/) installed and working.

    $ git clone
    $ heroku create __my_copy_of_sinatras_handbook__
    $ git push heroku master
    $ heroku addons:add mongohq
    $ heroku restart

## Testing

```
    ruby test.rb
```

## Things to add

- Editor permissions
- Viewer permissions
- Add styles to make it look like a handbook
- Navigation based on paths that start with /navigation

## Gemfile.lock

    remote: https://rubygems.org/
    specs:
      activemodel (3.2.17)
        activesupport (= 3.2.17)
        builder (~> 3.0.0)
      activesupport (3.2.17)
        i18n (~> 0.6, >= 0.6.4)
        multi_json (~> 1.0)
      builder (3.0.4)
      haml (4.0.5)
        tilt
      i18n (0.6.9)
      mongoid (3.1.6)
        activemodel (~> 3.2)
        moped (~> 1.4)
        origin (~> 1.0)
        tzinfo (~> 0.3.29)
      moped (1.5.2)
      multi_json (1.9.2)
      origin (1.1.0)
      rack (1.5.2)
      rack-protection (1.5.2)
        rack
      redcarpet (3.1.1)
      sinatra (1.4.4)
        rack (~> 1.4)
        rack-protection (~> 1.4)
        tilt (~> 1.3, >= 1.3.4)
      tilt (1.4.1)
      tzinfo (0.3.39)

## Thanks

- Easy to apply theme [Twitter Bootstrap](http://getbootstrap.com)
- [Max CDN](http://www.maxcdn.com/) for hosting the bootstrap files

## Disclaimer

__Use this at your own risk__, this is one of the most easy to hack applications
you've ever used. So be careful, this is just 2 hours of my work, there is
still a lot to do in terms of security.
