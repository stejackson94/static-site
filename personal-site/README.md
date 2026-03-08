# Personal Website
## Overview

This hold the code that was used to build and deploy my personal website. The infrastructure folder contains all the terraform that deploys IaC in to AWS. The web-code folder contains the HTML/CSS template that I used and then edited to make the website look how it does. Much like my wedding website the actual web-code was used to get a bit of practise with HTML and CSS. The core of my L&D here was around Cloudflare, Terraform and Github Actions. 

The website template was sourced from html5up.net, more info on this can be found in the document in the repo titled: HTML5Up-Info.txt  inside the web-code folder. 

The domain was purchased from [NameCheap](https://www.namecheap.com/) and then transferred to [Cloudflare](https://www.Cloudflare.com/en-gb/)

# Architecture 
![Architecure Diagram](./personal-website.drawio.drawio.svg)

# Local Development
From the repo root, run:

```bash
make local-personal
```

This builds `personal-site` and serves it at `http://localhost:8080/`.

You can also build and run directly using the Dockerfile in this folder.

From inside `personal-site/`:

```bash
docker build -t ste-personal-site-local .
docker run --rm -p 8080:80 ste-personal-site-local
```

Then open `http://localhost:8080/`.

If you are making changes, stop the running container and rebuild the image to pick up updates.

# Deployment Overview 
I did a large chunk of the site locally before committing to GitHub, then you should be able to see subsequent commits after that once i was set on the template. Once I did this I manually upladed the files to my s3 bucket as the backend for the site was already functioning as my old website is inside the folder old-personal-site in the root of the repo. 

## Adding a domain to Cloudflare
Plenty of guides around, the Cloudflare docs are great along side [this](https://mikefallows.com/posts/add-a-custom-url-to-cloudfront-with-cloudflare/) site I found with a blog post on but it was largely easy and self explanatory. 

##  Terraform
The terraform for this stands up the s3 bucket, the cloudfront distribution and the ACM cert. This was a unqiue scenario in that I had already created the infra in the console and just wanted to replicate it in code. I could have wrote this all out from fresh however I found two tools that helped me here. 
1. [This](https://developer.hashicorp.com/terraform/language/import/generating-configuration) allowed me to point at a resource I already had created and TF would generate the HCL for it 
2. [This](https://developer.hashicorp.com/terraform/cli/import/usage) allowed me to then import the resources in to my state which I set up in s3. 

This saved me a load of time and effort and was a good way of learning another side of TF. 

## GitHub Action
The personal-site deploy workflow now supports both automatic and manual triggers:
1. `push` to files under `personal-site/**`
2. `workflow_dispatch` from the GitHub Actions UI

The workflow has three key stages:
1. `check`: inspects changed files and determines whether all changes are under `personal-site/infrastructure/*`
2. `terraform_apply_and_plan`: runs only when infrastructure files changed
3. `push_website_code_to_s3`: always runs after the infra stage (success, failure, or skipped) to deploy website content

During website deployment, CI now:
1. Injects an automatic cache-buster (`__ASSET_VERSION__` -> short commit SHA) into HTML asset URLs
2. Syncs non-HTML assets to S3 with revalidation-friendly caching (`max-age=3600,must-revalidate`)
3. Uploads HTML with short cache (`max-age=300,must-revalidate`)
4. Invalidates CloudFront (`/*`) so updates are available quickly

This prevents stale CSS/JS rendering issues caused by CDN/browser cache drift between HTML and static assets.


