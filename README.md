# CS50-s-Introduction-to-Game-Development
Learning game development

## Building the games

### Linux to windows

First zip the contents of the directory
```
cd game_dir/

zip -9 -r gameName.love .
```
then fetch love.exe from the zipped build for windows on love2d's [official website](https://www.love2d.org/)

then in the command line

```
cat love.exe gameName.love > gameName.exe
```

after that move the executable into a folder with all the dlls provided in love2d zipped build and the license also, then it can be zipped and distributed