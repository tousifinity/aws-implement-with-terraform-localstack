# AWS Implement with Terraform localstack
## localstack Installation and starting
pip install localstack
localstack start

## Running localstack in Docker
docker run --rm -it -p 4566:4566 -p 4571:4571 localstack/localstack

## AWSCLI Setup
pip install awscli-local

## Bucket creating and pointing to the endpoint with the region
aws --endpoint-url=http://localhost:4566 s3api create-bucket --bucket my-bucket --region us-east-1

## Terraform Installation & Version check
choco install terraform
terraform -v

## Project initialize and provisioning
terraform init
terraform apply

## Data adding to the table
aws dynamodb put-item --table-name my-table --endpoint-url=http://localhost:4566 --cli-input-json file://item.json
