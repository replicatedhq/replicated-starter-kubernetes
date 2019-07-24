pipeline {
    agent any

    environment {

	// These variables can be passed in a few different ways:
	// 1. Set these here below.
	// 2. Set them as "Parameterized" variables in Jenkins.
	// 3. Set them as Environment variables from another process.
	// Further reading on different ways to set environment variables https://jenkins.io/doc/pipeline/tour/environment/
	APP_VERSION = "0.1.0"
	REPLICATED_APP = ""

	// If you use credentials in this file please encrypt them using this plugin https://wiki.jenkins.io/display/JENKINS/Credentials+Plugin
	REPLICATED_API_TOKEN = ""
    } 

    stages {

        stage('Fetch Replicated CLI') {
            steps {
                sh 'curl -fsSL https://github.com/replicatedhq/replicated/releases/download/v0.10.0/replicated_0.10.0_linux_amd64.tar.gz | tar xvz'
            }
        }

        stage('Promote release via CLI') {
            steps {
		// JOB_NAME and BUILD_NUMBER are one of many env variables created by Jenkins at runtime, it varies based on infra, to find other vars sh 'printenv'.

		sh "cat replicated.yaml | ./replicated release create --promote Unstable --yaml - --version ${env.APP_VERSION} --release-notes \"Automated CI release for ${env.JOB_NAME} on build number ${env.BUILD_NUMBER}\" --app ${env.REPLICATED_APP}"
            }
        }
    }
}
