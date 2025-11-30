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

- [`Dockerfile`](Dockerfile)

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
- Give it a name you will remember, then set the scope to "Read/Write"
- Save the token in a place you won't forget as it will be used later for GitHub actions to authenticate with DockerHub

### CI with GitHub Actions

### Testing & Validating








