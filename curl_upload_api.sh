curl -v \
    -F "r=releases" \
    -F "g=test.upload.jpa" \
    -F "a=jpa-criteria" \
    -F "v=4.0" \
    -F "p=tar.gz" \
    -F "file=@./jpa-criteria-4.0.jar" \
    -u admin:admin123 \
    http://localhost:8082/nexus/service/local/artifact/maven/content
