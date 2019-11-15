#!/bin/bash

# Download template
curl -LSso Dockerrun.aws.json.template https://raw.githubusercontent.com/imperfectproduce/aws-docker-deploy/c13ffa2eda068d5d4eee93ce498d1340f72a529c/Dockerrun.aws.json.template

# Set vars that typically do not vary by app
BRANCH=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)
SHA1=$(git rev-parse HEAD)
VERSION=$BRANCH-$SHA1-$(date +%s)
DESCRIPTION=$(git log -1 --pretty=%B)
DESCRIPTION=${DESCRIPTION:0:180} # truncate to 180 chars - max beanstalk version description is 200
ZIP=$VERSION.zip


AWS_ACCOUNT_ID=651188399649
NAME=tomcat-web
EB_APP_NAME=java-app
EB_ENV_NAME=catalogdemo-app
EB_BUCKET=aws-s3-bucket-eb-versions
AWS_REGION=ap-southeast-2
CONTAINER_PORT=8080
TAG=latest

aws configure set default.region $AWS_REGION

# Authenticate against our Docker registry
eval $(aws ecr get-login --region $AWS_REGION | sed "s/-e none //")

# Build and push the image
docker build -t $NAME:$VERSION .
docker tag $NAME:$VERSION $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$NAME:$VERSION
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$NAME:$VERSION
docker rmi  $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$NAME:$VERSION
# Copy template Dockerrun.aws.json and replace template vars
cp Dockerrun.aws.json.template Dockerrun.aws.json

# Replace the template values
sed -i.bak "s/<AWS_ACCOUNT_ID>/$AWS_ACCOUNT_ID/" Dockerrun.aws.json
sed -i.bak "s/<AWS_REGION>/$AWS_REGION/" Dockerrun.aws.json
sed -i.bak "s/<NAME>/$NAME/" Dockerrun.aws.json
sed -i.bak "s/<TAG>/$VERSION/" Dockerrun.aws.json
sed -i.bak "s/<CONTAINER_PORT>/$CONTAINER_PORT/" Dockerrun.aws.json

# Zip up the Dockerrun file (feel free to zip up an .ebextensions directory with it)
if [ -d ".ebextensions" ]; then
   zip -r $ZIP Dockerrun.aws.json .ebextensions
else
   zip -r $ZIP Dockerrun.aws.json
fi



aws s3 cp $ZIP s3://$EB_BUCKET/$ZIP

# Create a new application version with the zipped up Dockerrun file
aws elasticbeanstalk create-application-version --application-name "$EB_APP_NAME" \
    --version-label $VERSION --description "$DESCRIPTION" --source-bundle S3Bucket=$EB_BUCKET,S3Key=$ZIP --auto-create-application

status=$(aws elasticbeanstalk describe-environments --application-name "$EB_APP_NAME" --environment-name "$EB_ENV_NAME" --query "Environments[*].EnvironmentName" --output text)


# Update the environment to use the new application version
if [ "$status" == "$EB_ENV_NAME" ]; then
    aws elasticbeanstalk update-environment --environment-name $EB_ENV_NAME \
      --version-label $VERSION
    echo "'$EB_ENV_NAME'is Creating... Go to eb console and see"
else


    echo "'$EB_ENV_NAME' is Creating... Go to eb console and see"
    aws elasticbeanstalk create-environment --application-name $EB_APP_NAME --environment-name $EB_ENV_NAME \
        --version-label $VERSION  --solution-stack-name "64bit Amazon Linux 2018.03 v2.13.0 running Docker 18.06.1-ce"
fi


# Clean up
rm $ZIP
rm Dockerrun.aws.json
rm Dockerrun.aws.json.bak
rm Dockerrun.aws.json.template
                                 
                                                                                 
