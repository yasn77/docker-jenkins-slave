docker-jenkins-slave
====================

Docker Jenkins slave image using swarm plugin

    OS Base : Ubuntu 14.04
    Jenkins Swarm version :  1.15
    Exposed Ports : 2812 22
    Jenkins Home : /jenkins
    Timezone : Europe/London

Environment Variables
---------------------
    JENKINS_JAVA_ARGS
        Arguments to pass to Java when Jenkins starts. Default : '-Djava.awt.headless=true'
    TZ
        Container Timezone. Default 'Europe/London'

Services
--------

  * Jenkins Slave
  * Monit
  * SSHD

Monit is used to control the start up and management of Jenkins slave (and SSHD). You can access the monit webserver
by exposing port 2812 on the Docker host. The user name is `monit` and password can be found by running:

    docker logs <CONTAINER_ID> 2>/dev/null | grep MONIT_PASSWORD

OpenSSH is also running, you can ssh to the container by exposing port 22 on your Docker host and using the username
`jenkins`. Password can be found by running:

    docker logs <CONTAINER_ID> 2>/dev/null | grep JENKINS_PASSWORD

Swarm Client Startup Options
----------------------------
Below is a list of environment variables that are mapped to the the swarm client options. Simply pass them to the container
when you run.

  JENKINS_MASTER_URL : -master
  JENKINS_AUTODISC_ADDR : -autoDiscoveryAddress
  JENKINS_EXECUTORS : -executors
  JENKINS_LABELS : -labels
  JENKINS_USERNAME : -username
  JENKINS_PASSWORD : -password

The autodiscovery will work if the slave is on the same network as the Jenkins master. The default configuration of Docker will
prevent it from working if slave and master are on different Docker hosts. In this case you will need to pass in the environment
variable ```JENKINS_MASTER_URL```
