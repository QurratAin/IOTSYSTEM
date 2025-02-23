#!/bin/bash
# Script to update the CloudFormation stack

# Variables
STACK_NAME="IoTSystemStack"
TEMPLATE_FILE="templates/main.yaml"
PARAMETERS_FILE="parameters/dev-params.json"
REGION="us-east-1"  # Change to your preferred region

# Validate the CloudFormation template
echo "Validating CloudFormation template..."
aws cloudformation validate-template --template-body file://$TEMPLATE_FILE --region $REGION

if [ $? -ne 0 ]; then
  echo "Template validation failed. Exiting."
  exit 1
fi

# Update the stack
echo "Updating CloudFormation stack..."
aws cloudformation update-stack \
  --stack-name $STACK_NAME \
  --template-body file://$TEMPLATE_FILE \
  --parameters file://$PARAMETERS_FILE \
  --capabilities CAPABILITY_NAMED_IAM \
  --region $REGION

if [ $? -eq 0 ]; then
  echo "Stack update initiated. Check the AWS Management Console for progress."
else
  echo "Stack update failed. Exiting."
  exit 1
fi