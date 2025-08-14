#!/bin/bash
set -euo pipefail

set -a
source .env
set +a

main() {
    if [[ $EUID -ne 0 ]]; then
        echo "Run as root."
        exit 1
    fi

    if ! getent group "$SONAR_GROUP" &>/dev/null; then
        sudo groupadd "$SONAR_GROUP"
    fi

    if ! id -u "$SONAR_USER" &>/dev/null; then
        sudo useradd --system --no-create-home -g "$SONAR_GROUP" "$SONAR_USER"
    fi

    sudo apt update
    sudo apt install -y wget unzip openjdk-17-jdk -y

    wget -O "$SONAR_ZIP" "$SONAR_URL"
    unzip -q "$SONAR_ZIP" -d /opt/
    mv "/opt/sonarqube-${SONAR_VERSION}" "$SONAR_HOME"
    rm "$SONAR_ZIP"
    chown -R "$SONAR_USER:$SONAR_GROUP" "$SONAR_HOME"
    touch "$SERVICE_FILE"
    echo > "$SERVICE_FILE"

    cat > "$SERVICE_FILE" <<EOT
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=simple
User=$SONAR_USER
Group=$SONAR_GROUP
PermissionsStartOnly=true
ExecStart=$JAVA_BIN -Xms512m -Xmx512m -Djava.net.preferIPv4Stack=true -jar $SONAR_HOME/lib/sonar-application-25.8.0.112029.jar
StandardOutput=journal
LimitNOFILE=131072
LimitNPROC=8192
TimeoutStartSec=5
Restart=always
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
EOT

    systemctl daemon-reload
    systemctl enable sonarqube
    systemctl start sonarqube
    sleep 10
    systemctl status sonarqube --no-pager
    if systemctl is-active --quiet sonarqube; then
        echo "SonarQube iniciado com sucesso!"
        exit 0
    else
        echo "Falha ao iniciar o SonarQube. Veja o status acima para detalhes."
        exit 1
    fi
}

main "$@"