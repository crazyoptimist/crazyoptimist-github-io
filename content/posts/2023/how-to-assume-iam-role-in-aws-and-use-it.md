---
title: "How to Assume IAM Role in AWS and Use It"
date: 2023-08-17T14:06:18-05:00
categories: ["devops"]
---
AWS IAM Assume Role is a mechanism that enables a user or service to assume a specific IAM role temporarily. This allows the user or service to acquire temporary security credentials, including access keys, session tokens, and permissions, to perform actions within AWS resources. The assumed role can have different permissions and policies than the original user or service, ensuring a granular level of access control and reducing the need for sharing long-term credentials.

In this post, we'll create a new IAM user without any permissions granted, and a new role with some permissions, while configuring the role assumption. Then we'll demonstrate the use cases of assumed role with Github Actions and Terraform.

### Assume Role

First things first, let's create a new IAM user.

- Go to the AWS management console -> IAM page -> Users tab, click on the "Add users" button.
- Enter a user name `spa-deployment`(for example), select the checkbox "Access key - Programmatic access" because we're only going to provide programmatic access at this point in time. 
- Do not provide any permissions, and create the IAM user, which can not do anything theoritically.
- Go back to the Users tab, click on the new user we just created, and copy the User ARN to store it in a temporary place.
- Create access credentials(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY) for the user for later use.

Next, create a new IAM role.

- Go to IAM page -> Roles tab, click on the "Create role" button.
- Select trusted entity type "Custom trust policy", and use below JSON for the policy. Use the new IAM user's ARN in the policy. The policy will allow the IAM user to assume this role.
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::123456789012:user/spa-deployment"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```
- Add permissions `AmazonS3FullAccess`, `CloudFrontFullAccess` to the role.
- Enter the role name `S3-CloudFront-Access`(for example).
- Create the role and copy the Role ARN as we did when we create a user.

Now we have a user and a role to assume. We can verify them using AWS CLI.

Configure the AWS CLI with the new IAM user credentials and run the following command:

```bash
aws sts get-caller-identity
```

It will return the user's identity.

```bash
aws s3 ls
```

It will result in an `Access Denied` error, because the user doesn't have a permission to list S3 buckets.

To assume the role, use the following command:

```bash
aws sts assume-role --role-arn arn:aws:iam::123456789012:role/S3-CloudFront-Access --role-session-name DeploySPA
```

It will return "AccessKeyId", "SecretAccessKey", "SessionToken", and more. Export those values as `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_SESSION_TOKEN` like so:

```bash
export AWS_ACCESS_KEY_ID=xyz...
export AWS_SECRET_ACCESS_KEY=xyz...
export AWS_SESSION_TOKEN=xyz...
```

Now we can rerun the previous commands:

```bash
aws sts get-caller-identity
aws s3 ls
```

These commands will list all the S3 buckets, indicating that the user now has the permissions granted by the assumed role.

Additionally, when attaching a "Trust policy" to a role, we can include an "External ID" requirement to ensure that the role can only be assumed if the 3rd party provides the correct external ID. Here's an example policy for the use case:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::123456789012:user/spa-deployment"
            },
            "Action": "sts:AssumeRole",
            "Condition": {
                "StringEquals": {
                    "sts:ExternalId": "some-id"
                }
            }
        }
    ]
}
```

### Usage in Github Actions

Let's use the user and assume role functionality in GitHub Actions. It's a straightforward process.

```yaml
  - name: Configure AWS credentials
    uses: aws-actions/configure-aws-credentials@v2
    with:
      aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
      aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      aws-region: "us-west-2"
      role-to-assume: ${{ secrets.ROLE_TO_ASSUME }}
      role-duration-seconds: 3600
      role-session-name: DeploySPA
      role-skip-session-tagging: true
```

`ROLE_TO_ASSUME` is the Role ARN.

Adding above step to our Github actions workflow, we will have the necessary permissions to perform AWS CLI operations within the scope of the assumed role. In our example case, we can upload files to S3 buckets, invalidate CloudFront caches, and more.

### Usage in Terraform

```terraform
terraform {
  required_version = ">= 1.4.0"
  backend "s3" {
    profile   = "myawsprofile"
    region    = "us-west-1"
    bucket    = "terraform-state"
    key       = "prod/terraform.tfstate"

    role_arn  = "arn:aws:iam::123456789012:role/Terraform-Role"
    session_name = "terraform"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.1"
    }
  }
}

provider "aws" {
  profile     = "myawsprofile"
  region      = "us-west-1"

  assume_role {
    role_arn  = "arn:aws:iam::123456789012:role/Terraform-Role"
  }
}

```

Above Terraform code demonstrates how we can assume role in the backend configuration and provider configuration, respectively. Very straightforward, isn't it?


That's it! We have learned how to assume a role in AWS and use it within GitHub Actions.

Happy coding!
