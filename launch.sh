#!/bin/bash
cd ..
MVN_ARG_LINE=()

for arg in "$@"
do
    case "$arg" in
        *)
            MVN_ARG_LINE+=("$arg")
        ;;
    esac
done

startDateTime=`date +%s`

# check that Maven args are non empty
if [ "$MVN_ARG_LINE" != "" ] ; then
    mvnBin="mvn"
    if [ -a $M3_HOME/bin/mvn ] ; then
       mvnBin="$M3_HOME/bin/mvn"
    fi
    echo
    echo "Running maven build on available projects (using Maven binary '$mvnBin')"

    "$mvnBin" -v
    echo
    projects=( "Car-Accident-Claim-Process-model" "Car-Accident-Claim-Process-kjar" "Car-Accident-Claim-Process-service")

    for suffix in "${projects[@]}"; do

        for repository in $suffix;  do
        echo
            if [ -d "$repository" ]; then
                echo "==============================================================================="
                echo "$repository"
                echo "==============================================================================="

                cd $repository

                "$mvnBin" "${MVN_ARG_LINE[@]}"
                returnCode=$?

                if [ $returnCode != 0 ] ; then
                    exit $returnCode
                fi

                cd ..
                fi

        done;
    done;
    endDateTime=`date +%s`
    spentSeconds=`expr $endDateTime - $startDateTime`
    echo
    echo "Total build time: ${spentSeconds}s"

else
    echo "No Maven arguments skipping maven build"
        
fi


if [[ "$@" =~ "docker" ]]; then
    echo "Launching the application as docker container..."
    
    docker run -d -p 8090:8090 --name Car-Accident-Claim-Process-service apps/Car-Accident-Claim-Process-service:1.0-SNAPSHOT
elif [[ "$@" =~ "openshift" ]]; then
    echo "Launching the application on OpenShift..."
    
    oc new-app Car-Accident-Claim-Process-service:1.0-SNAPSHOT
    oc expose svc/Car-Accident-Claim-Process-service
else

	echo "Launching the application locally..."
	pattern="Car-Accident-Claim-Process-service"
	files=( $pattern )
#	cd ${files[0]}
    cd Car-Accident-Claim-Process-service
	executable="$(ls  *target/*.jar | tail -n1)"
	java -jar "$executable"
fi