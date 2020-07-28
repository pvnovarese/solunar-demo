pipeline {
  environment {
    registry = 'registry.hub.docker.com'
    registryCredential = 'docker-hub'
    repository = 'pvnovarese/solunar-demo'
    imageLine = 'pvnovarese/solunar-demo:dev Dockerfile'
  }
  agent any
  stages {
    stage('Checkout SCM') {
      steps {
        checkout scm
      }
    }
    stage('Build image and push to registry') {
      steps {
        sh 'docker --version'
        script {
          docker.withRegistry('https://' + registry, registryCredential) {
            def image = docker.build(repository + ':dev')
            image.push()
          }
        }
      }
    }
    stage('Analyze with Anchore plugin') {
      steps {
        writeFile file: 'anchore_images', text: imageLine
        anchore name: 'anchore_images'
      }
    }
    stage('Build and push stable image to registry') {
      steps {
        script {
          docker.withRegistry('https://' + registry, registryCredential) {
            def timeStamp = Calendar.getInstance().getTime().format('YYYYMMdd-HHmmss',TimeZone.getTimeZone('CST'))
            def image = docker.build(repository + ':prod-' + timeStamp)
            image.push()  
            def imageLatest = docker.build(repository + ':latest')
            imageLatest.push()  

          }
        }
      }
    }
  }
}
