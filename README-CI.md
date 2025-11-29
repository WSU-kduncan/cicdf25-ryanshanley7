# Project 4 – Continuous Integration (CI)  
## Part 1 – Dockerfile & Building Images

In this section I created a docker container image, which hosts my Honda Civic Type R website using Apache HTTP server (httpd:2.4)
The index.html, specs.html, and styles.css web server code are stored in this repository and linked below. These are used to build
and run a fully functional container.

## Website Content
The web content below can be found by navigating to the "web-content" folder in this repository or by going to the links below.

- [`web-content/index.html`](web-content/index.html)
- [`web-content/about.html`](web-content/about.html)
- [`web-content/style.css`](web-content/style.css)

Because this is the same website from project 3, the prompt for it did not change and was as follows <br>
"make me a website that is honda civic type r themed and has 2 html pages, and a css page."

## Dockerfile Explanation
The Dockerfile below can be found by navigating to the root of this repository or by going to the links below.
The content of the Dockerfile are also located below the link.

- [`Dockerfile`](Dockerfile)

```
FROM httpd:2.4
COPY ./web-content/ /usr/local/apache2/htdocs/
```

`FROM httpd:2.4` uses the httpd 2.4 per the requirements as the base container.<br>
`COPY ./web-content/ /usr/local/apache2/htdocs/` is the command to actually copy the website code into Apaches default web directory.
