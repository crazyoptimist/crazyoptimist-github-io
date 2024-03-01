---
title: "Hugo - An Awesome Way to Enjoy Your Blog Life as an Engineer"
date: 2020-09-23T18:28:24-05:00
categories: ["go"]
---

I have just finished migrating my blog from Ghost self-hosting to Hugo. I am more than happy to use: { framework: "Hugo", hosting: "Firebase", cicd: "CircleCI" }. I just wanted to share the full process of how I got it done, which was not a piece of cake. You see, it's not just playing around or a development environment; it's for "production". There are plenty of great resources available that explain how to blog with Hugo, install Hugo themes, and so on. In this post, I will focus on the challenges I faced during this migration.

When you run the `hugo server` command on your local machine, it seems to work flawlessly. However, when you try to deploy it to the cloud, the first issue you may encounter is the `baseURL` setting in the Hugo config file. Here is a portion of my config file that pertains to this issue:

```toml
relativeURLs = true
title = "crazyoptimist"
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

The main point I want to make is about the first line. It allows us to use any hostname as a `baseURL` so that stylesheets and other assets can have a correctly accessible URL.

The next step is to configure Firebase deployment. You just need to set up your Firebase hosting and test if it is deployed correctly, which is pretty straightforward.

Here is my firebase.json file:

```js
{
  "hosting": {
    // Site name in firebase
    "site": "crazyoptimist-net",
    // Build artifacts dir, ./public in hugo, you know, it will be the web root on the fly
    "public": "public",
    "ignore": [
      // Do not bundle these files to upload
      "firebase.json",
      "**/.*"
    ]
  }
}
```

Here is the list of Firebase CLI commands used:

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

As you may have noticed, you need to add the `$FIREBASE_TOKEN` as an environment variable to your CircleCI project settings. With this setup, you can blog anywhere using your favorite editor (hopefully VIM!). Once you push your new content to Git, it will be live in less than a minute thanks to the CircleCI pipeline.

I apologize if my explanation lacked some nitty-gritty details. Wish I were a full-time blogger. :X

Happy blogging gents! 😎
