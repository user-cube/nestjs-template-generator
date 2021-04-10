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


function generateMainDatabase(){
    echo "Generating main.ts with Database URI";
    echo "import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { LoggerService } from './logger/logger.service';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const configService: ConfigService = app.get(ConfigService);
  const logger: LoggerService = new LoggerService();

  app.enableCors();
  logger.verbose(\`Database URI => \${configService.get('database.uri')}\`);
  logger.verbose(\`Application listening on port => \${configService.get('port')}\`);
  await app.listen(configService.get('port'));
}
bootstrap();" > src/main.ts
    echo "File main.ts generated."
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

function generateAppModuleTypeOrm(){
    echo "Geneationg app.module.ts with TypeOrm dependency.";
    npm i --save @nestjs/typeorm typeorm
    if [ "$relationalDatabaseType" = "postgres" ] ; then
        echo "Installing PostgreSQL";
        npm i --save pg
    elif [ "$relationalDatabaseType" = "mysql" ] ; then
        echo "Installing MySQL";
        npm i --save mysql2
    fi
    echo "import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import configuration from './config/configuration';
import { TypeOrmModule } from '@nestjs/typeorm';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [configuration],
    }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (configService: ConfigService) => ({
        type: '$relationalDatabaseType',
        url: configService.get('database.uri'),
        entities: [],
        synchronize: true,
      }),
      inject: [ConfigService],
    }),
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}" > src/app.module.ts
    echo "File app.module.ts generated.";
}

function generateAppModuleMongoose(){
    echo "Geneationg app.module.ts with Mongoose dependency.";
    npm i --save @nestjs/mongoose mongoose
    echo "import { LoggerModule } from './logger/logger.module';
import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { ConfigModule, ConfigService } from '@nestjs/config';
import configuration from './config/configuration';

@Module({
  imports: [
    LoggerModule,
    ConfigModule.forRoot({
      isGlobal: true,
      load: [configuration],
    }),
    MongooseModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (configService: ConfigService) => ({
        uri: \`\${configService.get('database.uri')}\`,
      }),
      inject: [ConfigService],
    }),
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}" > src/app.module.ts
    echo "File app.module.ts generated.";
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
    nest g module logger --no-spec;
    echo "import { Module } from '@nestjs/common';

@Module({
  imports: [],
  controllers: [],
  providers: [LoggerService],
  exports: [LoggerService],
})
export class LoggerModule {}" > src/logger/logger.module.ts
    nest g service logger --no-spec;
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
    projectName="${projectName/_/-}"
    nest new $projectName;
    cd $projectName;
    rm src/app.controller.spec.ts;
    rm src/app.controller.ts;
    rm src/app.service.ts
    
}

function generateMicroservice(){
    echo "Creating Microservice";
    npm i --save @nestjs/microservices
    echo "import { NestFactory } from '@nestjs/core';
import { Transport, MicroserviceOptions } from '@nestjs/microservices';
import { AppModule } from './app.module';
import { ConfigService } from '@nestjs/config';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const configService = app.get(ConfigService);

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.TCP,
  });

  await app.startAllMicroservicesAsync();
}

bootstrap();
" > src/main.ts
    echo "Microservice created.";
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
	echo "-i  Install NestJS";
    echo "-l  Generate logger";
    echo "-c  Generate Configurarion";
    echo "-m  Generate file main.ts";
    echo "-a  Generate App Module";
    echo "-M  Install with Mongoose Configurations"
    echo "-gM Install with Mongoose Configurations and export to git structure";
    echo "-A  Generate new Project and all configurations";
    echo "-gA Generate new Project and all configurations and export to git structure";
    echo "-d  Define SQL Database Type"
    echo "-T  Generate new Project with TypeORM and all configurations";
    echo "-gT Generate new Project with TypeORM and all configurations and export to git structure";
    echo "-S  Generate new Project using Microservices"
	echo "-gS  Generate new Project using Microservices"
    exit 1;
}

checkInstallation
relationalDatabaseType="postgres"
forGit=false

while getopts "vihlcmagA:M:T:S:" arg; do
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
        M)
            projectName=${OPTARG}
            generateProject
            generateConfig
            generateLogger
            generateAppModuleMongoose
            generateMainDatabase
            extractFromFolder
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
        T)
            projectName=${OPTARG}
            generateProject
            generateConfig
            generateLogger
            generateAppModuleTypeOrm
            generateMainDatabase
            extractFromFolder
            ;;
        S)
            projectName=${OPTARG}
            generateProject
            generateConfig
            generateLogger
            generateAppModule
            generateMicroservice
            extractFromFolder
            ;;
        d)
            relationalDatabaseType=${OPTARG}
            ;;
        h)
            displayHelp
            ;;
        v)
            echo "0.0.4";
            ;;
        \?)
            exit 0;
            ;;
    esac
done