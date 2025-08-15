# SonarQube Lab

Este laboratório utiliza Vagrant e VirtualBox para provisionar uma VM Ubuntu com SonarQube instalado automaticamente.

## Pré-requisitos
- [Vagrant](https://www.vagrantup.com/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

Os tutoriais de instalação abaixo são funcionais para sistemas Debian based e foram testados no Debian.

#### Vagrant

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant
```

#### VirtualBox

```bash
sudo apt update
curl https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor > oracle_vbox_2016.gpg
curl https://www.virtualbox.org/download/oracle_vbox.asc | gpg --dearmor > oracle_vbox.gpg
sudo install -o root -g root -m 644 oracle_vbox_2016.gpg /etc/apt/trusted.gpg.d/
sudo install -o root -g root -m 644 oracle_vbox.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo apt update
sudo apt install -y linux-headers-$(uname -r) dkms
sudo apt install virtualbox-7.0 -y
vagrant plugin install vagrant-vbguest
```
## Como usar

1. **Clone o repositório (se necessário):**
   ```bash
   git clone <url-do-repositorio>
   cd sonarqube-lab
   ```

2. **Configure o arquivo `.env`:**
   Crie ou edite o arquivo `.env` na raiz do projeto com as variáveis necessárias para o provisionamento, por exemplo:
   ```env
   SONAR_USER=sonarqube
   SONAR_GROUP=sonarqube
   SONAR_VERSION=25.8.0.112029
   SONAR_URL=https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-25.8.0.112029.zip
   SONAR_ZIP=sonarqube-25.8.0.112029.zip
   SONAR_HOME=/opt/sonarqube
   JAVA_BIN=/usr/bin/java
   SERVICE_FILE=/etc/systemd/system/sonarqube.service
   ```

3. **Inicie o laboratório:**
   ```bash
   vagrant up
   ```
   O Vagrant irá provisionar a VM, instalar dependências e configurar o SonarQube.

4. **Acesse o SonarQube:**
   Após o provisionamento, acesse o SonarQube pelo navegador:
   [http://localhost:9000](http://localhost:9000)

5. **Gerenciar a VM:**
   - Parar a VM:
     ```bash
     vagrant halt
     ```
   - Destruir a VM:
     ```bash
     vagrant destroy
     ```
   - Acessar via SSH:
     ```bash
     vagrant ssh
     ```

## Testando manualmente o SonarScanner

Crie o projeto no SonarQube e obtenha o token de autenticação. Em seguida, você pode testar o SonarScanner manualmente dentro da VM provisionada.

### Passos:

1. Acesse a VM provisionada:
   ```bash
   vagrant ssh
   ```

2. Navegue até o diretório do projeto:
   ```bash
   cd /vagrant/node-app
   ```

3. Execute o SonarScanner (usando o token e configurações do seu `.env`):
   ```bash
   /opt/sonar-scanner-cli/bin/sonar-scanner \
     -Dsonar.projectKey=redis-app \
     -Dsonar.sources=. \
     -Dsonar.host.url=http://localhost:9000 \
     -Dsonar.token=<seu_token>
   ```

Substitua `<seu_token>` pelo valor do seu token SonarQube.

Se tudo estiver correto, o scanner irá analisar o código e enviar os resultados para o SonarQube, que podem ser visualizados na interface web.

## Solução de problemas
- Certifique-se de que o arquivo `.env` está presente e corretamente configurado.
- Se o SonarQube não iniciar, verifique o status do serviço dentro da VM:
  ```bash
  vagrant ssh
  systemctl status sonarqube
  ```
- Verifique se a versão do Java instalada é compatível com a versão do SonarQube.

## Observações
- O script de provisionamento (`provision.sh`) pode ser ajustado conforme sua necessidade.
- O laboratório foi testado com Debian 13 e SonarQube 25.x.

---

Dúvidas ou sugestões? Abra uma issue ou entre em contato!
