
git submodule  foreach --recursive  |  tail  -r | sed 's/Entering//' | xargs -I% cd % ; git add -A;  git commit

