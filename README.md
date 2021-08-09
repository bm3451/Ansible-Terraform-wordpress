

# Ansible, Terraform 을 사용한 wordpress 구성, 배포

ansible로 wordpress를 구성한후 terraform을 사용하여 aws instance ( EC2, RDS)를 생성, 관리하고 배포한다. 

- wordpress →  EC2 instance
- database   → RDS

# **1. Ansible**

- 애플리케이션 및 IT 인프라를 자동화 할 수 있는 도구.
- 구성 관리(Configuration Management) 도구.
- 간결성 , 사용 용이
- ssh 연결방식
- 절차적 언어

# **2. Terraform**

- 인프라의 자동화된 배포, 변경 및 관리를 제공
- 코드형 인프라

   : HCL( HashCorp Configuration Language) 구성파일 작성

- 선언적 언어

### cd ~/wp

```jsx

├── deployment_role.yaml
├── group_vars
│   └── all.yaml
├── inventory.ini
├── [main.tf](http://main.tf/)
├── my-sshkey
├── my-sshkey.pub
├── [provider.tf](http://provider.tf/)
├── remove.yaml
├── roles
│   └── wordpress
│       ├── handlers
│       │   └── main.yaml
│       ├── tasks
│       │   └── main.yaml
│       ├── templates
│       │   ├── ports.conf.j2
│       │   └── wp-config.php.j2
│       └── vars
│           └── main.yaml
├── [security-group.tf](http://security-group.tf/)
├── terraform.tfstate
└── terraform.tfstate.backup
```

## Requirements

### 1. Install Ansible

- **컨트롤 노드 요구사항**

   python2(version 2.7) or python3(version 3.5)

    RedHat Enterprise Linux, Debian, Centos , Ubuntu , macOS 등 Unix 계열 

    Windows 지원하지않음.

- **관리 노드 요구사항**

    ssh 통신 가능 

    SFTP 사용가능 ( OR SCP)

    python2(version 2.7) or python3(version 3.5)

```jsx
sudo apt update
sudo apt install -y software-properties-common
sudo apt-add-repository -y -u ppa:ansible/ansible
sudo apt install -y ansible
```

    

### 2. Install terraform ( for Linux - Ubuntu/Debian )

```jsx
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update
sudo apt install terraform
```

### 3. Install AWS CLI ( for Linux)

```jsx
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip 
sudo ./aws/install
```

### 4. Configure AWS CLI

```jsx
aws configure
-> aws access key ID
-> aws secret key 
-> default region name
-> default output format
```

### 5. my-sshkey
ssh 접속을 위해서 key가 존재해야한다.
```jsx
ssh-keygen -f my_sshkey -N ''
```

### deploy_role.yaml 실행

```jsx
cd ~/wp
ansible-playbook -i inventory.ini deployment_role.yaml
```

### terraform 실행

```jsx
terraform init : 초기화 

terraform fmt

terraform validate : 유효성 검사

terraform apply -auto-approve : 배포(변경,적용)

terraform destroy : 삭제
```
