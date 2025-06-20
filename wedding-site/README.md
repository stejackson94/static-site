# README
## Overview

We wanted a website for our wedding, and i knew i could use it as a bit of a learning and development opportunity to touch on a few things:
- some frontend development (limited to editing some CSS, HTML and using the inspect feature...a LOT)
- deployment of the website via:
    - GitHub Actions
    - Cloudflare Pages


The website template was sourced from html5up.net, more info on this can be found in the document in the repo titled: HTML5Up-Info. 

The form on the websie is powered by [formbackend.com](https://www.formbackend.com/)

The domain was purchased from [NameCheap](https://www.namecheap.com/) and then transferred to [Cloudflare](https://www.Cloudflare.com/en-gb/)

## Local Development
I edited the website locally first inside docker container with the following command `docker run -it --rm -d -p 8080:80 --name wedding -v ./:/usr/share/nginx/html nginx`.
This allowed me to see my changes in real time by just refreshing the webpage at localhost:8080 using cmd + shift + R. 

# Deployment Overview 
I did a large chunk of the site locally before committing to GitHub, Once it was complete i have a GitHub Action that pushes all the files up to Cloudflare Pages, using the [Cloudflare Wrangler-action](https://github.com/Cloudflare/wrangler-action).

Once i had done this and registered my domain in CF, i could add a custom domain to CF pages, guide [here](https://developers.Cloudflare.com/pages/configuration/custom-domains/).

## Adding a project to Cloudflare 

I had to install npm which i did using the .tool-versions file in the root of the repo using ASDF. Then i ran `npm i -D wrangler@latest` to install wrangler. This installed it and then i ran `npx wrangler pages project create wedding` which created the project. This will be available at https://wedding-348.pages.dev/ before i add a custom domain to route it to https://hollyandste.wedding. 


## GitHub Actions
The site is then deployed via the GitHub action in the route of the repo that pushes it to Cloudflare, there are secrets set up in the repo with my CF account ID and API token. It pushes it to the project created manually in the earlier step. 

## Cloudflare 
Inside CF i set up a custom domain in the CF Pages section, this added a CNAME record to my domain i purchased through namecheap and added to CF for DNS, WAF, DDoS protection etc. 

# Useful Resources
[CSS help](https://www.w3schools.com/css/default.asp)
[HTML help](https://www.w3schools.com/html/default.asp)
[Cloudflare Docs](https://developers.Cloudflare.com/)
Particularly useful pages inside CF Docs
 - https://developers.cloudflare.com/dns/zone-setups/full-setup/setup/
 - https://developers.cloudflare.com/pages/framework-guides/deploy-anything/ 
 - https://developers.cloudflare.com/pages/configuration/custom-domains/
 - https://developers.cloudflare.com/fundamentals/api/get-started/create-token/
[Updating Thumbnail](https://nickcarmont8.medium.com/how-to-add-a-website-thumbnail-for-sharing-your-html-site-on-social-media-facebook-linkedin-12813f8d2618)
