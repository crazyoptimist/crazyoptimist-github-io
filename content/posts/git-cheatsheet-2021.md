---
title: "Git Cheatsheet - 2021"
date: 2020-12-04T13:20:27-05:00
categories: ["devops","cicd"]
---
***
[Creating Snapshots](/posts/git-cheatsheet-2021/#creating-snapshots)  
[Browsing History](/posts/git-cheatsheet-2021/#browsing-history)  
[Branching & Merging](/posts/git-cheatsheet-2021/#branching--merging)  
[Collaboration](/posts/git-cheatsheet-2021/#collaboration)  
[Rewriting History](/posts/git-cheatsheet-2021/#rewriting-history)  
[Housekeeping(Personal Favorites)](/posts/git-cheatsheet-2021/#housekeepingpersonal-favorites)  
***
### Creating Snapshots
#### Initializing a repository
```bash
git init
```
#### Staging files
```bash
git add file1.js file2.js # Stages multiple files
git add . # Stages the current directory and all its content
```
#### Viewing the status
```bash
git status # Full status
git status -s # Short status
```
#### Committing the staged files
```bash
git commit -m “Message” # Commits with a one-line message
git commit # Opens the default editor to type a long message
```
#### Skipping the staging area
```bash
git commit -am “Message”
```
#### Removing files
```bash
git rm file1.js # Removes from working directory and staging area
git rm --cached file1.js # Removes from staging area only
```
#### Renaming or moving files
```bash
git mv file1.js file1.txt
```
#### Viewing the staged/unstaged changes
```bash
git diff # Shows unstaged changes
git diff --staged # Shows staged changes
git diff --cached # Same as the above
```
#### Viewing the history
```bash
git log # Full history
git log --oneline # Summary
git log --reverse # Lists the commits from the oldest to the newest
```
#### Viewing a commit
```bash
git show 921a2ff # Shows the given commit
git show HEAD # Shows the last commit
git show HEAD~2 # Two steps before the last commit
git show HEAD:file.js # Shows the version of file.js stored in the last commit
```
#### Unstaging files (undoing git add)
```bash
git restore --staged file.js # Copies the last version of file.js from repo to index
```
#### Discarding local changes
```bash
git restore file.js # Copies file.js from index to working directory
git restore file1.js file2.js # Restores multiple files in working directory
git restore . # Discards all local changes (except untracked files)
git clean -fd # Removes all untracked files
```
#### Restoring an earlier version of a file
```bash
git restore --source=HEAD~2 file.js
```
### Browsing History
#### Viewing the history
```bash
git log --stat # Shows the list of modified files
git log --patch # Shows the actual changes (patches)
```
#### Filtering the history
```bash
git log -3 # Shows the last 3 entries
git log --author=“Mosh”
git log --before=“2020-08-17”
git log --after=“one week ago”
git log --grep=“GUI” # Commits with “GUI” in their message
git log -S“GUI” # Commits with “GUI” in their patches
git log hash1..hash2 # Range of commits
git log file.txt # Commits that touched file.txt
```
#### Formatting the log output
```bash
git log --pretty=format:”%an committed %H”
```
#### Creating an alias
```bash
git config --global alias.lg “log --oneline"
```
#### Viewing a commit
```bash
git show HEAD~2
git show HEAD~2:file1.txt # Shows the version of file stored in this commit
```
#### Comparing commits
```bash
git diff HEAD~2 HEAD # Shows the changes between two commits
git diff HEAD~2 HEAD file.txt # Changes to file.txt only
```
#### Checking out a commit
```bash
git checkout dad47ed # Checks out the given commit
git checkout master # Checks out the master branch
```
#### Finding a bad commit
```bash
git bisect start
git bisect bad # Marks the current commit as a bad commit
git bisect good ca49180 # Marks the given commit as a good commit
git bisect reset # Terminates the bisect session
```
#### Finding contributors
```bash
git shortlog
```
#### Viewing the history of a file
```bash
git log file.txt # Shows the commits that touched file.txt
git log --stat file.txt # Shows statistics (the number of changes) for file.txt
git log --patch file.txt # Shows the patches (changes) applied to file.txt
```
#### Finding the author of lines
```bash
git blame file.txt # Shows the author of each line in file.txt
```
#### Tagging
```bash
git tag v1.0 # Tags the last commit as v1.0
git tag v1.0 5e7a828 # Tags an earlier commit
git tag # Lists all the tags
git tag -d v1.0 # Deletes the given tag
```
### Branching & Merging
#### Managing branches
```bash
git branch bugfix                   # Creates a new branch called bugfix
git checkout bugfix                 # Switches to the bugfix branch
git switch bugfix                   # Same as the above
git switch -C bugfix                # Creates and switches
git branch -d bugfix                # Deletes the bugfix branch
```
#### Comparing branches
```bash
git log master..bugfix              # Lists the commits in the bugfix branch not in master
git diff master..bugfix             # Shows the summary of changes
```
#### Stashing
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
#### Merging
```bash
git merge bugfix                    # Merges the bugfix branch into the current branch
git merge --no-ff bugfix            # Creates a merge commit even if FF is possible
git merge --squash bugfix           # Performs a squash merge
git merge --abort                   # Aborts the merge
```
#### Viewing the merged branches
```bash
git branch --merged                 # Shows the merged branches
git branch --no-merged              # Shows the unmerged branches
```
#### Rebasing
```bash
git rebase master                   # Changes the base of the current branch
```
#### Cherry picking
```bash
git cherry-pick dad47ed             # Applies the given commit on the current branch
```
### Collaboration
#### Cloning a repository
```bash
git clone url
```
#### Syncing with remotes
```bash
git fetch origin master             # Fetches master from origin
git fetch origin                    # Fetches all objects from origin
git fetch                           # Shortcut for “git fetch origin”
git pull                            # Fetch + merge
git push origin master              # Pushes master to origin
git push                            # Shortcut for "git push origin master"
```
#### Sharing tags
```bash
git push origin v1.0                # Pushes tag v1.0 to origin
git push origin —delete v1.0
```
#### Sharing branches
```bash
git branch -r                       # Shows remote tracking branches
git branch -vv                      # Shows local & remote tracking branches
git push -u origin bugfix           # Pushes bugfix to origin
git push -d origin bugfix           # Removes bugfix from origin
```
#### Managing remotes
```bash
git remote                          # Shows remote repos
git remote add upstream url         # Adds a new remote called upstream
git remote rm upstream              # Remotes upstream
```
### Rewriting History
#### Undoing commits
```bash
git reset --soft HEAD^ # Removes the last commit, keeps changed staged
git reset --mixed HEAD^ # Unstages the changes as well
git reset --hard HEAD^ # Discards local changes
```
#### Reverting commits
```bash
git revert 72856ea # Reverts the given commit
git revert HEAD~3.. # Reverts the last three commits
git revert --no-commit HEAD~3..
```
#### Recovering lost commits
```bash
git reflog # Shows the history of HEAD
git reflog show bugfix # Shows the history of bugfix pointer
```
#### Amending the last commit
```bash
git commit --amend
```
#### Interactive rebasing
```bash
git rebase -i HEAD~5
```
### Housekeeping(Personal Favorites)
#### Auto-CRLF
```bash
git config --global core.autocrlf input # Nix
git config --global core.autocrlf true  # Windows
```
#### Default init branch name
```bash
git config --global init.defaultBranch main
```
#### Purge all un-existing remote branches on local
```bash
git remote prune origin --dry-run # This is for pre-checking
git remote prune origin
```
#### Remove local branches
```bash
git branch -D feature/one feature/two bugfix/one
```
#### Remove a directory from remote repository after adding them to .gitignore
```bash
git rm -r --cached node_modules
git commit -m 'Remove the now ignored directory node_modules'
git push origin main
```
***
Happy gitting! :)
