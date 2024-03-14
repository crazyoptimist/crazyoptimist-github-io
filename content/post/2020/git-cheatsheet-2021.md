---
title: "Git Cheatsheet for Minimalists"
date: 2020-12-04T13:20:27-05:00
categories: ["devops"]
---

#### Basic Git Concepts

- Working copy (working tree file): It refers to the file in the repository that appears on the hard disk.
- Index (staging area or cache): it refers to you have `git add`-ed, or, what would be committed if you were to run `git commit`.
- HEAD: It refers to the "current" or "active" branch, when we need to check out a branch (referring to your attempt to match the branch with what is in the working copy), only one can be checked out at a time.

#### git init

Initialize a new git repository

```bash
git init
```

#### git add

Stage files

```bash
git add main.go Makefile          # Stages multiple files
git add .                         # Stages the current directory and all its content
```

#### git restore

Unstage files (undo `git add`)

```bash
git restore --staged server.go    # Copies the last version of server.go from repo to index
```

Discard local changes

```bash
git restore server.go             # Copies server.go from index to working directory
git restore server.go main.go     # Restores multiple files in working directory
git restore .                     # Discards all local changes (except untracked files)
git clean -fd                     # Removes all untracked files
```

Restore earlier version of a file

```bash
git restore --source=HEAD~2 server.go
```

To recap `git restore`:

```bash
# Restoring the working tree from the index
git restore main.go

# Equivalent to
git restore --worktree main.go

# Restoring index content from HEAD
git restore --staged main.go

# Restoring the working tree and index from HEAD
git restore --staged --worktree main.go
```

#### git status

View status

```bash
git status                        # Full status
git status -s                     # Short status
```

#### git commit

Commit staged files

```bash
git commit                        # Opens the default editor to type a long message
git commit -m "Message"           # Commits with a one-line message
```

Amend the last commit

```bash
git commit --amend
```

Skip the staging area

```bash
git commit -am "Message"
```

#### git rm

Remove files

```bash
git rm bs.go                      # Removes from working directory and staging area
git rm --cached bs.go             # Removes from staging area only
```

Remove a directory from remote repository after adding them to .gitignore

```bash
git rm -r --cached node_modules
git commit -m 'remove ignored directory node_modules'
git push origin main
```

#### git mv

Rename or move files

```bash
git mv server.go main.go
```

#### git diff

View staged/unstaged changes

```bash
git diff                          # Shows unstaged changes
git diff --staged                 # Shows staged changes
git diff --cached                 # Same as the above
```
Compare commits

```bash
git diff HEAD~2 HEAD              # Shows the changes between two commits
git diff HEAD~2 HEAD file.txt     # Changes to file.txt only
```

#### git log

View history

```bash
git log                           # Full history
git log --oneline                 # Summary
git log --reverse                 # Lists the commits from the oldest to the newest
```

View history of a file

```bash
git log file.txt                  # Shows the commits that touched file.txt
git log --stat file.txt           # Shows statistics (the number of changes) for file.txt
git log --patch file.txt          # Shows the patches (changes) applied to file.txt
```


#### git show

View a commit

```bash
git show 921a2ff                  # Shows the given commit
git show HEAD                     # Shows the last commit
git show HEAD~2                   # Two steps before the last commit
git show HEAD:server.go           # Shows the version of server.go stored in the last commit
```

#### git log

View the history

```bash
git log --stat                    # Shows the list of modified files
git log --patch                   # Shows the actual changes (patches)
```

Filter the history

```bash
git log -3                        # Shows the last 3 entries
git log --author=crazyoptimist
git log --before="2021-01-01"
git log --after="one week ago"
git log --grep="GUI"              # Commits with "GUI" in their message
git log -S"GUI"                   # Commits with "GUI" in their patches
git log hash1..hash2              # Range of commits
git log file.txt                  # Commits that touched file.txt
```

Format the log output

```bash
git log --pretty=format:"%an committed %H"
```

#### git config

Set committer(without `--global` flag, it affects the current repo only)

```bash
git config --global user.name crazyoptimist
git config --global user.email crazyoptimist@mail.com
```

Default init branch name

```bash
git config --global init.defaultBranch main
```

Create an alias

```bash
git config --global alias.lg "log --oneline"
```

Auto-CRLF

What's this? It's all about line endings.
- Windows: CR (Carriage Return \r) and LF (LineFeed \n) pair
- OSX, Linux: LF (LineFeed \n)

```bash
git config --global core.autocrlf input           # Unix
git config --global core.autocrlf true            # Windows
```

#### git bisect

Find bad commits

```bash
git bisect start
git bisect bad                    # Marks the current commit as a bad commit
git bisect good ca49180           # Marks the given commit as a good commit
git bisect reset                  # Terminates the bisect session
```

#### git shortlog

Find contributors

```bash
git shortlog
```

#### git blame

Find authors of lines

```bash
git blame file.txt                # Shows the author of each line in file.txt
```

#### git tag

Tagging

```bash
git tag v1.0                            # Tags the last commit as v1.0
git tag v1.0 5e7a828                    # Tags an earlier commit
git tag                                 # Lists all the tags
git tag -d v1.0                         # Deletes the given tag
git tag -a v1.0.0-rc1                   # Creates an annotated tag
git push origin v1.0.0-rc1              # Pushes the tag to origin
git push origin --delete v1.0.0-rc1     # Deletes the tag from origin
git push --tags                         # Push all tags
```

#### git switch

```bash
git switch dev                      # Switch to branch `dev`
git switch -c dev                   # Create and switch
git switch -                        # Switch to the previous branch
git switch -d master~1              # Switch to the commit `master~1`
```

#### git branch

```bash
git branch bugfix                   # Creates a new branch called bugfix
git branch -d bugfix                # Deletes the bugfix branch
git branch --merged                 # Shows the merged branches
git branch --no-merged              # Shows the unmerged branches
git branch -r                       # Shows remote tracking branches
git branch -vv                      # Shows local & remote tracking branches
git branch -D feature/one feature/two bugfix/one
```

#### compare branches

```bash
git log master..bugfix              # Lists the commits in the bugfix branch not in master
git diff master..bugfix             # Shows the summary of changes
```

#### git stash

```bash
git stash push -m "some comments"   # Creates a new stash. Without `push`, does the same.
git statsh pop 1                    # Apply and remove the given stash from stash stack
git stash list                      # Lists all the stashes
git stash show stash@{1}            # Shows the given stash
git stash show 1                    # shortcut for stash@{1}
git stash apply 1                   # Applies the given stash to the working dir
git stash drop 1                    # Deletes the given stash
git stash clear                     # Deletes all the stashes
```

#### git merge

```bash
git merge bugfix                    # Merges the bugfix branch into the current branch
git merge --no-ff bugfix            # Creates a merge commit even if FF is possible
git merge --squash bugfix           # Performs a squash merge
git merge --abort                   # Aborts the merge
```

#### git rebase

```bash
git rebase master                   # Changes the base of the current branch against master
```

Interactively rebase

```bash
git rebase -i HEAD~5
```

These two commands do the same(changing ownership of previous commits) for last x commits

```bash
git rebase -i HEAD~6 -x "git commit --amend --author 'Author Name <username@domain.com>' --no-edit"
git rebase -i COMMIT_SHA -x "git commit --amend --author 'Author Name <username@domain.com>' -CHEAD"
```

#### git cherry-pick

```bash
git cherry-pick dad47ed             # Applies the given commit on the current branch
```

#### git clone

```bash
git clone url
```

#### git fetch

```bash
git fetch origin master             # Fetches master from origin
git fetch                           # Shortcut for "git fetch CURRENT_BRANCH"
```

#### git pull

```bash
git pull                            # Fetch & merge current remote branch into the current local branch
git pull --rebase                   # Fetch & rebase current remote branch into the current local branch
git push origin master              # Pushes master to origin
git push                            # Shortcut for "git push origin CURRENT_BRANCH"
```

#### git push

```bash
git push -u origin bugfix           # Pushes bugfix to origin
git push -d origin bugfix           # Removes bugfix from origin
```

#### git remote

Add/remove remotes

```bash
git remote                          # Shows remote repos
git remote add upstream url         # Adds a new remote called upstream
git remote rm upstream              # Remotes upstream
```

Purge all non-existing remote branches from your local repo

```bash
git remote prune origin --dry-run                 # Runs preflight check
git remote prune origin
```

#### git reset

Undo commits

```bash
git reset --soft HEAD^              # Removes the last commit, keeps the changes staged
git reset --mixed HEAD^             # Unstages the changes as well
git reset --hard HEAD^              # Completely removes the changes
```

Undo x commits

```bash
git reset --hard HEAD~x
```

#### git revert

Revert commits

```bash
git revert 72856ea                  # Reverts the given commit
git revert HEAD~3..                 # Reverts the last three commits
git revert --no-commit HEAD~3..
```

#### git reflog

Recover lost commits

```bash
git reflog                          # Shows the history of HEAD
git reflog show bugfix              # Shows the history of bugfix pointer
```

Happy gitting! :)
