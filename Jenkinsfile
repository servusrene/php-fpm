pipeline {
    agent any

    stages {


        stage('build') {
            when {
                branch 'master'
            }

            steps {
                sh './build'
            }
        }

        stage('push') {
            when {
                branch 'master'
            }

            steps {
                sh './push'
            }
        }

    }
}
