# AWS Infrastructure with Terraform: Exercises and Deliverables

This repository contains a series of exercises to build and manage AWS infrastructure using Terraform. Each exercise builds upon the previous to incrementally create a robust, scalable, and secure architecture.

---

## **Exercise 1: Basic VPC Setup**

### **Goal**

Set up a Virtual Private Cloud (VPC) with subnets, route tables, and an internet gateway.

### **Requirements**

- Create a new VPC with CIDR `10.0.0.0/16`.
- Create two public subnets in different availability zones (AZs) (e.g., `10.0.1.0/24` and `10.0.2.0/24`).
- Create two private subnets in different AZs (e.g., `10.0.3.0/24` and `10.0.4.0/24`).
- Attach an internet gateway to the VPC.
- Create route tables:
  - Public route table with a default route to the internet gateway.
  - Private route table for private subnets with no internet access.
- Associate the subnets with appropriate route tables.

### **Deliverable**

Terraform configuration files deploying a working VPC setup.

---

## **Exercise 2: Add Networking Components**

### **Goal**

Add security groups, NAT gateways, and adjust networking for public/private subnets.

### **Requirements**

- Create a NAT gateway in one of the public subnets.
- Update the private route table to route traffic through the NAT gateway for outbound internet access.
- Create security groups:
  - Public security group allowing inbound SSH (port 22) and HTTP (port 80) access from anywhere.
  - Private security group allowing only inbound access from the public security group.
- Ensure private subnets can only access the internet via the NAT gateway and not directly.

### **Deliverable**

Terraform updates with NAT gateway and security group configurations.

---

## **Exercise 3: Launch an Application in the Public Subnet**

### **Goal**

Deploy an EC2 instance in a public subnet with a web server.

### **Requirements**

- Launch an EC2 instance in one of the public subnets using an Amazon Linux 2 AMI.
- Attach the public security group to the instance.
- Use a user data script to install a web server (nginx or httpd) and serve a simple HTML page.
- Output the public IP address of the instance.

### **Deliverable**

Terraform updates with an EC2 instance running a web server accessible over the internet.

---

## **Exercise 4: Add a Private Application Layer**

### **Goal**

Deploy an application in the private subnet, communicating with the public EC2 instance.

### **Requirements**

- Launch an EC2 instance in one of the private subnets using an Amazon Linux 2 AMI.
- Attach the private security group to the instance.
- Use a user data script to set up a simple service (e.g., Python Flask or Node.js app) that listens on port 8080.
- Ensure the public EC2 instance can communicate with the private instance over port 8080.
- Update the web server on the public instance to forward requests to the private instance.

### **Deliverable**

Terraform configurations with a web server in a public subnet communicating with a backend service in a private subnet.

---

## **Exercise 5: Add Load Balancing**

### **Goal**

Introduce an Elastic Load Balancer (ELB) for public access to the application.

### **Requirements**

- Deploy an Application Load Balancer (ALB) in the public subnets.
- Attach a target group to the ALB pointing to the public EC2 instance.
- Create health checks for the target group on port 80.
- Update the DNS of the ALB to provide a friendly hostname output (use AWS default DNS or Route 53).

### **Deliverable**

Terraform configurations with an ALB distributing traffic to the web server.

---

## **Exercise 6: Add Auto Scaling**

### **Goal**

Scale the public EC2 instance dynamically based on load.

### **Requirements**

- Create an Auto Scaling Group (ASG) for the public EC2 instances with a minimum of 1 and a maximum of 3 instances.
- Attach the ASG to the ALB target group.
- Use an EC2 Launch Template or Launch Configuration for the ASG.
- Add scaling policies:
  - Scale out when average CPU utilization exceeds 70%.
  - Scale in when average CPU utilization falls below 30%.
- Ensure new instances use the same user data script for the web server.

### **Deliverable**

Terraform configurations for an auto-scaling public-facing application.

---

## **Exercise 7: Add a Database Layer**

### **Goal**

Introduce a private RDS database for backend data storage.

### **Requirements**

- Create an RDS instance in the private subnets (e.g., MySQL or PostgreSQL).
- Ensure the database is accessible only from the private EC2 instance.
- Use Terraform to securely store database credentials in AWS Secrets Manager or SSM Parameter Store.
- Update the private application to connect to the database and perform basic CRUD operations.

### **Deliverable**

Terraform configurations with a secure database layer integrated into the architecture.

---

## **Exercise 8: Logging and Monitoring**

### **Goal**

Add centralized logging and monitoring for the application.

### **Requirements**

- Enable CloudWatch logging for the public and private EC2 instances.
- Create alarms for:
  - High CPU utilization on the ASG (>80%).
  - Low healthy hosts on the ALB target group (<2).
- Configure CloudWatch dashboards to display:
  - Application performance metrics.
  - Database metrics (e.g., CPU and memory usage).
- Output the CloudWatch dashboard URL using Terraform.

### **Deliverable**

Terraform configurations with integrated monitoring and logging.

---

## **Exercise 9: Infrastructure as Code Best Practices**

### **Goal**

Refactor the codebase for modularity and reusability.

### **Requirements**

- Split the Terraform code into modules:
  - Networking (VPC, subnets, gateways, route tables, security groups).
  - Compute (EC2, ASG, ALB).
  - Database (RDS).
  - Monitoring (CloudWatch).
- Use remote state storage (e.g., S3 with DynamoDB locking) for managing Terraform state.
- Implement workspaces for separate environments (e.g., dev, staging, production).

### **Deliverable**

A modular, environment-ready Terraform repository following best practices.
