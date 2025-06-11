In this project, I was going to build a **serverless Data Processing Pipeline** in AWS. I havn't yet thought of the full fledged process yet. But, the planned steps are;
1. Take input data via the public REST API 
2. Stores the data in the S3 bucket
3. Trigers a Lambda function when new data added (process the data)
4. Adds the data to the DynamoDB

Project Goal:
User submits data via REST API -> stored in S3 -> Triggers Lambda -> Process data -> saves to DynamoDB

Phase 1:
- Project Setup:
    1. Create a github repo 
    2. Create a API Gateway URL with MOCK Integration as of now 

Phase 2:
- S3 Integration

Phase 3:
- Lambda Processing

Phase 4:
- DynamoDB Storage

Phase 5:
- Deploy API to AWS
    1. Use API Gateway to Integrate 

Phase 6:
- CloudWatch Logs


Install AWS CLI:
    curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
    unzip awscli-bundle.zip 
    sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws (if not working saying python: no file or directory - use: sudo ln -s /usr/bin/python3 /usr/bin/python) 

Configure AWS:
    Go to Security Credientials and create an access key, and run
    1. aws configure and paste all the things 

Install Terraform:
    https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli (go throught the documentation steps)