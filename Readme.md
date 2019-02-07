Running AWS SAM requires a specific version of Python in perfect conditions. That's not always an option.

To have SAM work reliably on every machine, this package makes it available to run in docker.
SAM however requires docker itself to operate, so there are a few caveats to this.

1) The container needs to be privileged (`--privileged`)
2) The container needs access to the docker sock (`-v /var/run/docker.sock:/var/run/docker.sock`)

## Environment Variables

- **PORT** - which port should SAM run on
- **AWS_PROFILE** - which AWS profile to use

## Mount Points

### /app
This is where your template.yml should be, and all the code it needs to serve

### /root/.aws/credentials
This is where you can mount your ~/.aws/credentials, so the AWS_PROFILE environment parameter could be meaningful

## Examples

### Lambda + DynamoDB
Running in Docker Compose with Dynamo DB to locally test Lambda functions
`docker-compose.yml`
```
version: "3"
services:
  dynamodb:
    image: dwmkerr/dynamodb
    ports:
      - 8000:8000
    volumes:
      - ./db:/data
    command: -dbPath /data
  python:
    image: vsbmeza/sam
    volumes:
      - ./:/app
      - /var/run/docker.sock:/var/run/docker.sock
      - ~/.aws/credentials:/root/.aws/credentials
    ports:
      - 3001:3001
    environment:
      PORT: 3001
      AWS_PROFILE: ${AWS_PROFILE}
    privileged: true
    links:
      - dynamodb
```