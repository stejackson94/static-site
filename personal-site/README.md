# Personal Website
## Overview

This hold the code that was used to build and deploy my personal website. The infrastructure folder contains all the terraform that deploys IaC in to AWS. The web-code folder contains the HTML/CSS template that i used and then edited to make the website look how it does. Much like my wedding website the actual web-code was used to get a bit of practise with HTML and CSS. The core of my L&D here was around Cloudflare, Terraform and Github Actions. 

The website template was sourced from html5up.net, more info on this can be found in the document in the repo titled: HTML5Up-Info.txt  inside the web-code folder. 

The domain was purchased from [NameCheap](https://www.namecheap.com/) and then transferred to [Cloudflare](https://www.Cloudflare.com/en-gb/)

# Local Development
I edited the website locally first inside docker container with the following command `docker run -it --rm -d -p 8080:80 --name wedding -v ./:/usr/share/nginx/html nginx`.
This allowed me to see my changes in real time by just refreshing the webpage at localhost:8080 using cmd + shift + R. This was run inside the web-code folder.

# Deployment Overview 
I I did a large chunk of the site locally before committing to GitHub, then you should be able to see subsequent commits after that once i was set on the template. Once i did this i manually upladed the files to my s3 bucket as the backend for the site was already functioning as my old website is inside the folder old-personal-site in the root of the repo. 

## Adding a domain to Cloudflare
Plenty of guides around, the Cloudflare docs are great along side [this](https://mikefallows.com/posts/add-a-custom-url-to-cloudfront-with-cloudflare/) site i found with a b log post on but it was largely easy and self explanatory. 

##  Terraform
The terraform for this stands up the s3 bucket, the cloudfront distribution and the ACM cert. This was a unqiue scenario in that i had already created the infra in the console and just wanted to replicate it in code. I could have wrote this all out from fresh however i found two tools that helped me here. 
1. [This](https://developer.hashicorp.com/terraform/language/import/generating-configuration) allowed me to point at a resource i already had created and TF would generate the HCL for it 
2. [This](https://developer.hashicorp.com/terraform/cli/import/usage) allowed me to then import the resources in to my state which i set up in s3. 

This saved me a load of time and effort and was a good way of learning another side of TF. 

## Github Action
The GitHub Action has multiple parts to it, the first check job checks out the code and then does a git diff to see what files were changed and puts them in to a txt file. The next section in the check echos each individual file and then checks if thats in the folder personal-site/infrastructure. If its not then it sets a variable as false, and if it is then it sets it true.

The next section of the action called terraform_apply_and_plan checks this prior set variable and if its true then it rusn this block as it means additional infra is needed, if it doesnt then it skips it.

The next section called push_website_code_to_s3 pushes the web-code up to my s3 bucket no matter whether the previous section ran or not, but will only do it after it has checked whether it needs to apply IaC. 


