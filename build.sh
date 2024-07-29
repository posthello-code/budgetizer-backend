if dart test
then
  dart_frog build
  cd build
  rm .env
  docker buildx build . --tag posthellocode/budgetizer --platform linux/amd64
  docker push posthellocode/budgetizer
  curl $DEPLOY_HOOK
  echo "\n\nCompleted build and deploy"
else
  echo "\nTests failed"
fi