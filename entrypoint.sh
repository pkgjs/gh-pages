#! /bin/sh

## Set git users to the commit we are building from
git config user.name "$(git --no-pager log --format=format:'%an' -n 1)"
git config user.email "$(git --no-pager log --format=format:'%ae' -n 1)"

if [ ! -d "$INPUT_DIR" ]; then
  git checkout gh-pages || (
    git checkout --orphan gh-pages
    git reset
    git clean -fdx
    if [ -n "$INPUT_NOJEKYLL" ]; then
      touch .nojekyll
      git add .nojekyll
    else
      touch .gitkeep
      git add .gitkeep
    fi
    git commit -m "$INPUT_INITMSG"
  )
  git checkout "$GITHUB_SHA"
  git worktree add "$INPUT_DIR" gh-pages
fi

if [ -n "$INPUT_BUILD" ]; then
  sh -c "$INPUT_BUILD"
fi

cd "$INPUT_DIR" || exit
if [ -n "$INPUT_COMMIT" ]; then
  git add .
  git commit -m "$INPUT_COMMIT"
fi
git push "https://$GITHUB_ACTOR:$GITHUB_TOKEN@github.com/$INPUT_REPO.git" gh-pages
cd -
