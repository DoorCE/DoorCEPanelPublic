docker login
dotnet dev-certs https --export-path aspnetcore.pfx -p pass
$BUILD_DATE = Get-Date -Format "yyMMdd"
$REV_TAG = $(git log -1 --pretty=format:%h)
docker build --build-arg BUILD_DATE=$BUILD_DATE --build-arg DOCKER_TAG=$REV_TAG -t doorcepanel:$REV_TAG .
docker tag doorcepanel:$REV_TAG doorce/doorcepanel:$REV_TAG
docker push doorce/doorcepanel:$REV_TAG