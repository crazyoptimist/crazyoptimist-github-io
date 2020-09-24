---
title: "Hugo - An Awesome Way to Enjoy Your Blog Life as an Engineer"
date: 2020-09-23T18:28:24-05:00
categories: ["golang"]
---
I've just finished the migration of my blog from ghost self hosting to hugo.  
I'm more than happy to use { framework: "Hugo", hosting: "Firebase", cicd: "CircleCI" }.  
Just wanted to share the full path how I got it done, which was not a piece of cake, you know, it's like kinda "production", not a playing around or dev env.  
There are tons of good materials explaining how to blog with hugo, install hugo themes, etc. I'm just going to mention about the road blockers I met during this migration.  
***
When you run the `hugo server` command on your local machine, it seems working flawlessly, but the first thing you may stuck when you try to deploy it to the cloud is `baseURL` in the hugo config file.  
Here is my config file, a part of it exactly:
```toml
relativeURLs = true
title = "Crazy Optimist"
theme = "hugo-coder"
languagecode = "en"
defaultcontentlanguage = "en"

paginate = 20
canonifyurls = true

pygmentsstyle = "b2"
pygmentscodefences = true
pygmentscodefencesguesssyntax = true

disqusShortname = "crazy-optimist"
```
The first line is the point I'm going to mention. Yes, it enables us to use any host name as base url so that your stylesheets and other assets can have correct accessible url.  

The next thing is just configuring firebase deployment. You just need to setup your firebase hosting and test if it's really deployed correctly, which is pretty straightforward.  

Here is my firebase.json file:
```json
{
  "hosting": {
    //site name in firebase
    "site": "crazyoptimist-net",
    //build artifacts dir, ./public in hugo, you know, it will be the web root on the fly
    "public": "public",
    "ignore": [
      //do not bundle these files to upload
      "firebase.json",
      "**/.*"
    ]
  }
}
```

Here is the list of firebase cli commands used:
```bash
# normal login
firebase login
# just a normal deploy scenario for firebase
firebase deploy --only hosting:crazyoptimist-net
# get your firebase token
firebase login:ci
# then you can use this command for automation
firebase deploy --token "$FIREBASE_TOKEN"
```

And the final point is here in CircleCI config(`.circleci/config.yml`) file:
```yaml
version: 2.1
orbs:
  firebase-deploy: azdevs/firebase-deploy@1.0.0
  hugo: circleci/hugo@1.0.0

jobs:
  build:
    docker:
      - image: cibuilds/hugo
    steps:
      - checkout
      - hugo/install:
          version: 0.75.1
      - hugo/hugo-build:
          extra-flags: '--gc --minify'
      - persist_to_workspace:
          root: ~/project
          paths:
            - public
            - resources

  deploy:
    docker:
      - image: 'circleci/node:lts'
    steps:
      - checkout
      - attach_workspace:
          at: ~/project
      - firebase-deploy/deploy:
          token: '$FIREBASE_TOKEN'
          alias: 'crazyoptimist-net'
workflows:
  build-and-deploy:
    jobs:
      - build
      - deploy:
          requires:
            - build
```

As you may guess, you need to add the $FIREBASE_TOKEN as an env variable to your CircleCI project settings.  
Yes, it should be working, you can blog anywhere using your favorite editor(mostly the VIM!), once you push your new contents to git, it will be live in less than a minute thanks to the CircleCI pipeline.  
Sorry for not enough explanation about all the nitty-gritty, wish I were a full time blogger. :(  
Happy blogging gents! 😎
