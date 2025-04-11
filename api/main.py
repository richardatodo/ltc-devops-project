from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from boto3.dynamodb.conditions import Key
import boto3
from dotenv import load_dotenv
import os
from typing import Optional

# Load environment variables from .env file
load_dotenv()

app = FastAPI()

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],  # React app's URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize the DynamoDB client using IAM role
# When running on an EC2 instance or ECS container with an IAM role attached,
# boto3 will automatically use the instance profile credentials
aws_region = os.getenv("AWS_REGION")  # Default region if not specified

# Create DynamoDB resource - no need to specify credentials when using IAM role
dynamodb = boto3.resource('dynamodb', region_name=aws_region)

# Get a reference to the table
table_name = os.getenv("DYNAMODB_TABLE")
tv_shows_table = dynamodb.Table(table_name)

@app.get("/")
async def root():
    return {"message": "Welcome to the TV Shows API!"}

@app.get("/api/shows")
async def get_tv_shows():
    try:
        # DynamoDB scan operation to get all items
        response = tv_shows_table.scan(
            ProjectionExpression="id, title"
        )
        
        items = response.get('Items', [])
        
        # Handle pagination for large datasets
        while 'LastEvaluatedKey' in response:
            response = tv_shows_table.scan(
                ProjectionExpression="id, title",
                ExclusiveStartKey=response['LastEvaluatedKey']
            )
            items.extend(response.get('Items', []))
            
        return items
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error accessing DynamoDB: {str(e)}")

@app.get("/api/seasons")
async def get_seasons(show_id: Optional[str] = Query(None, title="Show ID")):
    if not show_id:
        raise HTTPException(status_code=400, detail="Please provide a show_id query parameter. If unaware of the showId, check out the /api/shows endpoint.")

    try:
        # Query using the primary key
        response = tv_shows_table.query(
            KeyConditionExpression=Key('id').eq(show_id),
            ProjectionExpression="seasons"
        )
        
        items = response.get('Items', [])
        
        if not items:
            return {"message": "No seasons found for the given show ID"}
        
        return items[0]
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error querying DynamoDB: {str(e)}")