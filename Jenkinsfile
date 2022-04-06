// Nicolas Pipeline  
pipeline {
	environment {
		imagename = "nicolasmarcoux/my-app"
		registryCredential = 'dockerhub'
		dockerImage = ''
	}
	/*agent {
          docker {
            image 'kennethreitz/pipenv:latest'
            args '-u root --privileged -v /var/run/docker.sock:/var/run/docker.sock'
          }
        }*/
	agent any
	stages {
		stage('Cloning Git') {
			steps {
				git([url: 'https://github.com/NicoPANW/Jenkins_PrismaCloud.git', branch: 'main', credentialsId: 'jenkins_id'])

			}
		}
		stage('Building image') {
			steps {
				script {
					dockerImage = docker.build imagename + ":$BUILD_NUMBER"
				}
			}
		}
                /*stage('test IaC scan BC') {
                        steps {
                          checkout([$class: 'GitSCM', branches: [[name: 'master']], userRemoteConfigs: [[url: 'https://github.com/NicoPANW/IaC_PrismaCloud.git']]])
                                script { 
                                        sh "export PRISMA_API_URL=https://api2.prismacloud.io"
                                        sh "pipenv install"
                                        sh "pipenv run pip install bridgecrew"
                                        sh "pipenv run bridgecrew --directory . --bc-api-key $BC_API_key --repo-id NicoPANW/IaC_PrismaCloud"
                                }
                        }
                }*/
		/*stage('PrismaCloudSandboxing') {
			steps {
				script {
					sudo ./twistcli sandbox --address $PC_CONSOLE_URL --analysis-duration 2m --u $PC_USER  --p $PC_PASS --output-file sandbox_out.json my-app:$BUILD_NUMBER
				}
			}
		}*/
		stage('PrismaCloudScanRepo') {
			steps {
				script {
					sh "sudo /home/centos/twistcli coderepo scan https://github.com/NicoPANW --repository Jenkins_PrismaCloud"
				}
			}
		}		
		stage('PrismaCloudScanImage') {
			steps {
				script {
					prismaCloudScanImage ca: '', cert: '', dockerAddress: 'unix:///var/run/docker.sock', image: 'nicolasmarcoux/my-app:$BUILD_NUMBER', key: '', logLevel: 'info', podmanPath: '', project: '', resultsFile: 'prisma-cloud-scan-results.json', ignoreImageBuildTime: true
				}
			}
		}
		stage('PrismaCloudPublishResults') {
			steps {
				script {
					prismaCloudPublish resultsFilePattern: 'prisma-cloud-scan-results.json'
				}
			}
		}
		stage('Deploy Image in DockerHub private registry') {
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
