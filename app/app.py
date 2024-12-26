from flask import Flask, jsonify
import boto3
import logging

app = Flask(__name__)

logging.basicConfig(level=logging.INFO)

def list_ec2(region):
    ec2_client = boto3.client('ec2', region_name=region)
    try:
        instances = ec2_client.describe_instances()
        formatted_instances = []
        for reservation in instances['Reservations']:
            for instance in reservation['Instances']:
                formatted_instances.append({
                    'InstanceId': instance['InstanceId'],
                    'InstanceType': instance['InstanceType'],
                    'State': instance['State']['Name'],
                    'PublicIp': instance.get('PublicIpAddress', 'N/A'),
                    'PrivateIp': instance.get('PrivateIpAddress', 'N/A')
                })
        return formatted_instances
    except Exception as e:
        logging.error(f"Error fetching EC2 instances: {str(e)}")
        return {"error": str(e)}

def list_rds(region):
    rds_client = boto3.client('rds', region_name=region)
    try:
        instances = rds_client.describe_db_instances()
        formatted_instances = []
        for db_instance in instances['DBInstances']:
            formatted_instances.append({
                'DBInstanceIdentifier': db_instance['DBInstanceIdentifier'],
                'DBInstanceClass': db_instance['DBInstanceClass'],
                'Engine': db_instance['Engine'],
                'Status': db_instance['DBInstanceStatus'],
                'Endpoint': db_instance['Endpoint']['Address']
            })
        return formatted_instances
    except Exception as e:
        logging.error(f"Error fetching RDS instances: {str(e)}")
        return {"error": str(e)}

def list_s3(region):
    s3_client = boto3.client('s3', region_name=region)
    try:
        buckets = s3_client.list_buckets()
        formatted_buckets = [{'BucketName': bucket['Name'], 'CreationDate': bucket['CreationDate'].isoformat()} for bucket in buckets['Buckets']]
        return formatted_buckets
    except Exception as e:
        logging.error(f"Error fetching S3 buckets: {str(e)}")
        return {"error": str(e)}

def list_lambda(region):
    lambda_client = boto3.client('lambda', region_name=region)
    try:
        functions = lambda_client.list_functions()
        formatted_functions = [{'FunctionName': func['FunctionName'], 'Runtime': func['Runtime'], 'Status': func['State']} for func in functions['Functions']]
        return formatted_functions
    except Exception as e:
        logging.error(f"Error fetching Lambda functions: {str(e)}")
        return {"error": str(e)}

def list_sns(region):
    sns_client = boto3.client('sns', region_name=region)
    try:
        topics = sns_client.list_topics()
        return [topic['TopicArn'] for topic in topics['Topics']]
    except Exception as e:
        logging.error(f"Error fetching SNS topics: {str(e)}")
        return {"error": str(e)}

def list_sqs(region):
    sqs_client = boto3.client('sqs', region_name=region)
    try:
        queues = sqs_client.list_queues()
        return queues.get('QueueUrls', [])
    except Exception as e:
        logging.error(f"Error fetching SQS queues: {str(e)}")
        return {"error": str(e)}

def list_iam_roles(region):
    iam_client = boto3.client('iam', region_name=region)
    try:
        roles = iam_client.list_roles()
        return [{'RoleName': role['RoleName'], 'Arn': role['Arn']} for role in roles['Roles']]
    except Exception as e:
        logging.error(f"Error fetching IAM roles: {str(e)}")
        return {"error": str(e)}


def list_services_by_region():
    region = 'eu-north-1'  
    services = {}
    logging.info(f"Listing services in region: {region}")
    services[region] = {
        'EC2': list_ec2(region),
        'RDS': list_rds(region),
        'S3': list_s3(region),
        'Lambda': list_lambda(region),
        'SNS': list_sns(region),
        'SQS': list_sqs(region),
        'IAM': list_iam_roles(region)
    }

    return services

@app.route('/list_services', methods=['GET'])
def list_services():
    try:
        services = list_services_by_region()
        return jsonify(services), 200
    except Exception as e:
        logging.error(f"Error in /list_services endpoint: {str(e)}")
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
