# Siemens Assignement

This project provides an IaC solution for the below scenario:

```
We would like to run some C++ and Go (Golang) experiment in the cloud.
We are running the experiment on a Ubuntu host, in a CentOS container. The application may require hardware accelerated graphics support (VGA passthrough) so a graphics driver needs to be installed on the host.
```

## Pre-requisites

- Install and update Python if its not already present.
- Install terraform.
- Active AWS Account with AWS CLI installed and confgiured.
- A VPC and a public subnet to deploy EC2s

## Technology stack

- AWS EC2
- Terraform
- Docker
- Ansible
- NVidia
- C++
- GoLang

## Architecture

![Architecture Diagram](/siemens.drawio.png)

1. The Cloud Engineer runs terraform apply
2. Deploys bare Siemens EC2 server with security group open on port 36666
3. Deploys another EC2 with Ansible installed.
4. Cloud Engineer configurs Docker and NVIDIA on Siemens EC2 using Ansible Host.

## Project Hierarchy

![Project hierarchy](/hierarchy.png)

## Usage

Step 1: Update terraform variables in the files siemens-ec2/dev.tfvars and ansible/dev.tfvars .

Step 2: Deploy Ansible EC2 from terraform using below commands:

```
cd ansible/
terraform init
terraform apply -var-file="dev.tfvars"
```

Step 3: Login to Ansible host with 'ansible' user using the ec2 key pair or EC2 session manager.

Step 4: Create new ssh key pair for ansible connection. Use below commands:

cd ~
shh-keygen -t rsa  
cat .ssh/id_rsa.pub

Copy this ssh key and update the siemens-ec2/init.sh

Step 5: Deploy Siemens EC2 from terraform using below commands:

```
cd siemens-ec2/
terraform init
terraform apply -var-file="dev.tfvars"
```

Step 6: On Ansible host create an inventory file similar to the one present in ansible/inventory by logging into Ansible server with the user 'ansible'.

Step 7: You can find the playbooks present in /home/ansible/playbooks

Step 8: To install docker and NVIDIA drivers on to ec2 server you can run below command:

```
cd /home/ansible/playbooks
ansible-playbook -i inventory install-playbook.yml
```

On successful execution you can see below output:

```
$ ansible-playbook -i inventory install-playbook.yml 

PLAY [DockerInstall] **********************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [75.101.209.69]

TASK [Install docker.] ********************************************************************************************************************************************************************************************
changed: [75.101.209.69]

TASK [Start docker service] ***************************************************************************************************************************************************************************************
ok: [75.101.209.69]

TASK [Install NVIDIA driver.] *************************************************************************************************************************************************************************************
changed: [75.101.209.69]

PLAY RECAP ********************************************************************************************************************************************************************************************************
75.101.209.69              : ok=4    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

Step 7: After installing docker in to EC2 server you can run create and run the container using the 'docker-playbook.yml'. You can follow below commands

```
ansible-playbook -i docker-playbook.yml
```

On successfull execution output will be as below:

```
ansible-playbook -i inventory docker-playbook.yml 

PLAY [DockerInstall] **********************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************
ok: [75.101.209.69]

TASK [Build Docker image from Dockerfile] *************************************************************************************************************************************************************************
changed: [75.101.209.69]

TASK [Running the container] **************************************************************************************************************************************************************************************
changed: [75.101.209.69]

TASK [debug] ******************************************************************************************************************************************************************************************************
ok: [75.101.209.69] => {
    "command_output.stdout_lines": [
        "Runtime read by parameters : GO",
        "go version go1.18.3 linux/amd64",
        "go: /code/GO/go.mod already exists",
        "Compiling Go executable ",
        "Running the executable",
        " Hello DevOps ! ",
        " Go here..."
    ]
}

PLAY RECAP ********************************************************************************************************************************************************************************************************
75.101.209.69              : ok=4    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```
