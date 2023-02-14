pipeline{
    agent any
    tools {
        terraform 'terraform 11'
    }
    parameters {
	    string(name: "AWS_ACCESS_KEY",
	       defaultValue: "",
	       description: "Aws_Access_key_id" )

        string(name: "AWS_SECRET_ACCESS_KEY",
	       defaultValue: "",
	       description: "Aws_secret_key_id" )

        string(name: "ENVIRONMENT_NAME",
	       defaultValue: "",
	       description: "Enter your environment name" ) 

        string(name: "JENKINS_IP",
	       defaultValue: "",
	       description: "Enter your Jenkins server ip address" )  

        string(name: "DBNAME",
	       defaultValue: "",
	       description: "Enter your database name" ) 

        string(name: "DBUSER",
	       defaultValue: "",
	       description: "Enter your database user" )
           
        string(name: "DBPASS",
	       defaultValue: "",
	       description: "Enter your database password" ) 

        string(name: "MYSQLROOTPASS",
	       defaultValue: "",
	       description: "Enter your mysql root password" )   
    }
    //stages{
        //stage('Git checkout'){
            //steps{
                //git credentialsId: 'Jenkins_Github-token', url: 'https://github.com/AndrewBanin/Terraform-Modulesproject.git'
           // }
        //}  
    //}
    
    stages{
        stage('envsubst'){
            steps{
                sh 'envsubst < variables.tf > variables'
                sh 'rm -rf variables.tf '
                sh 'mv variables variables.tf'
                sh 'envsubst < modules/networking/main.tf > modules/networking/main'
                sh 'rm -rf modules/networking/main.tf '
                sh 'mv modules/networking/main modules/networking/main.tf'
                sh "envsubst '\$DBUSER\$DBNAME\$DBPASS'< wordpress-frontend.sh > fe"
                sh 'rm -rf wordpress-frontend.sh '
                sh 'mv fe wordpress-frontend.sh '
                sh "envsubst '\$DBUSER\$DBNAME\$DBPASS\$MYSQLROOTPASS' <mysql_bootstrap.sh  > mysql"
                sh 'rm -rf mysql_bootstrap.sh '
                sh 'mv mysql mysql_bootstrap.sh '
            }
        }
        stage('terraform init'){
            steps{
                sh 'terraform init'
            }
        }
        stage('terraform apply'){
            steps{
                sh 'terraform apply --auto-approve'
                sh 'cat ${ENVIRONMENT_NAME}-key.pem'
            }
        }

         //stage('CleanWorkSpace'){
            //steps {
                //cleanWs()
            //}
        //}
        //stage('Get database IP') {
			//steps{
                //DBHOST = $(sh  "aws ec2 describe-instances --filters Name=tag:Name,Values='${ENVIRONMENT_NAME}-db_server' --query 'Reservations[].Instances[].PrivateIpAddress' --output text")
                //sh "echo ${DBHOST}"
			//}
		//}
    }
}