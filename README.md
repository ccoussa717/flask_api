# Chameleon Consulting Group Interview Scenario

## Goal:

### To create an Azure Virtual Desktop instance that is accessible from a specified IP range

### To deploy one HTTP server that is only accessible from the Azure Virtual Desktop

<br>

### Initial Thoughts

<p>
Need to create some sort of service to be hosted
Need to decide what IaC tool to use
</p>

<p>
I have created a simple REST api using python and the Flask framework. I chose python for its ease of use and flexibility. I used the Flask framework because it is a super lightweight framework but has a development webserver and sqlite3 db included in the framework.
</p>

### Decission Process

#### Tech Stack
#### IaC

<p>
I chose to use Terraform for my IaC tool because it is declarative vs imperative, as well, Terraform has an extensive registry of provider APIs that are built and maintained by the providers themselves. In the case of Azure, there are prebuilt tools in Terraform that work directly with Azure.
</p>

<br>

<p>
Being that Terraform is declarative, it makes it much easier to manage drift in your cloud deployment. You write statements telling Terraform what you want your deployment environment to look like, and not how Terraform should do it. You let the APIs do the work. Terraform is stateful and manages the states with a state file. When you want to make changes to your deployment environment, you make the changes to the main.tf file, and apply the changes. Terraform compares the main.tf file to the state file and makes the appropriate changes to Azure. 
This is also why it’s important to only make changes to your deployment environment through Terraform, and not through the Azure CLI once you deploy with Terraform. This is because Terraform checks the state file, and not the Azure environment directly.
</p>

#### Learning Azure

<p>The first thing I need to do was get familiar with Azure, and the Virtual Desktop environment. How to create Resource Groups, Host Pools, and VM's for the host pool.<p/>

#### Steps to create an Azure Virtual Desktop

Global Resources
Create a resource group
	Ex Win10RG
Create Virtual Network
	Select the RG for this vnet
Virtual Network needs to have a subnet, create a subnet next

Virtual Desktop Resources
Create Virtual Desktop Resource Pool for RG (grouping of vm’s)
	Ex Win10RG Host Pool
	Create a pooled resource, depth-first with connection limit per vm
 Create Session Hosts (virtual machines) for the Host Pool
	In order to create a Session host, you first have to create a registration key from the console

A Workspace for the Virtual Desktop is what is going to be shown on the client machine when we log in to the WVD

https://client.wvd.microsoft.com/arm/webclient/index.html  
This is the link you use to log into a AVD environment

When I tried to login, I couldn’t use my Gmail account, the one I’m logged in to Azure with. I tried my gatech.edu account, but it said my Sys Admin hadn’t set up the service…



### Learning to use Terraform with Azure

<p>
- Went to the Terraform docs
<br>
- Checked for Azure provider
<br>
- Terraform gives you the code needed to start using Azure provider, then you run terraform init
<br>
- Before you can use Terraform to deploy to Azure, you need to run a couple commands
<br>
    - az login
    <br>
    This takes you to an Azure login page for your account
    <br>
    - az extension add --upgrade -n account
    <br>
    This command installs the account plugin for the az-cli so you can manage multiple accounts, and list the account you're currently using
<br>
Once you're logged in to your account, you can start creating the main.tf file, and run the terraform commands
<br>
    - terraform init
    <br>
    - terraform plan
    <br>
    - terraform apply
</p>
<br>
<p>
I was able to log in to Azure through the cli, create a main.tf file and deploy a resource group and a Virtual Desktop Application
</p>

### Dockerizing the Application

<p>I created a Dockerfile for the app to run it in a container so that I can verify that it will run the same on Azure as it does on my machine.
<br>
It wasn't as straight forward as some other Docker instances. The CMD line had to be modified to reflect Flask running the application locally on localhost:5000.
<p/>

### Lesson Learned

<p>Terraform creates a .terraform file that is bigger than 100MB. When you try to push it to your git repo it's rejected as too big. You have to download and install git lfs (large file storage) in order to upload it to github.</p>
<p>I got very familiar with git errors, deleting local git repos, starting over, and re-initializing repos.</p>

<p><p/>