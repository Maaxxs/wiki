---
title: "Maven"
date: 
tags: ["wiki"]
ShowLastUpdated: true
toc: true
draft: false
---


_created by [Noah](https://gitlab.com/DrNochi)_

- Project and Build Management Tool

  - Standardization (convention over configuration)
  - Dependency management
  - Documentation & reporting

- Process-Management

---

## Project Object Model

- pom.xml
  - Central config file

```xml
<!-- Minimal POM -->
<project>
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.unique.identifier.of.project</groupId>
    <artifactId>artifact-name</artifactId>
    <version>1</version>
</project>
```

### Properties

Specified by `<properties><PROP>` (VALUE) and referenced by `${PROP}`. Maven may also declare default properties (`${project.PROP}`, `${maven.PROP}`).
May also be specified on the command line

### Dependencies

Specifies dependencies of artifacts. Dependencies are automatically resolved and pulled from a repository.
Declared by `<dependencies><dependency>` (groupId, artifactId, version, scope, ...)

### Inheritance

POMs inherit elements from parent POMs. The root of the inheritance hierarchy is the "Super POM".
Specified by either `<parent>` (groupId, artifactId, version) or `<modules><module>` (RELATIVE_PATH_TO_CHILD_POM)

> Used to specify common elements in a root/parent POM

### Build Environment

Specifies the build environment
Declared in `<build>`

- `directory`
  - Output directory
- `finalName`
  - Final artifact name
- `sourceDirectory`
- `outputDirectory`
  - Contains class files for sources
- `testSourceDirectory`
- `testOutputDirectory`
  - Contains class files for test sources
- `resources` > `resource` > ...
- `testResources` > `testResource` > ...
- `plugins` > `plugin` > groupId, artifactId, version, ...

#### Plugins

Used to customize the build lifecycle. Default plugins are part of the "Super POM"

### Profiles

Profiles can be used to modify elements of the POM depending on activation conditions
Specified by `<profiles><profile>` (id, activation, MODIFICATIONS, ...).
May also be activated by the command line

> For examlple used for specifing file paths for windows and linux

### Repositories

Tells maven from where to fetch dependencies and other artifacts.
Specified by `<repositories><repository>` (id, name, url, ...)

Additionally to these remote repositories there is always the local repository `~/.m2` that is mostly used as an artifact cache

#### Plugin Repositories

Tells maven from where to fetch plugin artifacts.
Specified by `<pluginRepositories><pluginRepository>`

---

## Build Lifecycle

Cleaning

- `clean`
  - Remove all files from previous bilds

Building (default)

- `validate`
  - Validate necessary information is available & correrct
- `initialize`
  - Initialize build
- `compile`
  - Compile sources
- `test-compile`
  - Compile test sources
- `test`
  - Run tests
- `package`
  - Generate artifact
- `integration-test`
  - Deploy the artifact & run integration tests
- `verify`
  - Verify the artifact (e.g. quality criteria)
- `install`
  - Install to local repository
- `deploy`
  - Deploy to remote repository

Site documentation

- `site`
  - Generate documentation
- `site-deploy`
  - Deploy documentation

### Plugin Goals

Plugins have different goals (`PLUGIN:GOAL`), these make up the basic building blocks of the process. They are bound to different build phases, and are therefore run during the build lifecycle

---

## Default Project Structure

```conf
pom.xml

src/
    main/
        java/
        resouces/

    test/
        java/
        resources/

    it/ (integration tests)

    site/ (documentation)

LICENSE.txt
README.txt
NOTICE.txt
```

---

## Maven Assemblies

The `maven-assembly-plugin` can be used to distribute the project (`.jar`s, README, LICENSE, documentation, ...)
For each type of distribution a descriptor is created, that specifies the format and content of the distribution archive

## Apache Ant

No default build lifecycle. Low standardization
