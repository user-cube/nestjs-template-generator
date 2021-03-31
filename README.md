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

## Usage

To use this script:

```shell
$ sh nestjs_generator.sh -gA my-app # Generate App ready to git commit
$ sh nestjs_generator.sh -gM my-app # Generate App with Mongoose ready to git commit
$ sh nestjs_generator.sh -d mysql -gT my-app # Generate App with TypeORM (default PostgreSQL, use -d to change) ready to git commit
$ sh nestjs_generator.sh -gS my-app # Generate App with Microservices enabled ready to git commit
```

If you want keep the files into the nest generated folder use the commands above without `g`.
<br>The options to generate the individual modules are also available:

- `-l` - Generate Logger
- `-c` - Generate config service
- `-m` - Generate file main.ts
- `-a` - Generate file app.module.ts
- `-i` - Install NestJS

## Pull Requests

Feel free to add new features and fix bugs, open a pull request and I'll merge it to the main branch.

# Author

- [Rui Coelho](https://github.com/user-cube)
