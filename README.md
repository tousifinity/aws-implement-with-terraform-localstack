# AWS-implement-with-Terraform-localstack
## localstack installation and starting
pip install localstack
localstack start

## Running localstack in Docker
docker run --rm -it -p 4566:4566 -p 4571:4571 localstack/localstack
