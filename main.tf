resource "aws_instance" "my_instance" {
  ami                    = "ami-0b329fb1f17558744"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_sg_web.id]
  key_name               = aws_key_pair.my-sshkey.key_name

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./my-sshkey")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "deployment_role.yaml"
    destination = "/home/ubuntu/deployment_role.yaml"
  }

  provisioner "file" {
    source      = "roles"
    destination = "/home/ubuntu/"
  }

  provisioner "local-exec" {
    command = <<-EOF
      ssh-keyscan -t ssh-rsa ${self.public_ip} >> ~/.ssh/known_hosts
      echo "${self.public_ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=./my-sshkey" > inventory.ini
      echo "db_host: ${aws_db_instance.my_db.endpoint}" >> group_vars/all.yaml
      sudo apt-get update
      EOF
  }
  provisioner "local-exec" {
    command = " ansible-playbook -i inventory.ini deployment_role.yaml -b"
  }

  depends_on = [aws_db_instance.my_db]
}

resource "aws_db_instance" "my_db" {
  vpc_security_group_ids = [aws_security_group.my_rds_sg.id]

  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "wpdb"
  username             = "wpadm"
  password             = "hwangsy98"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible  = true
  port                 = 3306
}

resource "aws_key_pair" "my-sshkey" {
  key_name   = "my-sshkey"
  public_key = file("./my-sshkey.pub")
}

