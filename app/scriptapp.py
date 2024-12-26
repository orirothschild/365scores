#!/usr/bin/env python3
import boto3

def list_ec2(region):
    ec2_client = boto3.client('ec2', region_name=region)
    instances = ec2_client.describe_instances()
    return instances

def list_rds(region):
    rds_client = boto3.client('rds', region_name=region)
    instances = rds_client.describe_db_instances()
    return instances

def list_s3(region):
    s3_client = boto3.client('s3', region_name=region)
    buckets = s3_client.list_buckets()
    return buckets

def get_regions():
    ec2_client = boto3.client('ec2')
    regions = ec2_client.describe_regions()
    return [region['RegionName'] for region in regions['Regions'] if region['RegionName'].startswith('eu-')]
        

def list_services_by_region():
    regions = get_regions()
    services = {}

    for region in regions:
        print(f"Listing services in region: {region}")
        services[region] = {
            'EC2': list_ec2(region),
            'RDS': list_rds(region),
            'S3': list_s3(region)
        }

    return services

if __name__ == "__main__":
    services = list_services_by_region()
    for region, service_data in services.items():
        print(f"Region: {region}")
        print("EC2 Instances:", service_data['EC2'])
        print("RDS Instances:", service_data['RDS'])
        print("S3 Buckets:", service_data['S3'])
