# Raspberry Pi tracker for Neptune R900 smart water meters
### Tracking water consumption

[See an example](https://docs.google.com/spreadsheets/d/1XC9UFRQpvzUn7gjXML7KuaprB8APLXgE_EjsmUM8MWI/edit?usp=sharing) (Please don't judge me by my water usage)

## Introduction



The goals of this project are:
- Use a Raspberry Pi and a RTL-SDR to track my smart water meter (Read: cheap, less than $50)
- Docker to simplify the installation and setup of RTLAMR
- Resin.io to deploy this docker container to the Raspberry Pi in my house
- Logging to a Google Spreadsheet so house members can track usage

## Credit

- @besmasher - Built the excellent [RTLAMR](https://github.com/bemasher/rtlamr) library which actually does all the work of reading the meters.
- [Frederik Granna's](https://bitbucket.org/fgranna/) docker base for setting up RTL-SDR on the Raspberry Pi

## Requirements

- Raspberry Pi 3 (Might work on others, only tested on the 3)
- [RTL-SDR](https://www.amazon.com/NooElec-NESDR-Mini-Compatible-Packages/dp/B009U7WZCA)
- [Resin.io](https://resin.io) for deployment and installation to the Raspberry pi

### Technical chops

You'll need to be able to do the following to get this to work:

- Clone and push a repository with 'git'
- Write a disk image to an SD card
- Basic script editing

## Logging to Google Spreadsheet

I'd love to find a better alternative to this, but at the moment, it's the easiest way to track my water usage.

Quick overview: Google Docs have the option of adding scripts to their spreadsheets, similar to how Visual Basic was integrated into Excel. These scripts can not only modify the spreadsheet, but they can also be called via HTTP. In this case, we deploy a script that allows us to call it from the Raspberry Pi and pass along the current meter reading as a parameter.

Couple of problems needed to be addressed with this script:
- At some point we'll run out of space on the spreadsheet. I solved this by setting a maximum number of rows (5000 right now). After the maximum row is reached, we add a row and at the same time delete the oldest row the top. This keep several months of history for most household users.
- We should ignore updates that are the same meter reading. For my use, it doesn't make just sense to have 50 updates overnight with the same reading. Therefore, the script will only update when the meter reading differs from the previous reading.

Here's the full breakdown:

1. Open my [template spreadsheet](https://docs.google.com/spreadsheets/d/1XC9UFRQpvzUn7gjXML7KuaprB8APLXgE_EjsmUM8MWI/edit?usp=sharing) and make a copy - 'File' > 'Make a copy...'
2. Your new copy will open. Click 'Tools' > 'Script editor'
3. In the script editor page, Change the 'SheetID' to your version of the spreadsheet
    - eg. https://docs.google.com/spreadsheets/d/158hDszrPBudHZkFik2AvQDFTDfzV8mYHq80PyHb4dDo/edit#gid=0 - the SheetId would be '158hDszrPBudHZkFik2AvQDFTDfzV8mYHq80PyHb4dDo'
4. 'File' > 'Save'
5. 'Publish' > 'Deploy as web app...' - Deploy with the following settings
    - Version: 'New'
    - Execute the app as: 'Me'
    - Who has access to the app: 'Anyone, even anonymous'
    - Click 'Deploy'
    - Authoration required prompt will display
    - Click 'Review Permissions'
    - Choose your account and allow access to your Drive
      - There might be some scary messaging here from Google about allowing an unverified script to have access to your account, but the only script that has access is the version you're currently editing.
    - ** Copy the 'Current web app URL:' on the final step after clicking deploy **
6. The URL from the last step is now your URL you'll need to setup in Resin
    - Should look like `https://script.google.com/macros/u/1/s/RandomLookingScriptID/exec`
    - In Resin add the environment variable CURL_API with the value of the script from before, but with '?value=' appended
        -  eg. "https://script.google.com/macros/s/RandomLookingScriptID/exec?value="
    - To test it you can send some data with 'curl: `curl -L https://script.google.com/macros/u/1/s/RandomLookingScriptID/exec?value=10`

