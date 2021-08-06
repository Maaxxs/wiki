---
title: "Jenkins on Ubuntu"
date: 
tags: ["wiki"]
ShowLastUpdated: false
toc: true
draft: false
---

# Jenkins on Ubuntu

## Installation

### Install Java 8

```sh
sudo apt install openjdk-8-jre
```

### Install build tools

```sh
sudo apt install build-essentials
```

### Jenkins

For Jenkins refer to [Jenkins on Debian](https://jenkins.io/doc/book/installing/#debianubuntu)

```sh
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins
```

## Plugins

- GitLab
- GitLab Hook
- Warnings Next Generation
- Green Balls

## GitLab Hook Plugin

1. Create a new user in Jenkins (Allow sign-up) with the follwing rights
   - Overall: `Read`
   - Job: `Read, Build`
2. Top right corner `User -> Configure:API Token`. Add a Token. Save.
3. In Gitlab `YourProject->Settings->Integrations`. Fill the URL

```sh
http://USERNAME:API_TOKEN@IP_Address:port/pathTo/project
```
