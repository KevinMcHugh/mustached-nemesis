### Hello and welcome to mustached-nemesis, the only game where your nemesis has a mustache

### This is [Bang!](http://en.wikipedia.org/wiki/Bang!), but you write an ai to play it for you. Check out [the example brains](https://github.com/KevinMcHugh/example_brains) for an idea of how to get started

if you're developing your own gems, use
`bundle config local.example_brains /path_to/example_brains/`
so you don't have to push all the time.

You'll still have to `bundle` and restart rails to make those changes available.

###Here's some things you might want to do:

##### rails r demo_game persist
  This creates and persists a new game for you, wow!
##### rails r mega_game_runner 10000
  This runs, without persisting, 10000 games for you, wow!
##### rails s
  This starts a server, hey cool! Right now there's not much in the UI. Eventually there will be visualizations that show you why a brain is successful or unsuccessful.
