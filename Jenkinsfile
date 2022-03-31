// Nicolas Pipeline
pipeline {
	environment {
		imagename = "nicolasmarcoux/my-app"
		registryCredential = 'dockerhub'
		dockerImage = ''
	}
	agent {
        docker {
            image 'kennethreitz/pipenv:latest'
            args '-u root --privileged -v /var/run/docker.sock:/var/run/docker.sock'
        }
        }
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
		        stage('test') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: 'master']], userRemoteConfigs: [[url: 'https://github.com/NicoJNPR/Jenkins_PrismaCloud']]])
                script { 
                    sh "export PRISMA_API_URL=https://api2.prismacloud.io"
                    sh "pipenv install"
                    sh "pipenv run pip install bridgecrew"
                    sh "pipenv run bridgecrew --directory . --bc-api-key d0070389-1168-4114-a731-56065bfe7bb2::XY1D++SfdtYaNprCCnwBiI717VI= --repo-id NicoJNPR/Jenkins_PrismaCloud"
                }
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
