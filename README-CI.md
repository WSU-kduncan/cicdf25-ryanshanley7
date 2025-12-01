# Project 4 – Continuous Integration (CI)  
## Part 1 – Create a Docker container image

In this section I created a docker container image, which hosts my Honda Civic Type R website using Apache HTTP server (httpd:2.4) <br>
The index.html, specs.html, and styles.css web server code are stored in this repository and linked below. These are used to build <br>
and run a fully functional container.

### Website Content
The web content below can be found by navigating to the "web-content" folder in this repository or by going to the links below.

- [`web-content/index.html`](web-content/index.html)
- [`web-content/about.html`](web-content/about.html)
- [`web-content/style.css`](web-content/style.css)

Because this is the same website from project 3, the prompt for it did not change and was as follows <br>
"make me a website that is honda civic type r themed and has 2 html pages, and a css page."

### Dockerfile Explanation
The Dockerfile below can be found by navigating to the root of this repository or by going to the links below. <br>
The content of the Dockerfile are also located below the link.

- [`Dockerfile`](https://github.com/WSU-kduncan/cicdf25-ryanshanley7/blob/main/Dockerfile)

```
FROM httpd:2.4
COPY ./web-content/ /usr/local/apache2/htdocs/
```

`FROM httpd:2.4` uses the httpd 2.4 per the requirements as the base container.<br>
`COPY ./web-content/ /usr/local/apache2/htdocs/` is the command to actually copy the website code into Apaches default web directory.

## How to Build the Docker Image
Run the following commands to build the docker image <br>
`docker build -t [Your docker hub username]/[Name of the image]:latest .`<br>
This command will build the image <br>
Docker images tag requirements should be used, for example
```
[dockerhub-username]/[repository-name]:[tag]
shanley4/p4site:latest
```
Log into dockerhub using this command. <br>
`docker login` <br>
You can then push the image to dockerhub. <br>
```
docker push [dockerhub-username]/[image-name]:latest
docker push shanley4/p4site:latest
```
Then to run the container locally use this command. <br>
```
docker run -d -p 8080:80 [dockerhub-username]/[image-name]:latest
docker run -d -p 8080:80 shanley4/p4site:latest
```
The website should then be running, you can check by pasting this into any browser. <br>
`http://localhost:8080` <br>

### Part 1 Citations
There were no citations for part 1 because it was mostly just redoing steps from Project 3. <br>

## Part 2 – GitHub Actions and DockerHub
### Configuring GitHub Repository Secrets
- To create a PAT for authentication you first want to log into `https://hub.docker.com`
- Click on your profile icon and click "account settings"
- Click on "Personal access tokens" then click "Generate new token"
- Give it a name you will remember, then set the scope to "Read/Write" which is recommended for CI/CD push access
- Save the token in a place you won't forget as it will be used later for GitHub actions to authenticate with DockerHub <br><br>

- To set repository secrets for use by GitHub Actions follow these instructions
- In your GitHub repository, click settings.
- Click on "Secrets and Variables" then "Actions"
- Click "New repository secret"
- Name the secret "DOCKER_USERNAME" and put your docker username in the value field.
- Then make another secret and name it "DOCKERHUB_TOKEN" and put your token from earlier in the value field.
- These secrets can now be used by using the ${{ secrets.NAME }} syntax. <br><br>

Below are the secrets I personally used for this project.
```
DOCKER_USERNAME
This secret is used by the workflow and allows for authentication.
Value: shanley4

DOCKER_TOKEN
This secret is for my docker token I created, and allows for read and write enabled
authetnication for GitHub Actions
Value: [My dockerhub token]
```
You can use these secrets with this syntax
```
${{ secrets.DOCKER_USERNAME }}
${{ secrets.DOCKER_TOKEN }}
```
These secrets provide for a login into DockerHub, building and pushing docker images, and running a workflow without exposing passwords. <br>

### CI with GitHub Actions
When the workflow is triggered, the GirHub Actions automatically run, but only when changes are pushed to the main branch. You can see this in my workflow file in the section below.
```
on:
  push:
    branches: [ "main" ]
```
"on:" is how the events are determined that cause the workflow to run. <br>
"push:" decides the execution of the workflow, but only when a commit is pushed. <br>
"branches: [ "main" ]" makes it so it only runs when the main branch gets updated. <br>
This allows for a new docker image, that gets built and pushed to DockerHub when updates are merged into main. <br><br>

Below are the workflow steps and explanations.
- This is the first step and is used to download the code of the repository into the GitHub Actions runner.
- This is needed so that the web content and the dockerfile are avaialble for building.
```
- name: Checkout repository
  uses: actions/checkout@v4
```
- Next it prepares the runner for execute the container image build.
```
- name: Set up Docker Buildx
  uses: docker/setup-buildx-action@v3
```
- This is where DockerHub authentication using the secrets happens. 
```
- name: Login to DockerHub
  uses: docker/login-action@v3
  with:
    username: ${{ secrets.DOCKER_USERNAME }}
    password: ${{ secrets.DOCKER_TOKEN }}
```
- This is the final step, it publishes a brand new version of the website container to `docker.io/shanley4/p4site:latest`
```
- name: Build and push image
  uses: docker/build-push-action@v5
  with:
    context: .
    file: ./Dockerfile
    push: true
    tags: shanley4/p4site:latest
```
The following values need to be changed if someone were to copy this repository straight up. <br>
- tags: shanley4/p4site:latest | tags: <dockerhub-username>/<image-name>:latest
- These secrets must be created.  
- DOCKER_USERNAME | username: ${{ secrets.DOCKER_USERNAME }}
- DOCKER_TOKEN    | password: ${{ secrets.DOCKER_TOKEN }}
- file: ./Dockerfile | Make sure this filepath is correct if it gets moved or renamed.
- branches: [ "main" ] | Make sure your repository doesnt use a different branch, or change it to the correct branch.

[`Workflow File`](https://github.com/WSU-kduncan/cicdf25-ryanshanley7/blob/main/.github/workflows/docker-publish.yml)

### Testing & Validating
To test and validate if things are working properly heres what to do.
- Navigate to your own GitHub Repository.
- Click on the "Actions" Tab.
- Make sure that the job status shows a green checkmark
- If there are any errors it did not work properly.

To verify that the image was pushed to DockerHub,
- Navigate to your own DockerHub repository.
- Make sure the the repository exist.
- There should be a recent timestamp.
- The image size is shown and the layers match.

Useful commands
`docker pull shanley4/p4site:latest` <br>
`docker run -d -p 8080:80 shanley4/p4site:latest` <br>
Then in your browser go to `http://localhost:8080` <br><br>
My DockerHub repository
[`DockerHub Repo`](https://hub.docker.com/r/shanley4/p4site)

### Part 2 Citations
https://hub.docker.com/_/httpd <br>
https://docs.docker.com/reference/dockerfile <br>
https://github.com/docker/build-push-action <br>
https://docs.docker.com/reference/cli/docker/image/push/ <br>
https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets <br>
https://stackoverflow.com/questions/64860458/how-to-correctly-push-a-docker-image-using-github-actions <br>

## Part 3 - Semantic Versioning
