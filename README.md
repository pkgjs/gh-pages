# Setup and build a GitHub Pages branch

This is a Github Action which creates an orphan `gh-pages` branch and builds
your site into it, commit's and pushes it.

## Usage

```yaml
on: push
name: Create GH Pages
jobs:
  createGhPages:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: Create GH Pages
      uses: pkgjs/gh-pages@master
      with:
        nojekyll: true
        repo: pkgjs/gh-pages
        commit: pages build from ${GITHUB_SHA}
        build: echo "<!DOCTYPE html><html><head></head><body><h1>Hello World!</h1><p>Built from ${GITHUB_SHA}</p></body></html>" > gh-pages/index.html
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## What it does

If you have not created a `gh-pages` branch yet, it will create one for you using `git checkout --orphan`.  Once you
have the branch, it will checkout the commit you are building from and mount the branch into a directory, `./gh-pages`
by default.  It does this using `git worktree add ./gh-pages gh-pages`.

This means that any build steps you want to run just need to write into `./gh-pages` and the action will take care of
committing and pushing that to the orphan branch.  This allows the `master` branch to be the source, and not need built files
committed.

Github actions create a special `secrets.GITHUB_TOKEN` for you as the user who triggered the build, it is required that you
pass it into the action, but then it uses it to commit and push to the `gh-pages` branch.

If it all seems difficult, check out the source to clear things up: [`entrypoint.sh`](https://github.com/pkgjs/gh-pages/blob/master/entrypoint.sh)
