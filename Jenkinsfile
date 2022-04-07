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
                /*stage('IaC Scan') {
			steps {
			  withCredentials([usernamePassword(credentialsId: 'PwdtoPC', passwordVariable: 'password', usernameVariable: 'user')]) {
                           sh "sudo yum update"
                           sh "sudo yum -y install python3-pip"
			   sh "sudo pip3 install --user pipenv"
                           //sh "sudo pip3 install pipenv"
                           sh "pipenv install"
                           sh "export PRISMA_API_URL=https://api.prismacloud.io"
                           sh "pipenv run pip install bridgecrew"
                           sh "pipenv run bridgecrew --directory . --bc-api-key $user::$password --repo-id NicoPANW/Jenkins_PrismaCloud"
			  }
                        } 
                }*/
		/*stage('PrismaCloud Scan Repo') {
			steps {
				script {
					withCredentials([usernamePassword(credentialsId: 'PwdtoPC', passwordVariable: 'password', usernameVariable: 'user')]) {
					  sh "sudo /home/centos/twistcli coderepo scan --address https://us-east1.cloud.twistlock.com/us-2-158319311 -u $user  -p $password . --repository https://github.com/NicoPANW/Jenkins_PrismaCloud"
					}
				}
			}
		}*/		
		stage('PrismaCloud Scan Image') {
			steps {
				script {
					prismaCloudScanImage ca: '', cert: '', dockerAddress: 'unix:///var/run/docker.sock', image: 'nicolasmarcoux/my-app:$BUILD_NUMBER', key: '', logLevel: 'info', podmanPath: '', project: '', resultsFile: 'prisma-cloud-scan-results.json', ignoreImageBuildTime: true
				}
			}
		}
		stage('PrismaCloud Publish Scan Image Results') {
			steps {
				script {
					prismaCloudPublish resultsFilePattern: 'prisma-cloud-scan-results.json'
				}
			}
		}
		stage('PrismaCloud Sandboxing') {
			steps {
				script {
					withCredentials([usernamePassword(credentialsId: 'PwdtoPC', passwordVariable: 'password', usernameVariable: 'user')]) {
					  sh "sudo /home/centos/twistcli sandbox --address https://us-east1.cloud.twistlock.com/us-2-158319311 --analysis-duration 5s -u $user  -p $password --output-file sandbox_out_$BUILD_NUMBER nicolasmarcoux/my-app:$BUILD_NUMBER"
				        }
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
