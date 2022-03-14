# github-godot-ci-test

This description is heavily WIP

The goal of this Repository is to provide you with the infos/templates/materials/sources you need to set up your own Git Actions CI Pipeline to deliver your game onto multiple different OS to Steam just by pushing one button


## What is a CI Pipeline?
A CI Pipeline is a fully automated process through which you can compile/export sourcecode into binaries and do multiple steps that you require it to do afterwards, like deploying it to servers, services like steam or platforms.

The Github Actions use Docker Containers (miniturized small Virtual Machine-esque images) which allows to create fresh instances of a certain image(its like a save-state for a pc). As the containers get newly created for every action, conflicts with files from the previous builds or having to clean up those, are a non-thing.

The entire workflow/pipeline, works by creating a container for each platform i want to export to and upload those as artifacts to the running workflow.

The "deploy to steam" step waits on all previous jobs to finish (listed in the `needs` param). It  then downloads the artifacts into the container itself, so the steamcmd running on the container can access those files.

It will then use the previously configured infos in the Github Secrets, to login and use the 
```
          depot1Path: windows
          depot2Path: linux
          depot4Path: mac
```

to understand which depot you defined in your steam application will use which folder. The order is defined by the order you have set for those depots in steam (will add how to for this)


## Set up your project

In your project you need to have to have created the exports you want to use. The name of those export-settings defining the name you have to use in the yml file.


## Set up your required steam-data:
used parts of the description from here:
https://github.com/game-ci/steam-deploy#3-configure-for-deployment

### Add a builder Account

### Use MFA (Multi-factor-authentication) To protect your project

### Set up your credentials as Secrets in Github

## Set up Steam to work properly

To deploy to a branch on steam the branch must already exist. The Branch wont be created and you will receive an error-message


## Set up your Github action


## Set up github pages for your repository


## How does the process work step by step?

## Deploy to different steam branches
I currently have this working by creating an additional workflow script, copy the content of the other script and change the tag

```
  push:
    # Pattern matched against refs/tags
    tags:        
      - '*'
```

to

```
  push:
    # Pattern matched against refs/tags
    tags:        
      - '{part that signifies to deploy to other branch}*'
```

Also change the steam-branch to the one you want to use


For my personal project i use:
```
tags:
  - 'playtest*'
```
Which means whenever i push a tag with playtest, this script gets triggered, but the other does not.

This works for me, because im working on one branch (solo developer) and mostly use tags for releases, but if you work with 

## currently researching into these topics:
- Deploy to itch.io
- provide different templates, which are pushing to different branches depending on your current branches etc.

## FAQ

### my build fails with "cannot find on path X

The build files are made for projects where your game-project is located in the root of your repository. If not, you will have to change some commands around, switching to the respective project folder.
