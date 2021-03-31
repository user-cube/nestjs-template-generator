#!/bin/bash

function extractFromFolder(){
    if [ "$forGit" = true ] ; then
        echo "Extract all files from $projectName folder";
        mv $(ls -A | grep -v .git) ..
        mv .gitignore ..
        cd .. && rm -r $projectName
        echo "All files extracted and $projectFolder deleted";
    fi
}

function installNestJS(){
    echo "Installing NestJS...";
    npm i -g @nestjs/cli;
    echo "NestJS Installed.";
}

function generateConfig(){
    echo "Setup configuration service."
    npm i --save @nestjs/config;
    mkdir -p src/config;
    touch src/config/configuration.ts;
    touch .env;
    echo "export default () => ({
  port: parseInt(process.env.PORT, 10) || 3000,
  database: {
    uri: process.env.DATABASE_URI,
  },
});
" >> src/config/configuration.ts;
    echo "Configuration Service Setup done."
}

function generateMain(){
    echo "Generating main.ts";
    echo "import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { LoggerService } from './logger/logger.service';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const configService: ConfigService = app.get(ConfigService);
  const logger: LoggerService = new LoggerService();

  app.enableCors();

  logger.verbose(\`Application listening on port => \${configService.get('port')}\`)
  await app.listen(configService.get('port'));
}
bootstrap();" > src/main.ts
    echo "File main.ts generated."
}

function generateAppModule(){
    echo "Geneationg app.module.ts";
    echo "import { LoggerModule } from './logger/logger.module';
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import configuration from './config/configuration';

@Module({
  imports: [
    LoggerModule,
    ConfigModule.forRoot({
      isGlobal: true,
      load: [configuration],
    }),
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}" > src/app.module.ts
    echo "File app.module.ts generated."
}

function generateLogger(){
    echo "Setup logger Service.";
    nest g module logger;
    echo "import { Module } from '@nestjs/common';

@Module({
  imports: [],
  controllers: [],
  providers: [LoggerService],
  exports: [LoggerService],
})
export class LoggerModule {}" > src/logger/logger.module.ts
    nest g service logger;
    echo "import { Injectable, Scope, Logger } from '@nestjs/common';

@Injectable({ scope: Scope.TRANSIENT })
export class LoggerService extends Logger {}" > src/logger/logger.service.ts
    echo "Logger Service setup done.";
}

function generateProject(){
    if [ -z "$projectName" ]
    then
        echo "No given project name";
        exit 0;
    fi
    nest new $projectName;
    cd $projectName;
}

function checkInstallation(){
    if ! command -v npm &>/dev/null
    then
        echo "Please install npm first.";
        exit 0;
    fi
    if ! command -v node &>/dev/null
    then
        echo "Please install node first.";
        exit 0;
    fi
    if ! command -v nest &>/dev/null
    then
        echo "Please install NestJS first.";
        echo "Run npm i -g @nestjs/cli";
        exit 0;
    fi
}

function displayHelp()
{
	#Help function
	echo "-i Install NestJS";
    echo "-l Generate logger";
    echo "-c Generate Configurarion";
    echo "-m Generate main.ts file";
    echo "-a Generate App Module";
    echo "-g Extract from folder to git structure";
    echo "-A Generate new Project and all configurations";
	exit 1;
}

checkInstallation
forGit=false

while getopts "i:h:l:c:m:a:gA:" arg; do
    case $arg in
        i)
            installNestJS
            ;;
        l)
            generateLogger
            ;;
        c)
            generateConfig
            ;;
        m)
            generateMain
            ;;
        a)
            generateAppModule
            ;;
        g)
            forGit=true
            ;;
        A) 
            projectName=${OPTARG}
            generateProject
            generateConfig
            generateLogger
            generateAppModule
            generateMain
            extractFromFolder
            ;;
        h)
            displayHelp
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            displayHelp
            ;;
    esac
done