#!/bin/bash

# Read Env Vars set by Docker
source /docker.env

if ! id jenkins &>/dev/null
then
  useradd -G monit -s /bin/bash -d ${JENKINS_HOME} jenkins
  
  # Set Jenkins user password, so we can SSH
  JENKINS_PASSWD=$(openssl rand -base64 6)
  echo JENKINS_PASSWORD=${JENKINS_PASSWD}
  echo -e "${JENKINS_PASSWD}\n${JENKINS_PASSWD}" | passwd jenkins &>/dev/null
fi

chown -R jenkins ${JENKINS_HOME}

OPTS="-fsroot ${JENKINS_HOME}"

if [ -n "${JENKINS_MASTER_URL}" ]
then
  OPTS+=" -master ${JENKINS_MASTER_URL}"
elif [ -n "${JENKINS_AUTODISC_ADDR}" ]
then
  OPTS+=" -autoDiscoveryAddress ${JENKINS_AUTODISC_ADDR}"
fi

if [ -n "${JENKINS_EXECUTORS}" ]
then
  OPTS+=" -executors ${JENKINS_EXECUTORS}"
fi

if [ -n "${JENKINS_LABELS}" ]
then
  OPTS+=" -labels ${JENKINS_LABELS}"
fi

if [ -n "${JENKINS_USERNAME}" ] && [ -n "${JENKINS_PASSWORD}" ]
then
  OPTS+=" -username ${JENKINS_USERNAME} -password ${JENKINS_PASSWORD}"
fi

cd ${JENKINS_HOME}
echo "### Jenkins Swarm client options ###"
echo "### ${OPTS} ###"
case $1 in
  start)
    su - jenkins -c "java ${JENKINS_JAVA_OPTS} -jar swarm-client.jar ${OPTS} &>$JENKINS_HOME/jenkins_swarm_client.log & echo \$! > /tmp/jenkins.pid"
    ;;
  stop)
    pkill -F /tmp/jenkins.pid
    ;;
  status)
    if pgrep -f swarm-client.jar &>/dev/null
    then
      echo "Jenkins Swam Client running..."
      exit 0

    else
      echo "Jenkins Swam Client not running..."
      exit 1
    fi
    ;;
  *)
    echo "Usage $0 start|stop|status"
    ;;
esac
