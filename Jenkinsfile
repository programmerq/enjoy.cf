node {
    stage('Build') {
        sshagent(['37850802-4ab0-4ffc-b519-2753a85e9625']) {
	    withEnv(['DOCKER_HOST=ssh://jefferya@yunnan.', "PATH=${tool name: 'Docker 19.03.5', type: 'org.jenkinsci.plugins.docker.commons.tools.DockerTool'}/docker:${env.PATH}"]) {
	        sh '''#!/bin/bash
                set -xe
                ssh-keygen -t rsa -F yunnan. || ssh-keyscan -t rsa yunnan. >> ~/.ssh/known_hosts
                docker buildx bake -f docker-compose.yml
                docker push $(docker buildx bake -f docker-compose.yml --print | jq -cr .[][].tags[])'''
            }
        }
    }
    stage('Run') {
        sshagent(['37850802-4ab0-4ffc-b519-2753a85e9625']) {
            withEnv(['DOCKER_HOST=ssh://jefferya@yunnan.', "PATH=${tool name: 'Docker 19.03.5', type: 'org.jenkinsci.plugins.docker.commons.tools.DockerTool'}/docker:${env.PATH}"]) {
                sh '''#!/bin/bash
                    set -xe
                    ssh-keygen -t rsa -F yunnan. || ssh-keyscan -t rsa yunnan. >> ~/.ssh/known_hosts
                    docker stack deploy -c docker-compose.yml enjoy'''
            }
        }
    }
}
