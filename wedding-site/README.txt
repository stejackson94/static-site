We wanted a website for our wedding, and i knew i could use it as a bit of a learning and development opportunity to touch on a few things:
- some frontend development (limited to editing some CSS, HTML and using the inspect feature...a LOT)
- deployment of the website via:
    - GitHub Actions
    - CloudFlare Pages 

The website template was sourced from html5up.net, more info on this can be found in the document in the repo titled: HTML5Up-Info. 

I used local development to edit the website running it inside a docker container with the following command `docker run -it --rm -d -p 8080:80 --name wedding -v ./:/usr/share/nginx/html nginx`.
