DIVIDER="==============================================="

function loadEnv() {
    TMP_FILE=docker.tmp.file
    ENV_FILE=".env"
    ENV_LOCAL_FILE=".env.local"
    export $(cat $ENV_FILE | grep -v '#' | awk '/=/ {print $1}') >> $TMP_FILE
    export $(cat $ENV_LOCAL_FILE | grep -v '#' | awk '/=/ {print $1}') >> $TMP_FILE
    rm $TMP_FILE
}

function hideConfFiles() {
    for file in $DIRECTORY/nginx/*;
    do
        if [[ $file == *.conf ]]; then
            echo "$DIVIDER $file RENAMED TO $file.save"
            mv $file $file.save
        fi
    done
}

function runProjects() {
    for project in $@
    do
        echo "$DIVIDER $project"
        startProject $project
    done
}

function startProject() {
    mv $DIRECTORY/nginx/$1.conf.save $DIRECTORY/nginx/$1.conf
    echo "$DIVIDER STARTING $1"
    . $DIRECTORY/bin/run/run-$1.sh
    echo "$DIVIDER $1 IS PROBABLY RUNNING"
}

docker-compose down
loadEnv
hideConfFiles
runProjects $@
docker-compose up -d
