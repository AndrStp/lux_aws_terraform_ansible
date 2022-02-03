# AWS EC2 ngnix web-servers
This project was completed as an assingment for Lux

## Requirements:
1. Create free AWS / Azure account.
2. Create Terraform recipe to provision 2 EC2 VMs (any zone).
3. Created Ngnix docker image that serves statis html page. *Optionally*: html page should render EC2 instance public IP and DNS addresses.
4. Create Ansible recipe that deploys ngnix docker images on both EC2 instances.
5. Services shall be accessible from the web.
6. Deploy code on github and provide README.md file with instructions.

## Prerequisites:
- aws account
- installed aws cli v.2
- installed terraform
- installed ansible

## AWS Account

Having created the AWS account, one should create a specific user for managing EC2 instances.

The user should be granted with **AmazonEC2FullAccess** permissions.

The user will be provided with **Acess key ID** and **Secret access key** that should be saved on the local machine.

## AWS CLI

### Steps 
1. Ensure AWS CLI is installed (for more info see https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
```
$ aws --version
```

2. Configure AWS CLI by providing credentials of previously created user. Run below command and follow AWS CLI instructions (for more info see https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)

```
$ aws configure --profile aws_username
```

3. Verify that credentials are successfully saved by checking the *~/.aws/credentials* directory.


## SSH key

### Steps 
1. Create new SSH key-pair (no passphrase)
```
$ ssh-keygen -t rsa -b 2048
```

2. Apply read-only permission for user
```
chmod 400 private_key
```


## TERRAFORM

Terraform code is placed in *./terraform/* directory and consists of three files:

* *main.tf* - main script that provision creation of 2 EC2 instances with aws_security group which to opens ports 22 and 80 for incoming and 0 for outcoming traffic.
* *variables.tf* - list of variables required for *main.tf*.
* *outputs.tf* - outputs pulic IP and DNS addresses of the newly created EC2 instances to the console.

### Steps 

1. Clone the repository on your local machine and open it
```
$ git clone https://github.com/AndrStp/lux_aws_terraform_ansible.git
```
```
$ cd lux_aws_terraform_ansible
```

2. Substitute the *aws_lux.pub* key with your public ssh-key previously created (in case your ssh key is located in */home/username/.ssh/you_public_ssh_key.pub*)
```
$ mv /home/username/.ssh/you_public_ssh_key.pub ./aws_key.pub
```

3. Ensure that terraform is installed
```
$ terraform --version
```

4. Navigate to *./terraform* directory and initialize the working directory for terraform and donwload required provider
```
$ cd ./terraform/
$ terraform init
```

5. Validate the terraform recipe
```
$ terraform validate
```

6. Create the execution plan to preview the changes
```
$ terraform plan
```

7. If satisfied let terraform execute actions proposed in *./terraform/main.tf* 
```
$ terraform apply
```

8. Having created EC2 instances the terraform will output pulic IP and DNS addresses of the EC2 instances that should be stored somewhere for later use (for index.html)

9. Verify that instances are created 
```
$ aws ec2 describe-instances --profile aws-username
```

10. Check you can connect to the instances via SSH using you private SSH key. Username is by default is 'ec2-user'. 
```
$ ssh ec2-user@ec2_instance_1_public_ip_address -i /location/to/your/private_key
$ ssh ec2-user@ec2_instance_2_public_ip_address -i /location/to/your/private_key
```


## ANSIBLE

Ansible code is placed in *./ansible/* directory and consists of three files:

* *copy_index_pages.yml* - yml file that copies custom index.html.j2 template pages to EC2 instances. 
* *install_docker.yml* - yml file that installs docker to EC2 instances.
* *launch_ngnix_container.yml* - yml file that builds ngnix docker image and runs it on EC2 instances.

### Steps 

1. Add public ip adresses of EC2-instances to hosts file as well as their usernames and location 
```
$ nano /etc/ansible/hosts
```
```
[lux_webservers]
172.0.0.1
172.0.0.2

[lux_webservers:vars]                                                
ansible_ssh_user=ec2-user                                            
ansible_ssh_private_key_file=/location/to/your/private_key   
```

WHERE
- **ec2-user** is the username of EC2 instance (see https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/managing-users.html)
- **/location/to/your/private_key** is the location to your ssh private key (for example, *home/user/.ssh/id_rsa*)

2. Verify that Ansible can connect to EC2-instances
```
ansible all -m ping
```

3. Open *./ansible/copy_index_pages.yml* file and change **hosts** and **server_ip** by providing pulic ip addresses of EC2 instances. Also change **server_dns** vars for each EC2 instance. This ensures that custom index.html page will be copied to EC2 instances separately.


4. cd to *./ansible* directory
```
$ cd ./ansible
```

5. Run each **.yml* ansible script with *ansible-playbook* command
```
$ ansible-playbook copy_index_pages.yml 
$ ansible-playbook install_docker.yml
$ ansible-playbook launch_ngnix_container.yml
```

6. Ensure that ngnix webserver is running in docker container by making a request from local machine to public ip addresses and dns addresses of EC2 instances.
```
$ curl *public_ip_address_of_ec2_instance_1*
$ curl *pulic_dns_address_of_ec2_instance_1*
```
```
$ curl *public_ip_address_of_ec2_instance_2*
$ curl *pulic_dns_address_of_ec2_instance_2*
```

The output should be the following:
```
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
</head>
<body>
  <h1>Lux Nginx Server</h1>
  <h3>Hello from the Docker container!</h1>
  <h3>Public IP adress: <b>*public_ip_address_of_ec2_instance*</b></h3>
  <h3>Public DNS adress: <b>*pulic_dns_address_of_ec2_instance*</b></h3>
</body>
</html>
```
