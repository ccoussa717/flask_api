# Chameleon Consulting Group Interview Scenario
## Goal:
### To create an Azure Virtual Desktop instance that is accesable from a specified IP range
### To deploy one HTTP server that is only accesable from the Azure Virtual Desktop
<br>

### Initial Thoughts

<p>
Need to create some sort of service to be hosted
Need to decide what IaC tool to use
</p>

<p>
I have created a simple REST api using python and the Flask framework. I chose python for its ease of use and flexibility. I used the Flask framework because it is a super lightweight framework, but has a development webserver and sqlite3 db included in the framework.
</p>

<br>

<p>
I chose to use Terraform for my IaC tool because it is declarative vs imperative, as well, Terraform has an extensive registry of provider APIs that are built and maintained by the providers themselves. In the case of Azure, there are prebuilt tools in Terraform that work directly with Azure.
</p>

<br>

<p>
Being that Terraform is declarative, it makes it much easier to manage drift in your cloud deployment. You write statements telling Terraform what you want your deployment environment to look like, and not how Terraform should do it. You let the APIs do the work. Terraform is stateful and manages the states with a state file. When you want to make changes to your deployment environment, you make the changes to the main.tf file, and apply the changes. Terraform compares the main.tf file to the state file and makes the appropriate changes to Azure. 
This is also why it’s important to only make changes to your deployment environment through Terraform, and not through the Azure CLI once you deploy with Terraform. This is because Terraform checks the state file, and not the Azure environment directly.
</p>


### Learning to use Terraform with Azure
<p>
- Went to the Terraform docs
- Checked for Azure provider
- Terraform gives you the code needed to start using Azure provider, then you run terrform init
- Before you can use Terraform to deploy to Azure, you need to run a couple commands
    - az login
    This takes you to an Azure login page for your accout
    - az extension add --upgrade -n account
    This command installs the account plugin for the az-cli so you can manage multiple accounts, and list the account you're currently using
<br>
Once you're logged in to your account, you can start creating the main.tf file, and run the terraform commands
    - terraform init
    - terraform plan
    - terraform apply
</p>

### Lesson Learned
<p>Terraform creates a .terraform file that is bigger than 100MB. When you try to push it to your git repo it's rejected as too big. You have to download and instll git lfs (large file storage) in order to upload it to github.</p>
<p>I got very familiar with git errors, deleting local git repos, starting over, and re-initializing repos.</p>
