# Project 4 – Continuous Integration (CI)  
The goal of this project was to automate the building and publishing of a docker container image, when the project was updated. GitHub Actions automatically build a new container image and publishes it to DockerHub using versioned tags.<br><br>

The tools used in this project are as follows
- GitHub: Stores project files, and detects new tags from Actions.
- GitHub Actions: Automates building and pushing.
- Docker: Builds and runs containers locally.
- DockerHub: Stores the container images, and shows version tags.
- WSL: Local development environment.

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
https://hub.docker.com/_/httpd Used for docker documentation<br>
https://docs.docker.com/reference/dockerfile Used for my dockerfile<br>
https://github.com/docker/build-push-action Used for building with docker and github<br>
https://docs.docker.com/reference/cli/docker/image/push/ Used for docker images<br>
https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets Used for secrets and workflow<br>
https://stackoverflow.com/questions/64860458/how-to-correctly-push-a-docker-image-using-github-actions Used for docker images and pushing<br>

## Part 3 - Semantic Versioning
### Generating tags
To see the tags in the GitHub repository you can use this command `git tag` or `git show-ref --tags` <br>
To do it on the browser vesion, you can click on "tags" in the release section. <br>

To generate a tag use this command `git tag -a v1.0.0 -m "version 1.0.0"` <br>
Heres an example of one I did `git tag -a v4.0.0 -m "version 4.0.0"` <br>

To push that tag use this command `git push origin v1.0.0`<br>

### Semantic Versioning Container Images with GitHub Actions
The workflow trigger is the same as in part 2 except for the main tag is now changed to the version tag.
```
on:
  push:
    tags:
      - "v*.*.*"
```

Here are the steps for the workflow.
- This pulls the repos code into the GitHub Actions runner. 
```
- name: Checkout repository
  uses: actions/checkout@v4
```
- This step generates all the docker tags needed, and is based on the git tag.
```
- name: Extract Docker metadata (tags + labels)
  id: meta
  uses: docker/metadata-action@v5
  with:
    images: shanley4/p4site
```
- This step prepares docker builder.
```
- name: Set up Docker Buildx
  uses: docker/setup-buildx-action@v3
```
- This step uses the repository secrets we set up previously, to authetnicate.
```
- name: Login to DockerHub
  uses: docker/login-action@v3
  with:
    username: ${{ secrets.DOCKER_USERNAME }}
    password: ${{ secrets.DOCKER_TOKEN }}
```
- This step builds the container image, and pushes the generated tags to DockerHub.
```
- name: Build and Push Docker Image
  uses: docker/build-push-action@v5
  with:
    context: .
    file: ./Dockerfile
    push: true
    tags: ${{ steps.meta.outputs.tags }}
    labels: ${{ steps.meta.outputs.labels }}
```
These values must be updated if this repository is copied into a different one.

- images: shanley4/p4site
- Add your own repository secrets like in step 2.
- file: ./Dockerfile

[`Workflow File`](https://github.com/WSU-kduncan/cicdf25-ryanshanley7/blob/main/.github/workflows/docker-publish.yml)

### Testing & Validating
To test that this worked follow these steps.
- Go to your GitHub Repository
- Click on "Actions" tab
- The runs will show a green checkmark if they worked.
- In DockerHub the tags should be the following.
```
latest
major (example: 4)
major.minor (example: 4.0)
major.minor.patch (example: 4.0.0)
```
- Numbers may differ but if the tags appear, DockerHub received the versioned images successfully.
- To test them locally from DockerHub use these commands.
```
docker pull shanley4/p4site:latest
docker pull shanley4/p4site:4
docker pull shanley4/p4site:4.0
docker pull shanley4/p4site:4.0.0
```
- You can then run them locally with this command
`docker run -d -p 8080:80 shanley4/p4site:4.0.0`
- Then go to `http://localhost:8080/` and the website should load.<br> <br>
![docker tags](https://github.com/WSU-kduncan/cicdf25-ryanshanley7/blob/main/images/Docker%20tags.png) <br> <br>
[`DockerHub Repo`](https://hub.docker.com/r/shanley4/p4site/tags)

### Part 3 Citations
https://docs.docker.com/reference/cli/docker/image/tag/ Used for docker tags<br> 
https://git-scm.com/book/en/v2/Git-Basics-Tagging Used for github tags and documentation<br>
https://docs.docker.com/build/ci/github-actions/manage-tags-labels/ Used for github actions and labels<br>




