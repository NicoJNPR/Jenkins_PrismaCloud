pipeline {
	environment {
		imagename = "nicolasmarcoux/my-ubuntu"
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
					dockerImage = docker.build imagename
					dockerImage.push('latest')
				}
			}
		}
		/*stage('Deploy Image') {
			steps {
				script {
					docker.withRegistry('', registryCredential) {
						dockerImage.push("$BUILD_NUMBER")
						dockerImage.push('latest')

					}
				}
			}
		}*/
		stage('twistlockScan') {
			steps {
				script {
					prismaCloudScanImage ca: '', cert: '', dockerAddress: 'unix:///var/run/docker.sock', image: 'nicolasmarcoux/my-ubuntu:latest', key: '', logLevel: 'info', podmanPath: '', project: '', resultsFile: 'prisma-cloud-scan-results.json', ignoreImageBuildTime: true
				}
			}
		}
		stage('twistlockPublish') {
			steps {
				script {
					prismaCloudPublish resultsFilePattern: 'prisma-cloud-scan-results.json'
				}
			}
		}
	}
}
