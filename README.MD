# Roboshop VM Architecture
![Diagram](images/roboshop.svg)

# AWS Load Balancer in VPC — Simple Explanation

A **Load Balancer** in AWS is like a **traffic police for your servers**.

When many users try to access your application, instead of sending everyone to one server, the load balancer stands in the middle and **shares the traffic across multiple servers** so no single server gets overloaded.

---

## 🏗 How It Works Inside a VPC

- You place multiple **EC2 instances** (your app servers) in different **subnets** inside the VPC.  
- The Load Balancer gets a **public IP or DNS** that users access.  
- It checks which server is healthy and free, then sends the request there.  
- If one server goes down, the load balancer automatically skips it.

---
## 🧭 Types of Load Balancers

- **Application Load Balancer (ALB)** – Smart: routes traffic based on URL or content.  
- **Network Load Balancer (NLB)** – Fast: best for high performance and low latency.  
- **Gateway Load Balancer (GLB)** – Used for security appliances like firewalls.

---

## 🔁 Round Robin Method (Load Balancing Algorithm)

The **Round Robin** method is one of the simplest ways the Load Balancer distributes traffic:

1. First request → Server 1  
2. Second request → Server 2  
3. Third request → Server 3  
4. Fourth request → Back to Server 1

👉 This continues in a **circular pattern**, keeping the load evenly spread.

*Example:*  
If 300 users visit your site and you have 3 servers, each server will handle about 100 users.

---


# 🛡️ Bastion Host in AWS VPC

## 📌 What is a Bastion Host?
A **Bastion Host** (also called a **Jump Server**) is a **secure entry point** that allows you to access private servers in your VPC without exposing them to the internet.

It works like a **security guard at the gate** — you first connect to the bastion, then access the private servers from there.

---

## 🏗️ Network Components

- **Public Subnet** → Front yard (reachable from the internet).  
- **Private Subnet** → Inside rooms (not directly reachable).  
- **Internet Gateway (IGW)** → Main door to the outside world.  
- **Route Table** → Map that decides where traffic goes.

---

## ⚙️ How It Works

1. **Bastion Host** is placed in the **Public Subnet**.  
2. The Public Subnet has a **route to the Internet Gateway**, so you can connect to the bastion using SSH.  
3. **Private Servers** stay in the **Private Subnet**, without public IPs.  
4. Once connected to the bastion, you **“hop”** into these private servers securely.  
5. Route tables control the traffic flow:
   - Public Subnet → Route to IGW.
   - Private Subnet → Internal routes (or NAT if needed).

---


Got it — here’s your full content rewritten cleanly in **Markdown (.md)** format — with proper headers, code blocks, and structure that’ll render perfectly on GitHub, VS Code, or any Markdown viewer.

---

````markdown
# 🌐 The Complete Journey of `dev.gurulabs.xyz`

This guide explains — step by step — what happens when you visit your website.

---

## 🎯 PHASE 1: YOU TYPE THE WEBSITE ADDRESS

```text
You (in browser) → Type: dev.gurulabs.xyz → Press ENTER
````

---

## 🧭 PHASE 2: DNS — FINDING THE WEBSITE'S LOCATION

```text
Your Computer → "Where is dev.gurulabs.xyz?" → Internet
```

### What’s Happening

1. **Your Browser** says: “I need to find `dev.gurulabs.xyz`.”

2. **DNS Lookup** starts (like asking for directions):

   * First checks your **local cache**
   * Then your **ISP DNS**
   * Finally reaches **AWS Route 53** (Amazon’s address book service)

3. **AWS Route 53** replies:

   * “Hey! `dev.gurulabs.xyz` lives at:
     `roboshop-alb-123456789.us-east-1.elb.amazonaws.com`”
   * That’s your **Application Load Balancer (ALB)** address.

---

## 🚦 PHASE 3: APPLICATION LOAD BALANCER (ALB)

**What is ALB?**
A smart traffic officer that directs visitors to the right place.

**Name:**
`roboshop-alb-123456789.us-east-1.elb.amazonaws.com`

### What ALB Does

```text
ALB receives your request and checks: "Where should I send this person?"
```

**Routing Rules**

| Path      | Sent To                       |
| --------- | ----------------------------- |
| `/`       | Frontend Team (Website pages) |
| `/api/*`  | Backend Team (Server logic)   |
| `/cart/*` | Cart Team (Cart operations)   |
| `/user/*` | User Team (User accounts)     |

---

## ⚙️ PHASE 4: AUTO SCALING GROUPS — THE WORKER TEAMS

**What are Auto Scaling Groups?**
Groups of identical workers that handle traffic and scale automatically.

* When traffic increases → new workers (EC2s) are added
* When traffic drops → extra workers are removed

### Your Worker Teams

| Team Name         | Description                |
| ----------------- | -------------------------- |
| **Frontend Team** | Serves HTML, CSS, JS pages |
| **Backend Team**  | Handles business logic     |
| **Cart Team**     | Manages shopping cart      |
| **User Team**     | Handles user profiles      |

---

## 💻 PHASE 5: EC2 INSTANCES — THE INDIVIDUAL WORKERS

**What are EC2s?**
Cloud servers that actually run your app.

### Inside Each EC2

```bash
# Installed by Ansible
- OS: Amazon Linux
- Web Server: Nginx
- Files: HTML, CSS, JavaScript
- Config: Talks to other services (API, DB, etc.)
```

---

## 🧠 PHASE 6: THE WEBSITE IN ACTION

### 🏠 Visiting Homepage

1. You open `dev.gurulabs.xyz`
2. **DNS** finds ALB
3. **ALB** routes `/` → Frontend ASG
4. **Frontend EC2** serves `index.html`
5. Browser displays your homepage ✅

### 🔐 Logging In

1. You enter username/password → click “Login”
2. **ALB** routes `/api/login` → Backend ASG
3. **Backend EC2**:

   * Checks credentials in **Database (RDS)**
   * Creates session in **Redis**
   * Returns “Login Successful”
4. You see a personalized welcome page

---

## 🗄️ PHASE 7: DATABASE AND STORAGE

| Component           | Role              | Example                      |
| ------------------- | ----------------- | ---------------------------- |
| **RDS**             | Long-term storage | User data, orders, products  |
| **Redis**           | Fast cache        | Sessions, temporary data     |
| **Security Groups** | Firewall rules    | Control who can talk to whom |

---

## 🧩 YOUR INFRASTRUCTURE COMPONENTS

### 🔸 Application Load Balancer

* **Name:** `roboshop-alb`
* **Type:** Application Load Balancer
* **Spread across:** Multiple Availability Zones
* **Health Checks:** Keeps only healthy EC2s active

### 🔸 Auto Scaling Groups

```text
Frontend-ASG → EC2 (Nginx)
Backend-ASG  → EC2 (Node.js)
Cart-ASG     → EC2 (Cart Service)
User-ASG     → EC2 (User Service)
```

### 🔸 EC2 Instances

* Created from **AMI** (template image)
* Configured via **Ansible**
* Run the **RoboShop application**

### 🔸 Security Groups

| Type       | Allows                   |
| ---------- | ------------------------ |
| **ALB SG** | Internet (Ports 80, 443) |
| **EC2 SG** | Only ALB inbound         |
| **DB SG**  | Only app servers inbound |

---

## 🔄 COMPLETE FLOW VISUALIZATION

```text
YOU (Browser)
    ↓
dev.gurulabs.xyz (Domain Name)
    ↓
AWS Route 53 (Address Book)
    ↓
Application Load Balancer (Traffic Police)
    ↓
    ├── /homepage → Frontend ASG → EC2 (Nginx)
    ├── /api/*    → Backend ASG  → EC2 (Node.js)
    ├── /cart/*   → Cart ASG     → EC2 (Cart Service)
    └── /user/*   → User ASG     → EC2 (User Service)
        ↓
Database (RDS)
        ↓
Response → Back to YOU 🎉
```

---

## ⚡ REAL-TIME EXAMPLE: 100 USERS VISIT AT ONCE

1. **ALB** spreads traffic evenly
2. **Auto Scaling** checks CPU
3. **If load is high** → New EC2s launched automatically
4. **If load drops** → Extra EC2s terminated
5. **Result:** Smooth performance every time 🚀

---

## ✅ Summary

When you visit `dev.gurulabs.xyz`, your request travels through:

1. **DNS (Route 53)** → Finds ALB
2. **ALB** → Routes to correct service
3. **Auto Scaling Groups** → Assign EC2 workers
4. **EC2 + Ansible setup** → Serve pages or APIs
5. **RDS/Redis** → Store and retrieve data
6. **Response** → Returns to your browser

Everything runs seamlessly behind the scenes — that’s your full AWS-powered website journey.

```

---

Would you like me to generate this into a downloadable `.md` file too?
```
