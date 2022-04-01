// Nicolas Pipeline
pipeline {
	environment {
		imagename = "nicolasmarcoux/my-app"
		registryCredential = 'dockerhub'
		dockerImage = ''
	}
	agent any
	stages {
		stage('Cloning Git') {
			steps {
				git([url: 'https://github.com/NicoJNPR/Jenkins_PrismaCloud.git', branch: 'main', credentialsId: 'jenkins_id'])

			}
		}
		stage('Building image') {
			steps {
				script {
					dockerImage = docker.build imagename + ":$BUILD_NUMBER"
				}
			}
		}
		stage('Scan K8s yaml manifest with Bridgecrew/checkov') {
                        withDockerContainer(image: 'bridgecrew/jenkins_bridgecrew_runner:latest') {              
                             sh "/run.sh 'jenkins_id' https://github.com/NicoJNPR"          
            
                        }
	        }
		stage('PrismaCloudScan') {
			steps {
				script {
					prismaCloudScanImage ca: '', cert: '', dockerAddress: 'unix:///var/run/docker.sock', image: 'nicolasmarcoux/my-app:$BUILD_NUMBER', key: '', logLevel: 'info', podmanPath: '', project: '', resultsFile: 'prisma-cloud-scan-results.json', ignoreImageBuildTime: true
				}
			}
		}
		stage('PrismaCloudPublish') {
			steps {
				script {
					prismaCloudPublish resultsFilePattern: 'prisma-cloud-scan-results.json'
				}
			}
		}
		stage('Deploy Image') {
			steps {
				script {
					docker.withRegistry('', registryCredential) {
						dockerImage.push("$BUILD_NUMBER")
						dockerImage.push('latest')

					}
				}
			}
		}
	}
}
