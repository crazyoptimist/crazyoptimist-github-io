---
title: "How to Use Git Rebase in a Practical Situation"
date: 2020-02-24T23:39:13-05:00
categories: ["devops"]
---

Let’s say there are two pull requests open on a project repository.

Each change has its own branch like this:

- master
- feature/add-base64-endpoint
- feature/add-user-agent-endpoint

The challenge is to use git rebase to add both changes to master. When you finished, your master branch should have three commits in the following order:

>* feat: add user-agent endpoint
>* feat: add base64 endpoint
>* init

Okay, let’s go!

```bash
git clone repo_url
git status
git checkout feature/add-base64-endpoint
git rebase master
git status
git checkout master
git merge feature/add-base64-endpoint
git status
git checkout feature/add-user-agent-endpoint
git rebase master
```

Oops! You now see `rebase conflict`!

You need to check the code and fix it. Fortunately VS Code provides great hints for you to do that.

Once you fix it, do like this:

```bash
git add .
git rebase --continue
git checkout master
git status
git checkout master
git merge feature/add-user-agent-endpoint
git status
git log
```

Boom! You must be done!

Happy coding! 😉
