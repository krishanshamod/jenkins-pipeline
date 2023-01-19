#! /bin/bash

sudo yum update -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade -y
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins

sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo systemctl enable docker
sudo service docker start

sudo usermod -a -G docker ec2-user
sudo usermod -a -G docker jenkins

sudo service jenkins restart
sudo service docker restart

sudo yum install git -y