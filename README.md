# NestJS Template Generator

Script to generate NestJS basic app template.

## Using as script

To use only as script just put the `nestjs_generator.sh` on the folder you want to use and run:

```shell
$ sh nestjs_generator.sh -gA my-app
```

## Use as system tool

To use this script as a system tool we need to add our script to PATH.

```shell
$ mkdir -p ~/bin
$ mv nestjs_generator.sh ~/bin/nestjs_gen
$ chmod +x ~/bin/nestjs_gen
$ echo 'PATH="$HOME/bin:$PATH"' >> ~/.zshrc
$ source ~/.zshrc
```
