# Information on the infrastructure

I had originally created this websites infra via the ClickOps method in the AWS console. However i then came to want to turn that in to code many months later. 
I was originally going to do this by creating the individual resources again and trying to match up all the values until i found two handy features that Terraform has.
1. [The ability to generate config from resources](https://developer.hashicorp.com/terraform/language/import#plan-and-apply-an-import)
2. [The ability to import state to state files from this new HCL code](https://developer.hashicorp.com/terraform/cli/import/usage)

This meant i didnt have to write the terraform from scratch, of course i needed to check that the subsequent terraform plans and what not looked OK and didnt change anything but saved me a bunch of time. 

I also took the time to set up the s3 backend following the AWS docs.

Terraform authenticates to AWS via secrets inside my repository which i will pass as env variables to my GH action.