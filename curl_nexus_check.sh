VERSION=`curl  -X GET -u admin:admin123 "http://localhost:8082/nexus/service/local/artifact/maven/resolve?r=releases&g=test.upload.jpa&a=jpa-criteria&v=4.0&e=tar.gz" | sed -n 's|<version>\(.*\)</version>|\1|p'`
echo "Version is $VERSION"
