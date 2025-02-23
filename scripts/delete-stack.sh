#!/bin/bash
# Script to delete the CloudFormation stack

# Variables
STACK_NAME="IoTSystemStack"
REGION="us-east-1"  # Change to your preferred region

# Delete the stack
echo "Deleting CloudFormation stack..."
aws cloudformation delete-stack \
  --stack-name $STACK_NAME \
  --region $REGION

if [ $? -eq 0 ]; then
  echo "Stack deletion initiated. Check the AWS Management Console for progress."
else
  echo "Stack deletion failed. Exiting."
  exit 1
fi