#!/bin/bash

REPOSITORY=/home/ec2-user/app/step2
PROJECT_NAME=lariah

echo "> Build 파일 복"

cd $REPOSITORY/zip/*.jar $REPOSITORY/


echo " > 구동중인 pid 확인"

CURRENT_PID=$(pgrep -fl ${PROJECT_NAME} | grep jar | awk '{print $1}')

echo " > 현 구동 PID: $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
	echo "> 구동 중 없음"
else
	echo "> kill -15 $CURRENT_PID"
	kill -15 $CURRENT_PID
	sleep 5
fi

echo "> 새로 배포"

JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> JAR NAME: $JAR_NAME"

chmod +x $JAR_NAME


nohup java -jar -Dspring.config.location=classpath:/application.properties,/home/ec2-user/app/application-oauth.properties,/home/ec2-user/app/application-real-db.properties,classpath:/application-real.properties -Dspring.profiles.active=real $JAR_NAME > $REPOSITORY/nohup.out 2>&1 &
