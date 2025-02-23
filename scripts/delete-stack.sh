#!/bin/bash
# Script to delete the CloudFormation stack

# Variables
STACK_NAME="IoTSystemStack"
REGION="us-east-1"  # Change to your preferred region

# Delete the CloudFormation stack
echo "Deleting CloudFormation stack: $STACK_NAME..."
aws cloudformation delete-stack \
  --stack-name $STACK_NAME \
  --region $REGION

if [ $? -eq 0 ]; then
  echo "Stack deletion initiated. Check the AWS Management Console for progress."
else
  echo "Failed to initiate stack deletion. Exiting."
  exit 1
fi

# Wait for stack deletion to complete
echo "Waiting for stack deletion to complete..."
aws cloudformation wait stack-delete-complete \
  --stack-name $STACK_NAME \
  --region $REGION

if [ $? -eq 0 ]; then
  echo "Stack $STACK_NAME has been successfully deleted."
else
  echo "Stack deletion failed or timed out. Check the AWS Management Console for details."
  exit 1
fi