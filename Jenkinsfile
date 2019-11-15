pipeline{
    agent any
    stages{
    stage('Git checkout'){
            steps {
                script 
                {
                   git credentialsId: 'git-credentials', url: 'https://github.com/venu9999/my-app.git'
                }
           }
        }

        stage('Maven Build'){
            steps {
                script {

                    sh "mvn clean package"
                }
            }
        }
       stage('Running script which will deploy container on eb') {
            steps {
               sh '''
                  chmod +x Deploy.sh
                  ./Deploy.sh
                  '''
            }
        }
        
    } 

}    
