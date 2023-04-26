---
title: "How to Deploy Next.js App to AWS EC2 in Production and Set up CI/CD with Github Actions"
date: 2022-02-04T11:06:09-06:00
categories: ["devops"]
featured: true
---

Yo!

In this article, we'll be discussing how to deploy a Next.js app to AWS EC2 and set up continuous integration and deployment using Github Actions.

Before proceeding, you will need to have the infrastructure ready on AWS, which can be deployed manually or by using Terraform code. I'll be skipping the infrastructure setup part for the purpose of this article.

First things first, we need to SSH into the EC2 instance. Once you're logged in, run this script to install Node.js on the machine:

{{< gist CrazyOptimist e003588c2c667ea0fb6b81bba34b662e >}}

Now you can install `yarn` and `pm2` globally:

```bash
source ~/.bashrc
npm install -g yarn pm2
```

The next step is to clone your Next.js app repo and cd to the project root directory. To automate the subsequent `git pull` commands, we are going to create a ssh key pair and use it.  
Create a classic ssh key pair(without a passphrase) first:

```bash
cd ~/.ssh
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

Use `github` when you are asked for a file name, then you will have two files `github` and `github.pub` in the `~/.ssh` directory.  
Add the public key to `authorized_keys`:

```bash
cat ~/.ssh/github.pub >> authorized_keys
```

Add the private key to **Deploy Keys** section in your github repo settings.

```bash
cat ~/.ssh/github
```

Now you are ready to clone the repo in ssh mode! Phew~

```bash
cd ~
git clone git@github.com:username/awesome-nextapp.git
```

Install dependencies and build the next app, and run it in production mode with pm2.

```bash
cd ~/awesome-nextapp
yarn install
yarn build
pm2 start npm --name "nextapp" -- start
```

Your next.js website should be up and running at this point.

```bash
curl localhost:3000
```

Create `~/deploy.sh` to use in Github Actions.

```bash
#!/bin/bash
# use the correct node version for below path
PATH="$PATH:/home/ubuntu/.nvm/versions/node/v16.13.2/bin/"
cd ~/awesome-nextapp
git pull
yarn install
yarn build
pm2 restart nextapp
```

Try and run the script.

```bash
bash deploy.sh
```

If you verified the script ran successfully, you are very awesome!

Now, let's move on with settig up Github Actions. The first thing we need to do is to create a `yaml` file for it.

```bash
cd ~/awesome-nextapp
mkdir .github && mkdir -p .github/workflows
touch .github/workflows/frontend.yml
```

Copy and paste below content.

```txt
name: Frontend Next.js CI

# on: [push]
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:

    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [16.x]

    steps:
      - name: Checkout the repo
        uses: actions/checkout@v2
      - name: Use Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v2
        with:
          node-version: ${{ matrix.node-version }}
      - name: Install yarn
        run: npm install -g yarn
      - name: Get yarn cache directory path
        id: yarn-cache-dir-path
        run: echo "::set-output name=dir::$(yarn cache dir)"
      - uses: actions/cache@v2
        id: yarn-cache # use this to check for `cache-hit` (`steps.yarn-cache.outputs.cache-hit != 'true'`)
        with:
          path: ${{ steps.yarn-cache-dir-path.outputs.dir }}
          key: ${{ runner.os }}-yarn-${{ hashFiles('**/yarn.lock') }}
          restore-keys: |
            ${{ runner.os }}-yarn-
      - uses: actions/cache@v2
        with:
          path: '**/node_modules'
          key: ${{ runner.os }}-modules-${{ hashFiles('**/yarn.lock') }}
      - name: Install deps
        working-directory: .
        if: steps.yarn-cache.outputs.cache-hit != 'true'
        run: yarn install
      - name: Check codebase
        working-directory: .
        run: yarn build

  deploy:

    needs: build
    runs-on: ubuntu-latest

    steps:
      - name: Install SSH Key
        uses: shimataro/ssh-key-action@v2
        with:
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          known_hosts: 'placeholder'
      - name: Adding Known Hosts
        run: ssh-keyscan -H ${{ secrets.FE_SERVER_IP }} >> ~/.ssh/known_hosts
      - name: Run deploy script
        run: ssh ubuntu@${{ secrets.FE_SERVER_IP }} bash deploy.sh
```

Go to your repo **Settings -> Secrets -> Actions secrets** and add two secrets:

- `SSH_PRIVATE_KEY` can be grabbed by `cat ~/.ssh/github` on the server
- `FE_SERVER_IP` can be grabbed by `curl ipinfo.io/ip` on the server

Commit the workflow file in the repository and push it, then check how the workflow runs in the **Actions** tab of your repository. Setting up CI/CD right usually takes some effort and experimentation, so if you have followed through thus far, that's great!

If you are curious about deploying the entire infrastructure (VPC, EC2, ALB, ACM, Route53, S3) as code in Terraform, it can be a whole other topic. Please feel free to email me, and I'll be happy to teach you patiently. :X

Happy coding! 😎
