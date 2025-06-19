## README
## Overview

We wanted a website for our wedding, and i knew i could use it as a bit of a learning and development opportunity to touch on a few things:
- some frontend development (limited to editing some CSS, HTML and using the inspect feature...a LOT)
- deployment of the website via:
    - GitHub Actions
    - CloudFlare Pages


The website template was sourced from html5up.net, more info on this can be found in the document in the repo titled: HTML5Up-Info. 

The form on the websie is powered by [formbackend.com](https://www.formbackend.com/)

The domain was purchased from [NameCheap](https://www.namecheap.com/) and then transferred to [CloudFlare](https://www.cloudflare.com/en-gb/)

## Local Development
I edited the website locally first inside docker container with the following command `docker run -it --rm -d -p 8080:80 --name wedding -v ./:/usr/share/nginx/html nginx`.
This allowed me to see my changes in real time by just refreshing the webpage at localhost:8080 using cmd + shift + R. 

## Deployment
I did a large chunk of the site locally before committing to GitHub, Once it was complete i have a GitHub Action that pushes all the files up to CloudFlare Pages, using the [CloudFlare Wrangler-action](https://github.com/cloudflare/wrangler-action).

Once i had done this and registered my domain in CF, i could add a custom domain to CF pages, guide [here](https://developers.cloudflare.com/pages/configuration/custom-domains/).


