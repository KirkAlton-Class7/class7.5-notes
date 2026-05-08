# Class7-5 / SEIR-1: Week 3 prep notes

## Table of Contents


---

## Introduction 
This week will be covering fundamental networking principles and the basics of VPCs (Virtual Private Cloud networks). We will create a VPC and deploy a VM in it. 

## Class Overview
* Discuss Goals
* Naviate to VPC network service and create VPC
* Spin up VM in created VPC
* Discuss the end goal
* Troubleshooting


## Key Terminology (in simple-ish terms)
* **IP Address:** The address to find a computer (such as a server). It is split into 4 "octets" such as 10.20.30.40 with 3 decimals. Each decimal number will be between 0–255 inclusive (it can be 0 or 255, such as 255.255.255.0). 
* **Private IP Address:** A Private or **Internal** IP address is an IP address that _is not_ routable to the internet (it has no inbound internet access)
* **Public IP Address:** A Public or **External** IP address is an IP address that _is accessible_ from the public internet. This means anyone from the internet could use this IP Address (assuming there are no additional network security controls in place like **Firewall Rules**)
* **Virtual Private Cloud:** Typically called a **VPC**. This is the network that your resources use in GCP. This network is entirely under your control. Similar to how your home network is a LAN, the VPC could be considered your "LAN in the cloud". These are _scoped_ globally (a unique feature to GCP) as well as being scoped to a project. 
* **Subnetworks:** Typically called **Subnets**. These are logical groupings of a larger network. In GCP these are _scoped_ to regions. Subnets within a VPC live in regions. 
* **Outbound Traffic:** Network traffic that is _leaving_ the VPC. This is also called **Egress** traffic. 
* **Inbound Traffic:** Network traffic that is _coming into_ the VPC. This is also called **Ingress** traffic. 
* **Internal Traffic:** Communications between resources that stay within the network (in our case, the VPC). Traffic between subnets within a single VPC is considered internal traffic. 
* **NAT:** For now, NAT (Network Address Translation) is a service that allows **Private IP Addresses** to access the **Public** internet (outbound internet access)
* **HTTP:** Hypertext Transport Protocol, which is the protocol websites were built on. Typically not used today in favor of HTTPS but used widely for testing. It uses the protocol "TCP" to transfer data and traditionally uses port 80 (it doesn't have to; often 8080 and 5000 are used for example). 
* **SSH:** Secure Shell protocol, which is a protocol that uses cryptographic keys to create a secure "tunnel" to another computer and allows you to access its shell and execute commands with your own (or GCP's pseduo-) command line interface.

## Preliminary Materials:
- Consider adding TCP/IP overview 
- [IP Addresses](https://youtu.be/ThdO9beHhpA?si=SqqYI0ts6ZRny0ZM)
- [Public vs Private IPs](https://youtu.be/po8ZFG0Xc4Q?si=6adHwtwnwxYMMSdc)
- [LAN vs Subnet](https://youtu.be/NyZWSvSj8ek?si=r7SToFuzz_4jXK9T)

- [Subnet Masking](https://youtu.be/s_Ntt6eTn94?si=n9o-Z0nRECQdYYag)
- [Subnet Basics](https://youtu.be/hbdT_Q9DM8w?si=xrhvMMUsTS8aq7vl)

- [Ports](https://youtu.be/g2fT-g9PX9o?si=uEI11uVJVaCniQ6U)
- [Firewall basics](https://youtu.be/kDEX1HXybrU?si=KGd1s1woXLVylwhk)



- [Route tables](https://youtu.be/CGmTvukObOw?si=yN_yYKSx3oxeeb34)
- [Default/Internet Gateway](https://youtu.be/pCcJFdYNamc?si=7dfjvz_9zGvHdv3y)
- [NAT](https://youtu.be/FTUV0t6JaDA?si=2z1ifI0bREnnnZT1)

- [DHCP](https://youtu.be/e6-TaH5bkjo?si=PnU54n1VZDuwgeh4)
- [VPC Basics](https://youtu.be/2fPgKvDBfbs?si=XQjIzsqgWuPa6BfU)
- [HTTP Basics](https://youtu.be/KvGi-UDfy00?si=gScTlYrWJhPLRqrD)

- [Networking in GCP context](https://youtu.be/XLaFU1t9pM8?si=RSGiWVmkG09Dkjtc)

## GCP Networking 

Discuss VPC structure and service scope, Default GW, routing, NAT, lack of distinct private/public subnets, firewall rules 

## Class Lab 

We are going to be creating our own VPC for the lab. This is opposed to using the default VPC (which every GCP project has by default). Using a default VPC is not a best practice. Creating our own VPC gives us more granular control. The default VPC's settings should not be modified. 

### Preliminaries 
You need to be able to confidently create a VM. You need a configured GCP account. Ideally you will have gcloud configured. You should have familarized yourself with the networking fundamentals. 

### Create VPC
1. Start at the Console Welcome page. 
2. Go to the **Hamburger Menu**.
3. Click on **VPC Network**.
4. Click on **Create VPC Network**
5. Name your VPC and add a description. The name must conform to GCP naming conventions. The description does not. 
6. Do not modify (but note) that the **Set MTU automatically** option is checked by default (unless you're a network engineer you are unlikely to edit this) and the **subnet creation mode** is set to **custom**. We want to have full control over the subnet and do want want them to span over the entire global infrastructure so we want to manually create the subnets. See [here](./assets/create-vpc.PNG)
7. Next is subnet configuration:
    - We can create an arbitrary number of subnets. As discussed subnets are regional resources thus we must set regions for them. We will only deal with IPv4 in this class (and unless you deal with IoT on the job you will likely not deal with IPv6). 
    - Name your subnet, give it a description and choose a region. These details are up to you. Names must always follow GCP naming conventions. 
    - Choose a CIDR Range for your subnet. Ensure it is valid and it should have a mask of 24 bits. GCP will tell you if it is reserved or if not valid. 
    - See [here](./assets/create-subnet.png)
8. Create another subnet by selecting **Add subnet** and repeating the above process. 

### Configure Firewall Rules
1. Before finishing the VPC creation we have the option to choose several default firewall rules. 
2. Look [here](./assets/default-fw.PNG)
    - A) This is to enable certain default firewall rules
    - B) Note the names. "Allow" or "Deny" is in the name as well as the protocol. 
    - C) Direction of traffic this firewall rule applies to. Ingress means it applies to traffic entering the VPC (or VM) while Egress is traffic leaving the VPC (or VM).
    - D) Source Filters are _where_ the traffic is originating from. Here it is IP ranges. Note for the first rule it is a list of my subnet's CIDR ranges. For the other rule's it is the wildcard range (0.0.0.0/0 meaning any IP address). 
    - E) This is the protocol and port (specifically the layer 3/4 protocol and port, not layer 7). So instead of seeing "HTTP" here we would see "tcp:80" for example. "all" is a valid value as well. 
    - F) This is **Action on match** and says when traffic of a certain protocol from a certail source filter of a certain direction fits a certain rule then should the firewall allow or deny it. 
    - G) Priority is used to determine which firewall rule takes precedence. Firewall rules make share the same priority. This value 16 bits and includes zero meaning it is zero to `2^16-1` in base-2. More simply, in decimal valid values are integers (no fractions) from 0-65535 inclusive (zero and 65535 are valid too). The default value is 1000. The smaller the integer the higher the priority it is. This means if two rules conflict but rule A has priority of 100 and rule B has priority of 200 then rule A is the firewall rule that wins. 
3. To discuss the currently selected firewall rules and why: 
    1) This rule is postfixed with "allow-custom" which can be confusing. By default this rule permits all **internal** VPC traffic between subnets within the VPC. Without this rule subnets could not talk to each other. One can modify this rule in this menu (hence it being called "custom") but we won't. 
    2) This rule is postfixed wih "allow-icmp" and we won't spend much time discussing this. ICMP is a protocol that ping uses and could be useful for troubleshooting if needed but we may not use it. It allows inbound (it is an ingress rule) traffic to all VMs (targets is "Apply to all") with a source filer of 0.0.0.0/0 (meaning whoever sent the ICMP request such as ping could have any IP address). When all of these conditions are met the action is allow. Typically we would restrict this as malicious actors could abuse this protocol. 
    3) This rule is postfixed with "allow-ssh" and we likely _will_ use this. Looking at the rule settings we see that if there is inbound traffic to any VM in the VPC coming from any IP on tcp:22 (SSH) ten the rule will allow it. This is not the most secure rule but for learning it is okay. 
    4) Now finally we have two rules at the bottom that we have no option but to accept. One is postfixed with "deny-all-ingress" which means this rule will never allow inbound traffic to the VPC, **but** it is also at the lowest priority meaning any rule we make will take priority. Finally we have "allow-all-egress" which is a critical rule. We won't be making any rules that modify egress traffic rules because this rule is fine. It lets traffic **leave** the VMs in the VPC. Without it, traffic may be able to come into the VM but the VM could never respond. Also note it has the lowest possible priority. 
4) Documentation of Firewall rules:
    - [Google Firewall Rule overview](https://docs.cloud.google.com/firewall/docs/firewalls)
    - [Creating Firewall Rules](https://docs.cloud.google.com/firewall/docs/using-firewalls#console)
    - [API Schema](https://docs.cloud.google.com/compute/docs/reference/rest/v1/firewalls)

### Deploy VPC
Go to the very bottom of the page and click **create** 

### Add a Custom firewall rule 
Add details for HTTP rule w/ target tag (we using target tags right now????)

### Deploy VM 
This process will be nearly identical as to last week. We will have one additional setting to configure. 

1) Go to the Compute Engine and begin to create a VM
2) Set the Machine Configuration menu up like last week. Note: you must choose a region that you have a subnet in. 
3) Now in networking:
    - In the **Network Tags** field enter the network tag you created for HTTP
    - Under network interfaces drop down the nic0 menu 
    - Change the network to the VPC you created
    - Change the subnetwork to one that matches the region you choose 
4) Go to advanced and add a start up script like last week. 

## Troubleshooting
