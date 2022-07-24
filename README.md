# Chameleon Consulting Group Interview Scenario

## Goal:

### To create an Azure Virtual Desktop instance that is accessible from a specified IP range

### To deploy one HTTP server that is only accessible from the Azure Virtual Desktop

<br>

### Initial Thoughts

Need to create some sort of service to be hosted
Need to decide what IaC tool to use

I have created a simple REST api using python and the Flask framework. I chose python for its ease of use and flexibility. I used the Flask framework because it is a super lightweight framework but has a development webserver and sqlite3 db included in the framework.

### Decission Process

#### Tech Stack

#### IaC

I chose to use Terraform for my IaC tool because it is declarative vs imperative, as well, Terraform has an extensive registry of provider APIs that are built and maintained by the providers themselves. In the case of Azure, there are prebuilt tools in Terraform that work directly with Azure.

<br>

Being that Terraform is declarative, it makes it much easier to manage drift in your cloud deployment. You write statements telling Terraform what you want your deployment environment to look like, and not how Terraform should do it. You let the APIs do the work. Terraform is stateful and manages the states with a state file. When you want to make changes to your deployment environment, you make the changes to the main.tf file, and apply the changes. Terraform compares the main.tf file to the state file and makes the appropriate changes to Azure.
This is also why it’s important to only make changes to your deployment environment through Terraform, and not through the Azure CLI once you deploy with Terraform. This is because Terraform checks the state file, and not the Azure environment directly.

### Learning Azure

The first thing I need to do was get familiar with Azure, and the Virtual Desktop environment. How to create Resource Groups, Host Pools, and VM's for the host pool.

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
  <br>
- Once you're logged in to your account, you can start creating the main.tf file, and run the terraform commands
  <br> - terraform init
  <br> - terraform plan
  <br> - terraform apply
  <br>

#### Note: Be carefull with the terraform destoy command, it will destroy everything you have deployed with Terraform

<br>
I was able to log in to Azure through the cli, create a main.tf file and deploy a resource group and a Virtual Desktop Application

I am still having trouble logging in to the WVD environment I created manually. But now that I have a better understanding of how it is structured, I'm putting it together in Terraform and deploying the RG. There are some configurations that Terraform can't do so I'll have to edit them manually.

### Dockerizing the Application

I created a Dockerfile for the app to run it in a container so that I can verify that it will run the same on Azure as it does on my machine.
<br>
It wasn't as straight forward as some other Docker instances. The CMD line had to be modified to reflect Flask running the application locally on localhost:5000.

### Lesson Learned

Terraform creates a .terraform file that is bigger than 100MB. When you try to push it to your git repo it's rejected as too big. You have to download and install git lfs (large file storage) in order to upload it to github.
I got very familiar with git errors, deleting local git repos, starting over, and re-initializing repos.

Working with Azure is not as intiative and straight forward as one would hope right away. Things have to be done in a specific order. For instance, when creating a WVD, you need to create the resource group first, then the network and subnet, then you can create the host pool and other resources within the resouce group.

You need to be carefull about adding resources from the Azure portal and not with Terraform. That is what causes drift. But it seems that there are stil some things you can't do from Terraform, such as adding a Session Host (vm) to your WVD environment.

#### Update: day 4

I have been able to create a new virtual machine called Webserver. It is a Ubuntu 18.04 LTS server. It is provisioned, and I can test the connection through ssh on the Azure portal. The ssh test says connection to the server is accepted from my IP address...still not able to ssh from my terminal.
Changed the vm WebServer to ssh with username and password for right now instead of ussing ssh keys
I was able to create a new vm server and it allows you to create a new ssh key. I copied it to the .ssh dir, and was able to log in to the Test web server. Was able to get Docker installed and running on the WebServer test vm.
After a lot of trial and error, reading the Terraform docs, and googling, I still can't find a way to use Terraform to create the vm using ssh keys and connect. When you create the vm server through the Azure portal, you have the option of creating a new ssh key and downloading the private key. That allows access. I will keep working with the WVD environment to see if I can use that to connect to the Webserver vm. They are on the same vnet and subnet, as well as using the shared network interface.

#### Update: Day 5

Still trying to create a Session Host for the WVD through Terraform.
I found a couple of good articles on how to build WVD environments with Terraform, as well as a Session Host (FINALLY)
<br>
https://buildvirtual.net/how-to-deploy-wvd-using-terraform/
https://buildvirtual.net/how-to-deploy-wvd-session-hosts-using-terraform/
