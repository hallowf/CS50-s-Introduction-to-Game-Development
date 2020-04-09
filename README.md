# CS50-s-Introduction-to-Game-Development
Learning game development

## Building the games

### Linux to windows

First zip the contents of the directory
```
cd pong/

zip -9 -r gameName.love .
```
then fetch love.exe from the zipped version for windows on love2d's [official website](https://www.love2d.org/)

then in the command line

```
cat love.exe gameName.love > gameName.exe
```