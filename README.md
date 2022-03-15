# github-godot-ci-test

This description is heavily WIP

The goal of this Repository is to provide you with the infos/templates/materials/sources you need to set up your own Git Actions CI Pipeline to deliver your game onto multiple different OS to Steam just by pushing one button


## What is a CI Pipeline?
A CI Pipeline is a fully automated process through which you can compile/export sourcecode into binaries and do multiple steps that you require it to do afterwards, like deploying it to servers, services like steam or platforms.

The Github Actions use Docker Containers (miniturized small Virtual Machine-esque images) which allows to create fresh instances of a certain image(its like a save-state for a pc). As the containers get newly created for every action, conflicts with files from the previous builds or having to clean up those, are a non-thing.

### The rough flow of the github action from this project

The flow is defined in this [File](https://github.com/Reneator/github-godot-ci-test/blob/master/.github/workflows/blank.yml)


The entire workflow/pipeline, works by creating a container for each platform i want to export to and upload those as artifacts to the running workflow.

The "deploy to steam" step waits on all previous jobs to finish (listed in the `needs` param). It  then downloads the artifacts into the container itself, so the steamcmd running on the container can access those files.

It will then use the previously configured infos in the Github Secrets, to login and use the 
```
          depot1Path: windows
          depot2Path: linux
          depot4Path: mac
```

to understand which depot you defined in your steam application will use which folder. The order is defined by the order you have set for those depots in steam (will add how to for this)


# Step by Step

The following introduction will assume you already have your project uploaded to github and the exports are working. If there is interest i will make a step by step tutorial for that as well. So that full beginners in things CI/Git could utilize this.


## Set up the workflow

![image](https://user-images.githubusercontent.com/24807557/158433998-f0537c73-141a-4403-ae87-f1f4c1c06720.png)

then "set up a workflow yourself":

![image](https://user-images.githubusercontent.com/24807557/158434226-0f0031b7-15a6-4457-b6ac-a3a9414051c0.png)

![image](https://user-images.githubusercontent.com/24807557/158436148-9546f114-8331-4389-b0af-9e18b96b47c5.png)
In this view you can now replace the text with the contents of this [File](https://github.com/Reneator/github-godot-ci-test/blob/master/.github/workflows/blank.yml)

When you are done press on "commit" on the top right and select the options that fit best for you. You can potentially just click "commit new file"

Try to change/replace the values that have the `[CHANGE ME]` behind them. The rest should then work as is, when you have added the necessary github secrets.
Try not to change anything else unless you know what you are doing.

The way the workflow file is now set up, it will trigger a build whenever you push a tag. You can adapt/change this in the first 6 lines to react to pushes directly, only trigger in specific branches etc. For this you might need to set up multiple files if you for example want to have a different Branch in git push to a different branch in steam. (Im personally doing this via tags)
Read https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions for reference on the github actions syntax used in the .yml file

The workflow is now set up for the deploySteam to only launch when the windows, max and linux export were successful. If you dont need one of those you can just delete the step and delete it from the `needs` array in the "Deploy to Steam" step


## Test the workflow

Now test if the workflow is set up correctly. The exports should now work correctly at least. The steam deploy we will set up in later steps.

It should then look something like this (depends on the size of the game as well)

![image](https://user-images.githubusercontent.com/24807557/158437500-b924971c-4048-4ef1-a6e6-4b797f36c5ac.png)

You can find the created artifacts when you scroll down and download and test them directly.

In this screen on clicking on a job you can also get more indepth information of what is happening or what went wrong as this directly prints the output on those containers.

## Set up Steam credentials in github secrets to deploy to steam

Github Secrets are a way to save sensitive information without the risk of leaking them. When the data is printed its always encrypted and you can only change the info or remove it but never read/get those values visible.

You can find the secrets here and when you are done it should look like this:

![image](https://user-images.githubusercontent.com/24807557/158439397-ade0fa7c-3dbc-4268-96a1-5e4da4eb1304.png)

To get all the necessary informations, try to use this step by step:
https://github.com/game-ci/steam-deploy#configuration

Tell me if it uses too much implicit information, then i can make a more detailed explanation.

Regarding the "Encode to base64" im on windows and to do that i just use Notepad++ which has a default extension that allows you to do the Base64 Encoding

This mainly affects the config.vdf and the ssfn file content:
- Open the file with Notepad++
- Select all the text (ctrl+A)
- Then in the top line choose Extensions->Mime tools -> Base64 Encode
- Now you can just copy the generated text and put it into the correspondig steam secret

If you have those set up, the steam deploy should work correctly and you should see the build in your partner.steamgames.com Builds of your app.

### Parts where it could break:

- Building depots: Check if you have the proper installations in your steam app and namings active double check with the build file. The value after the `depotXPath` is just the folder that steamcmd is supposed to use to build for the depot
- `depotXPath` as far as i understood it, the Number for X defines which depot will use which folder and here it depends on the order of the depots you have defined in your steamapp.
- Check if you actually have created the Branch in your steam app, as the deployToSteam job does not create a branch and will just throw an error if it doesnt exist.
- To invite a builder account to your project/organization you will have to on one side invite the account to the project, accept it on the builder account email, but then also approve it again on your admin account for that steam app.


## Set up Github pages

When you are using the Web Export you should now have a new branch called `gh-pages`. The files in this branch will be used to host the godot game to your personal github.io url.
First you have to activate the github pages in the repository itself. You can do this in the settings:
![image](https://user-images.githubusercontent.com/24807557/158438116-d3a00e4a-cb30-48b9-aa83-0884c6189b9b.png)

now by clicking on the link in the green you should now have your game start via html5


# Addendum

This Part is about having stuff/tricks out of order that you can use or are good to know.

## one of the exports fail with "cannot find on path X

The godot exports (export-windows etc.) are currently set up for projects where your game-project is located in the root of your repository. If not you would have to move into those before executing the ´godot -v --export´ command via `cd X` (X for the name of the folder)

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
- Deploy to itch.io (can be done with the currently used github action: https://github.com/abarichello/godot-ci you may just have to expand the action/add a new step)
- provide different templates, which are pushing to different branches depending on your current branches etc.



