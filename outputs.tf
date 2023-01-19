output "jenkins_vm_public_ip" {
  value = aws_eip.jenkins_vm_eip.public_ip
}