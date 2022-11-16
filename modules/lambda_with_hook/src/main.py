import json
import os
import requests

def handler(event, context):
    
    response_body = {}
    response_body["env"] = os.environ["ENV"]

    return {"statusCode": 200, "body": json.dumps(response_body)}
