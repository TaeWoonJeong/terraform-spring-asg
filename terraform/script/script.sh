#!/bin/bash
#To watch writing log file, use "tail -f scrip.log"
LOG_FILE="/home/ubuntu/script.log"
START_TIME=$(date +%s)

write_to_log() {
  local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
  echo "[$timestamp] $1" >> "$LOG_FILE"
}

# init LOG FILE
> "$LOG_FILE"
write_to_log "Starting script execution."
sudo apt -y update >> "$LOG_FILE" 2>&1
write_to_log "Package updates completed."

sudo apt -y install openjdk-17-jdk >> "$LOG_FILE" 2>&1

sudo apt -y install ruby-full >> "$LOG_FILE" 2>&1
sudo apt -y install wget >> "$LOG_FILE" 2>&1
wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install >> "$LOG_FILE" 2>&1
chmod +x ./install
sudo ./install auto >> "$LOG_FILE" 2>&1

sudo apt -y install awscli >> "$LOG_FILE" 2>&1
write_to_log "AWS CLI installation completed."

sudo aws s3 cp s3://tw-spring-bucket/spring/spring.zip /home/ubuntu >> "$LOG_FILE" 2>&1
write_to_log "File downloaded from S3."

sudo apt -y install unzip >> "$LOG_FILE" 2>&1
write_to_log "unzip installation completed."

sudo unzip /home/ubuntu/spring.zip -d /home/ubuntu/spring-init >> "$LOG_FILE" 2>&1
write_to_log "File spring.zip extracted."

sudo nohup java -jar /home/ubuntu/spring-init/build/libs/spring-alb-0.0.1-SNAPSHOT.jar 1>> /home/ubuntu/spring.log 2>> /home/ubuntu/spring-error.log &
write_to_log "Script execution completed."

sudo chmod -R 777 /home/ubuntu/spring-init
sudo chmod 777 /home/ubuntu/spring.log
sudo chmod 777 /home/ubuntu/spring-error.log

END_TIME=$(date +%s)
ELAPSED_TIME=$((END_TIME - START_TIME))

write_to_log "Script execution completed in $ELAPSED_TIME seconds."