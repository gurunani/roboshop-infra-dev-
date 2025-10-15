# AWS Load Balancer Setup with EC2 and Nginx

This guide documents the steps I followed to set up **Load Balancing** using **AWS Application Load Balancer (ALB)** with two EC2 instances running **Nginx**.

---

## 🧱 Architecture Overview

- 2 EC2 Instances (Amazon Linux / Ubuntu)
- Nginx installed on both instances
- Each EC2 serves different HTML content
- ALB (Application Load Balancer) configured
- Target Group with both EC2s registered
- Load balancing behavior: **Round Robin**

---

## ✅ Step-by-Step Setup

### 1. Launch Two EC2 Instances

- Region: `us-east-1`
- Instance Type: `t3.micro`
- OS: Amazon Linux 2 or Ubuntu
- Open ports **22 (SSH)** and **80 (HTTP)** in the Security Group
- Optionally name instances: `sql 1`, `sql 2`

---

### 2. Install Nginx on Both EC2 Instances

SSH into each EC2 instance and run the following:

For Amazon Linux:
```bash
sudo yum update -y
sudo yum install nginx -y
````

For Ubuntu:

```bash
sudo apt update -y
sudo apt install nginx -y
```

Start and enable Nginx:

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```

---

### 3. Add Different HTML Content on Each Server

On `sql 1`:

```bash
echo "Hi I am GURUvaa - Server 1" | sudo tee /usr/share/nginx/html/index.html
```

On `sql 2`:

```bash
echo "Hi I am GURUvaa - Server 2" | sudo tee /usr/share/nginx/html/index.html
```

---

### 4. Create a Target Group

* Go to **EC2 > Target Groups**
* Create a new **Target Group**:

  * Target Type: **Instance**
  * Protocol: **HTTP**
  * Port: **80**
* Register both EC2 instances
* Wait until both show **Healthy** under health status

---

### 5. Create an Application Load Balancer (ALB)

* Go to **EC2 > Load Balancers**
* Create Load Balancer → **Application Load Balancer**

  * Scheme: **Internet-facing**
  * Listener: **HTTP : 80**
  * AZs: Enable those where your EC2s run
  * Target Group: Attach the one you created above

---

### 6. Test the Setup

* Go to **EC2 → Load Balancers**
* Copy the **DNS name** (e.g., `my-alb-123456.us-east-1.elb.amazonaws.com`)
* Open it in browser:

```
http://<your-alb-dns-name>
```

* Refresh the browser multiple times — it should show responses from both instances.

---
