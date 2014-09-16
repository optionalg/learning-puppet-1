Puppet Demo Walkthrough
========================

## Demonstration One:  vmware_fusion

1.  Bring up the Puppetmaster with `vagrant up puppetmaster`

Note a few items while this is booting:

* Introduce Vagrant.  Vagrant is a tool for managing virtual machines.
* Discuss bootstrapping - the need to ensure that the puppet agent / master is installed.  In this case the Vagrant machine already has the puppet environment installed.
* Discuss the bootup process - the inventory of managed resources as the md5 hashes roll by.
* Discuss what the process is doing - installation of the mcollective client and middleware on the puppetmaster, installation of the mcollective client, nginx web server and the checkout of a web application.

2.  Bring up one of the web machines with `vagrant up web01`.  While this is booting

* Discuss the agent infrastructure - how the agent creates and submits a certificate to the puppetmaster.
* Show the installation of software via the catalog that did not happen with the puppetmaster.

After bootup..

3.  SSH in to the web01 machine - obtain the IP address using the `ipconfig` command.  Open a web browser to http://<Ip Address>/

4.  Make a change to the web application in the GitHub interface (up the release number) and execute a `puppet agent -t` run on the web node.  Show that the application has changed.

5.  Destroy the puppetmaster and web01 environments.

## Demonstration Two:  AWS

With the vmware_fusion application destroyed, make sure the AWS console is open.

1.  Bring up the AWS puppetmaster with `vagrant up puppetmaster --provider=aws`

While this boots,

* Discuss the difference in infrastructure and strategy for hosting.  In this case, how puppet can be used to provision many types of environments - from local hypervisors to cloud environments.  (Note:  "platform independent".)
* Open the AWS console to show the creation of the machine.  

Once this has finished booting,

2.  Bring up the other environments with `vagrant up`.  Show that this process is operating in parallel.  (i.e. there is no difference in boot order for the puppetmaster.)

* Discuss a bit about the differences in platform - how puppet might use different package repositories,management tools, etc.

Once this has finished booting, 

3.  Find the HAPRoxy machine IP address.  Open http://<<HA PROXY IP>>/puppet/

4.  SSH in to the puppetmaster.  Use `mco ping` to demonstrate finding machines with MCollective.

5.  Make a modification to the web application.  Deploy on web01 with  `mco puppet runonce -I web01`. 

6.  Stop the web02 machine with `mco service nginx stop -I web02`.  Show that the change is effective.  Stop web01, start web02.  Show differences.  Start nginx on both machines.

7.  Finish the deployment with a puppet run on both machines.  

*** Continue with the other material***

