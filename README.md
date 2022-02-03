# TERRAFORM

99. 

```
chmod 400 private_key
```

9. Check the connection to newly provisined EC2 instances

```
ssh username@ec2_instance_1_public_ip_address -i /location/to/your/private_key
ssh username@ec2_instance_2_public_ip_address -i /location/to/your/private_key
```

WHERE
- **username** is the username of EC2 instance, *ec2-user* by default (see https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/managing-users.html)
- **ec2_instance_1_public_ip_adress** - public ip address of an EC2-instance (for example, *52.91.62.63*)
- **/location/to/your/private_key** is the location to your ssh private key (for example, *home/user/.ssh/id_rsa*)


# ANSIBLE

1. Add public ip adresses of EC2-instances to hosts file as well as their usernames and location 
```
nano /etc/.ansible/hosts
```
```
[lux_webservers]
172.0.0.1
172.0.0.2


[lux_webservers:vars]                                                ansible_ssh_user=ec2-user                                            
ansible_ssh_private_key_file=/location/to/your/private_key   
```

WHERE
- **ec2-user** is the username of EC2 instance (see https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/managing-users.html)
- **/location/to/your/private_key** is the location to your ssh private key (for example, *home/user/.ssh/id_rsa*)

2. Verify that Ansible can connect to EC2-instances
```
ansible all -m ping
```

3. 

[](./ansible-connection.png)



ansible-playbook ansible_playbook-aws-install-docker-2021.yml