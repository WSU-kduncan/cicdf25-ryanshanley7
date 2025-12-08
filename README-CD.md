# Project 5
## Part 1
### EC2 Instance Details
- My EC2 was launched using Ubuntu Server 22.04 LTS (HVM), SSD Volume Type, with an AMI ID of: `ami-0ecb62995f68bb549` 
- Ubuntu runs docker very well, and is lightweight so using it was my ideal choice, especially with my familiarity with it. 
- The instance type is a t2.medium, with 2 vCPUs, 4 GB of RA. 
- This was chosen per the project requirements, and because it will be plenty to run docker comfortably and be cost effective.
- The instance has 30 GB of GP3 for its volume size, per the project requirements.
- This allows for plenty of space for docker imaging, and other needed tools.
- The instance security group has the follow rules
  - SSH	TCP 22 My IP Secure remote administration (Inbound)
  - HTTP TCP 80 0.0.0.0/0 Allow public web traffic to the container (Inbound)
  - All traffic All All 0.0.0.0/0 Allows package installations, Docker Hub pulls, etc. (Outbound)
- These rules were chosen because I am able to SSH and it's restricted to my personal IP. This is good because it prevents any <br>
unauthorized access and only I can log in with my private key. I allow HTTP because the web server im hosting needs to be able to <br>
be accessed by public traffic. I allowed traffic for outbound becaues it's needed for installing docker, pulling dockerhub images, <br>
and sending webhook POST requests.

### Docker Setup on OS on the EC2 instance
To install Docker for OS on the EC2 instance do the following:
```
sudo apt update
sudo apt install -y docker.io containerd
sudo systemctl enable --now docker
sudo systemctl status docker
sudo usermod -aG docker ubuntu
```
- Log out and back in, then confirm Docker is installed with this command.
`docker --version`
- Make sure docker can run containers with this command.
`docker run hello-world`
- If you see "hello-world" then Docker is installed and working.

### Testing on EC2 Instance
To pull the container image from the DockerHub repository do the following:
`docker pull shanley4/p4site:latest`
- If this succesfully runs without an error thrown, then it worked. <br>
- To run the container use this command:
`docker run -d -p 80:80 --name p4site-test shanley4/p4site:latest`
  - `-d` runs the container detatched
  - `-p 80:80` puts the EC2 on port 80 on the containers internal port 80.
  - `--name p4site-test` just gives it a name.
- The difference between using `-d` and `-it` is that -d is for running it in the background and it doesn't clsoe when you close your shell.
-it is for debugging, and monitoring logs in real time. <br>
- I would recommend using -d for running in the background and having it not close in the background. and -it for troubleshooting or log monitoring.<br><br>

To verify that the container is successfully serving the web application do the following: 
- Go to `http://[your-EC2-public-IP]` on any browser
- You should be able to see your website or my car site.
- The running container can also be checked on the command line with `docker ps`

### Scripting Container Application Refresh
The purpose of `refresh.sh` is to make the refreshing of the running container automated whenevr a new image is available on DockerHub. <br>
The script does the following tasks:
- First it stops currently running container.
- Then it removes the old container.
- Next it pulls the newest image from DockerHub.
- Then it runs a container with the `-d` flag, so in detatched mode.
- Finally it uses `--restart` to restart if the instance reboots. <br>
Link to my refresh bash script: [refresh.sh](https://github.com/WSU-kduncan/cicdf25-ryanshanley7/blob/main/deployment/refresh.sh) <br>

To test/verify that the script successfully performs its taskings do the following:
- Run the script with this command `bash refresh.sh`
- Check your running containers with this command `docker ps`
- You should see your container running, or you can also go to your browser and go here `http://[your-EC2-public-IP]`
- You can make a change to your website, for example pushing a new version then run the same bash command from earlier `bash refresh.sh`
- When you refresh the webpage the update should be applied,

### Sources


## Part 2
### Configuring a webhook Listener on EC2 Instance


### Configure a webhook Service on EC2 Instance


### Sources




