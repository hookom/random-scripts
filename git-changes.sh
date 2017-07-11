for i in *;
do
  if [ "$i" != ".git-changes.sh" ] && [ -d $i ]; then
    cd $i;
    echo "-----\n$i";
    git status;
    cd ..;
    echo "-----\n";
  fi;
done;
