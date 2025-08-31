<!--
#dentro da Ec2 lembrar de mudar de usuario , sair do root

su - ec2-user
cd /
cd /home/ec2-user/webio
git status
git remote -v
git pull 

<div>
dentro da pasta 
# 1) Builda a imagem nova (na pasta do Dockerfile)

docker build -t bio-site:latest .

# 2) Para e remove o container atual

docker rm -f bio

# 3) Sobe de novo com a mesma porta e (opcional) restart policy

docker run -d --name bio --restart=always -p 8080:80 bio-site:latest

-->