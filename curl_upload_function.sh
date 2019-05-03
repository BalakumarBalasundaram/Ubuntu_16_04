upload() {
    if exists curl
    then
        print "Uploading artifact $ARTIFACT with curl ... packaging: $PACKAGING" >&2
        print "current directory"
        ls -lart
        echo "curl -v -X POST $NEXUS_UPLOAD_URL \
          -H "Authorization: Basic YWRtaW46YWRtaW4xMjM=" \
          -H "accept: application/json" -H "Content-Type: multipart/form-data" \
            -F "maven2.groupId=$GROUP_ID" \
            -F "maven2.artifactId=$ARTIFACT_ID" \
            -F "maven2.version=$VERSION" \
            -F "maven2.asset1=@$FILE" \
            -F "maven2.asset1.classifier=$CLASSIFIER" \
            -F "maven2.asset1.extension=$PACKAGING""

curl -v -X POST $NEXUS_UPLOAD_URL \
        -H "Authorization: Basic YWRtaW46YWRtaW4xMjM=" \
        -H "accept: application/json" -H "Content-Type: multipart/form-data" \
            -F "maven2.groupId=$GROUP_ID" \
            -F "maven2.artifactId=$ARTIFACT_ID" \
            -F "maven2.version=$VERSION" \
            -F "maven2.asset1=@$FILE" \
            -F "maven2.asset1.extension=$PACKAGING" \
            -F "maven2.asset1.classifier=$CLASSIFIER" \
        && echo "SUCCESS!" || { echo "OH NO!"; exit 1;}
    else
        echo "curl not found"
    fi
}
