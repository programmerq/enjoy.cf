node {
    stage('Checkout') {
        checkout scm
    }
    stage('Build') {
        sshagent(['37850802-4ab0-4ffc-b519-2753a85e9625']) {
	    withEnv(['DOCKER_HOST=ssh://jefferya@yunnan.', "PATH=${tool name: 'Docker 19.03.5', type: 'org.jenkinsci.plugins.docker.commons.tools.DockerTool'}:${tool name: 'jq', type: 'com.cloudbees.jenkins.plugins.customtools.CustomTool'}:${env.PATH}"]) {
	        sh '''#!/bin/bash
                set -xe
                ssh-keygen -t rsa -F yunnan. || ssh-keyscan -t rsa yunnan. >> ~/.ssh/known_hosts
                if [ -e ~/.docker/config.json ] ; then 
                    cp ~/.docker/config.json ~/.docker/config.json-jenkinsbak
                    cat ~/.docker/config.json-jenkinsbak | jq '.experimental = "enabled"' > ~/.docker/config.json
                else
                    jq -n '.experimental = "enabled"' > ~/.docker/config.json
                fi
                cat ~/.docker/config.json
                mkdir -p ~/.docker/cli-plugins
                wget --quiet -O ~/.docker/cli-plugins/docker-buildx https://github.com/docker/buildx/releases/download/v0.3.1/buildx-v0.3.1.linux-amd64 && chmod +x ~/.docker/cli-plugins/docker-buildx
                docker buildx bake -f docker-compose.yml
                docker push $(docker buildx bake -f docker-compose.yml --print | jq -cr .[][].tags[])'''
            }
        }
    }
    stage('Run') {
        sshagent(['37850802-4ab0-4ffc-b519-2753a85e9625']) {
            withEnv(['DOCKER_HOST=ssh://jefferya@yunnan.', "PATH=${tool name: 'Docker 19.03.5', type: 'org.jenkinsci.plugins.docker.commons.tools.DockerTool'}:${env.PATH}"]) {
                sh '''#!/bin/bash
                    set -xe
                    ssh-keygen -t rsa -F yunnan. || ssh-keyscan -t rsa yunnan. >> ~/.ssh/known_hosts
                    docker stack deploy -c docker-compose.yml enjoy'''
            }
        }
    }
}
