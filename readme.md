# Assignment 2 -- Multi-Tier Web Infrastructure

## Project Overview

This project demonstrates the deployment of a **multi-tier web
infrastructure on AWS using Terraform**.

An **Nginx server** acts as a **reverse proxy and load balancer**,
distributing incoming client traffic across multiple **Apache backend
servers**.\
The infrastructure includes **caching, rate limiting, custom error
pages, and automated health checks** to improve performance,
reliability, and fault tolerance.

------------------------------------------------------------------------

## Architecture Overview

    ┌─────────────────────────────────────────────────┐
    │                  Internet                       │
    └─────────────────┬───────────────────────────────┘
                      │
                      │ HTTP (80) / HTTPS (443)
                      ▼
             ┌────────────────────┐
             │   Nginx Server     │
             │  (Load Balancer)   │
             │   - Reverse Proxy  │
             │   - Caching        │
             │   - Rate Limiting  │
             └────────┬───────────┘
                      │
          ┌───────────┼───────────┐
          │           │           │
          ▼           ▼           ▼
       ┌─────┐     ┌─────┐     ┌─────┐
       │Web-1│     │Web-2│     │Web-3│
       │     │     │     │     │(BKP)│
       └─────┘     └─────┘     └─────┘
       Primary     Primary     Backup

------------------------------------------------------------------------

## Components Description

### Nginx Server (Load Balancer)

-   Entry point for all client traffic\
-   Distributes requests to backend servers\
-   Implements:
    -   Reverse proxy
    -   HTTP caching
    -   Rate limiting (429 responses)
    -   Custom error pages (404, 502, 503)

### Backend Servers (Web-1, Web-2, Web-3)

-   Run **Apache HTTP Server**
-   Serve static web content
-   Web-1 and Web-2 are **primary servers**
-   Web-3 acts as a **backup server**

### Terraform

-   Infrastructure as Code (IaC) tool
-   Automates provisioning of:
    -   EC2 instances
    -   Networking components
    -   Security groups

------------------------------------------------------------------------

## Prerequisites

### Required Tools

-   Terraform
-   AWS CLI
-   SSH client
-   Git

### AWS Credentials Setup

Configure AWS credentials using:

    aws configure

Provide AWS **Access Key**, **Secret Key**, **region**, and **output
format**.

### SSH Key Setup

Create or use an existing EC2 key pair:

    chmod 400 key.pem

------------------------------------------------------------------------

## Deployment Instructions

### Step-by-Step Guide

Clone the repository:

    git clone <repository-url>
    cd Assignment2

Initialize Terraform:

    terraform init

### Variable Configuration

Edit `terraform.tfvars`:

    region   = "eu-north-1"
    key_name = "my-key"

Validate configuration:

    terraform validate

Deploy infrastructure:

    terraform apply

Type **yes** when prompted.

------------------------------------------------------------------------

## Configuration Guide

### How to Update Backend IPs

Edit Nginx upstream configuration:

    upstream backend_servers {
        server 10.0.10.135;
        server 10.0.10.136;
        server 10.0.10.137 backup;
    }

Reload Nginx:

    sudo systemctl reload nginx

### Nginx Configuration Explanation

-   `proxy_pass` -- forwards requests to backend servers\
-   `proxy_cache` -- enables response caching\
-   `limit_req` -- enforces rate limiting\
-   `error_page` -- handles custom error responses

------------------------------------------------------------------------

## Testing Procedures

### Test Load Balancing

    curl http://<nginx-public-ip>

### Test Rate Limiting

    seq 1 20 | xargs -n1 -P10 curl -I http://<nginx-public-ip>

### Verify Cache

Check response headers for cache status.

------------------------------------------------------------------------

## Architecture Details

### Network Topology

-   Single VPC
-   Public subnet for Nginx
-   Backend servers accessible only through Nginx

### Security Groups Explanation

**Nginx Security Group** - Allow HTTP (80) - Allow SSH (22)

**Backend Security Group** - Allow HTTP from Nginx only - Allow SSH for
administration

### Load Balancing Strategy

-   Nginx round-robin load balancing
-   Backup server activated if primary servers fail

------------------------------------------------------------------------

## Troubleshooting

### Common Issues and Solutions

**Backend not responding**

    sudo systemctl status httpd

**502 / 503 Errors** - Verify backend IP addresses - Ensure Apache is
running on backend servers

### Log Locations

-   Nginx access log: `/var/log/nginx/access.log`
-   Nginx error log: `/var/log/nginx/error.log`
-   Backend health log: `/var/log/backend_health.log`

### Debug Commands

    nginx -t
    systemctl status nginx
    systemctl status httpd
    terraform plan
