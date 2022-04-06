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
                stage('IaC Scan') {
                 sh "sudo yum update"
                 sh "sudo yum -y install python3-pip"
                 sh "pip3 install pipenv"
                 sh "pipenv install"
                 sh "export PRISMA_API_URL=https://api.prismacloud.io"
                 sh "pipenv run pip install bridgecrew"
                 sh "pipenv run bridgecrew --directory . --bc-api-key $BC_API --repo-id pjablonski123/base-shiftleftdemo"        
                } 
		/*withCredentials([usernamePassword(credentialsId: 'PwdtoPC', passwordVariable: 'password', usernameVariable: 'user')]) {
                    stage('PrismaCloudSandboxing') {
			steps {
				script {
					sh "sudo /home/centos/twistcli sandbox --address https://us-east1.cloud.twistlock.com/us-2-158319311 --analysis-duration 3m -u 56c7704b-cc84-48af-98df-302b22290c16  -p $password --output-file sandbox_out.json nicolasmarcoux/my-app:$BUILD_NUMBER"
				}
			}
		    }
                }*/
		stage('PrismaCloudSandboxing') {
			steps {
				withCredentials([usernamePassword(credentialsId: 'PwdtoPC', passwordVariable: 'password', usernameVariable: 'user')]) {
				   script {
					sh "sudo /home/centos/twistcli sandbox --address https://us-east1.cloud.twistlock.com/us-2-158319311 --analysis-duration 3m -u 56c7704b-cc84-48af-98df-302b22290c16  -p /home/centos/pc_pwd --output-file sandbox_out.json nicolasmarcoux/my-app:$BUILD_NUMBER"
				   }
				}
			}
		}
		/*stage('PrismaCloudSandboxing') {
			steps {
				script {
					sh "sudo /home/centos/twistcli sandbox --address https://us-east1.cloud.twistlock.com/us-2-158319311 --analysis-duration 3m -u 56c7704b-cc84-48af-98df-302b22290c16  -p /home/centos/pc_pwd --output-file sandbox_out.json nicolasmarcoux/my-app:$BUILD_NUMBER"
				}
			}
		}*/
		/*stage('PrismaCloudScanRepo') {
			steps {
				script {
					sh "/home/centos/twistcli coderepo scan https://github.com/NicoPANW --repository Jenkins_PrismaCloud"
				}
			}
		}*/		
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
