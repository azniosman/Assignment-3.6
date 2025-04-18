def lambda_handler(event, context):
    """
    Simple Lambda function that returns a Hello World message
    """
    print("Hello, World!")
    
    return {
        'statusCode': 200,
        'body': 'Hello, World!'
    }
