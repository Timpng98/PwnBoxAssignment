In this folder, I use terraform in aws to create the linux ubuntu environment as well as juiceshop and the vulnerable windows server.

Terraform 
This folder contains:
- Juiceshop folder
- linux folder
- network folder
- windows server folder
- locals.tf
- main.tf
- outputs.tf
- provider.tf
- variables.tf
- juice.sh 
- linux.sh

Each of the folders contain a main file, output file and variables file that each pertain to it individually

Within the terraform main file, that is where the modules for juiceshop, linux and the windows server is created from the aws ec2, 
the outputs file contains the output for after terraform apply has been run, it shows the ip address that the user can ssh into.

The 2 .sh files are command files that are run within the command prompt to install all the necessary components
