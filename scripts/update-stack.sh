#!/bin/bash
# Script to update the CloudFormation stack

# Variables
STACK_NAME="IoTSystemStack"
TEMPLATE_FILE="templates/main.yaml"
PARAMETERS_FILE="parameters/dev-params.json"
REGION="us-east-1"  # Change to your preferred region
S3_BUCKET="iotsystemtemplate"  # Replace with your S3 bucket name
PACKAGED_TEMPLATE="packaged-template.yaml"

# Function to validate a CloudFormation template
validate_template() {
  local template_file=$1
  echo "Validating CloudFormation template: $template_file..."
  aws cloudformation validate-template --template-body file://$template_file --region $REGION

  if [ $? -ne 0 ]; then
    echo "Template validation failed for $template_file. Exiting."
    exit 1
  fi
}

# Validate all YAML files in the templates folder
echo "Validating all YAML files in the templates folder..."
for template in templates/*.yaml; do
  validate_template "$template"
done

# Package the CloudFormation template
echo "Packaging CloudFormation template..."
aws cloudformation package \
  --template-file $TEMPLATE_FILE \
  --s3-bucket $S3_BUCKET \
  --output-template-file $PACKAGED_TEMPLATE \
  --region $REGION

if [ $? -ne 0 ]; then
  echo "Template packaging failed. Exiting."
  exit 1
fi

# Update the stack
echo "Updating CloudFormation stack..."
aws cloudformation deploy \
  --template-file $PACKAGED_TEMPLATE \
  --stack-name $STACK_NAME \
  --parameter-overrides file://$PARAMETERS_FILE \
  --capabilities CAPABILITY_NAMED_IAM \
  --region $REGION

if [ $? -eq 0 ]; then
  echo "Stack update initiated. Check the AWS Management Console for progress."
else
  echo "Stack update failed. Exiting."
  exit 1
fi