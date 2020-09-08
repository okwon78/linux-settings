JIRA= 395 

GIT=1
JENKINS=0
REAL=0

PRJNAME=profile-artist
DEV_HOME=/home/ec2-user/users/obiwan/Dev/music-flo/${PRJNAME}
BRANCH=reco-${JIRA}-${PRJNAME}

REPO_ROOT=$DEV_HOME/$BRANCH
PRJ_SUB_DIR=$PRJNAME
PRJHOME=$REPO_ROOT/$PRJ_SUB_DIR

set -e 

GIT_USER=reco-obiwan
GIT_PWD=54b3324ac848e5f7c80f76e750db16d0100df150

if [ $GIT -eq 1 ]; then

    echo " GIT ----------------"
    
    if [ -d $REPO_ROOT ]; then
        rm -rf $REPO_ROOT
    fi    
    
    git clone https://$GIT_USER:$GIT_PWD@github.com/reco-obiwan/reco-workflow.git $REPO_ROOT

    cd $REPO_ROOT
    git checkout $BRANCH
fi

echo "DOCKER --------------"

if [ $JENKINS -eq 1 ]; then
    if [ $REAL -eq 1 ]; then
        export UPLOAD=1
        export PROD=1
    else    
        export UPLOAD=1
        export PROD=0
    fi

    $PRJHOME/dockerize.sh
    unset APPTAG
    unset UPLOAD
    unset PROD


else
    export APPTAG=$PRJNAME-reco-${JIRA}
    $PRJHOME/dockerize.sh
    
    if [ "$(docker ps -a | grep obiwan)" ]; then 
        docker stop obiwan
    fi    
    
    docker run -d -it --name obiwan --rm --net host -e PROD=0 865306278000.dkr.ecr.ap-northeast-2.amazonaws.com/flo-reco/workflow:$APPTAG
    docker exec -it obiwan bash
    unset APPTAG
fi    

if [ $JENKINS -eq 1 ]; then
    echo "Jenkins ----------------"
    JENKINS_HOME=$REPO_ROOT/jenkinsfiles
    SCRIPT_HOME=$JENKINS_HOME/scripts

    if [ $REAL -eq 1 ]; then
        FOLDER=reco
        JOB_NAME=$PRJNAME
    else
        FOLDER=reco-test
        JOB_NAME=$PRJNAME-reco-$JIRA
    fi    
    
    echo "current dir: $(pwd)"
    python $SCRIPT_HOME/workflow_manager.py job $JENKINS_HOME/workflow-$PRJNAME.groovy $FOLDER $JOB_NAME
fi



