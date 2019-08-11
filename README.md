# Connect 4 Game

### Getting Started

This is a Connect 4 game which is implemented using Ruby. It is a terminal application. Before playing this game
make sure you are in the project directory. After that, you should run the following command to install the dependencies.

```
bundle install
```

Next, you can run and play the game just typing below command.

```
ruby run.rb
```

If you want to play this game in different mode you should run below command to see the options.

```
ruby run.rb --help
```

For example, if you want to extend the board you should run below command.

```
ruby run.rb -w 10 -h 10
```
OR
```
ruby run.rb --width 10 --height 10
```

You can also give more than one options.

```
ruby run.rb --width 10 --height 10 --computer 1
```

If you want to run the test cases you should type below command.

```
rspec spec/game_spec.rb
```

### Authors

* **Nuh Ali Akgul** - *Full Stack Web Developer* - *nuhaliakgul@hotmail.com*