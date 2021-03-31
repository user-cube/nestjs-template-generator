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
$ cp nestjs_generator.sh ~/bin/nestjs_gen
$ chmod +x ~/bin/nestjs_gen
$ echo 'PATH="$HOME/bin:$PATH"' >> ~/.zshrc
$ source ~/.zshrc
```

## Pull Requests

Feel free to add new features and fix bugs, open a pull request and I'll merge it to the main branch.

# Author

- [Rui Coelho](https://github.com/user-cube)
