# Code to Production in 3 Minutes on K8s

## Introduction

In this tutorial, we will:

* Deploy a 12 Factor App to Kubernetes in minutes
* Create a MongoDB service instance from a curated catalogue of services
* Connect the app to the service
* Take a look at what is running on Kubernetes to make this possible

...and all **without writing any YAML!**

What's more, we'll all be sharing _one_ Kubernetes cluster safely. This is known as multi-tenancy.

### Ready to begin?

When you're ready, click the **Next button** below.

## Getting Started

### Google Cloud Shell

This is Google Cloud Shell. Google Cloud has provisioned a free VM that you can access via this web UI.

We've installed the tools and configuration you need into the image of the VM.

### Student Numbers

You should all have been assigned a student number. You'll need this at various points throughout the course.

When referring to _your_ student number in instructions, this will be stylised as `${STUDENT_NUMBER}`.

## The `cf` CLI

We're going to use Cloud Foundry to take our code and turn it into a running pods on Kubernetes.

Cloud Foundry has a number of components that run in the Kubernetes cluster, and a **command-line interface**: the `cf` CLI.

Let's check that the tool is installed correctly.

```bash
cf version
```

### Checking your work

You should see something similar to:

```
cf version 6.44.1+c3b20bfbe.2019-05-08
```

---

### Exploring, Getting Help

If you want to move ahead and explore the functionality offered by Cloud Foundry, or you get stuck, you can use the `cf` CLI's built-in documentation:

* `cf help` provides help on common commands
* `cf <command> --help` gives detailed help on a command
* `cf help -a` shows all the commands

## Logging into Cloud Foundry

Use the following command to log into the Cloud Foundry running on our Kubernetes cluster:

```bash
cf login -a https://api.cap.engineerbetter.com --skip-ssl-validation
```

When prompted, enter:

* Email: `student${STUDENT_NUMBER}@engineerbetter.com` _eg student117@engineerbetter.com_
* Password: `student-${STUDENT_NUMBER}` _eg student-117_

### Checking Your Work

You should see something like this, but with _your_ student number:

```
API endpoint:   https://api.cap.engineerbetter.com (API version: 2.134.0)
User:           student117@engineerbetter.com
Org:            students
Space:          student117
```

---

### Targeting Orgs and Spaces

Kubernetes has logical divisions called Namespaces. To differentiate _its_ logical divisions, Cloud Foundry is split into Organisations and Spaces. Apps live in spaces, and spaces live in orgs.

You are already targeting an org and space.

How do you think Cloud Foundry knew which one you would like to target?

## The App

There's a very simple NodeJS app in the `cf-mongo-sample` directory.

If you are curious, you can read the app code using the Google Cloud Shell editor. We won't be making any changes to it.

Change to the `cf-mongo-sample` directory, and list the files in there:

```bash
cd cf-mongo-sample
ls -la
```

You'll notice that we don't have a Dockerfile.

### Deploying the App

Let's get our app running, in production, with one simple command:

```bash
cf push
```

You'll see a whole stream of logs scroll past over the course of **one or more minutes**.

Cloud Foundry does a _lot_ of work for you, including:

* **Building a container image** with whatever dependencies your app needs - like NodeJS!
* **Scheduling StatefulSets** in Kubernetes to make our app run
* Configuring an **HTTP ingress with a friendly URL** so that users can access the app

### Checking Your Work

When your app is successfully pushed, you should see a table describing your running application:

```
name:                mongo-sample
requested state:     started
isolation segment:   placeholder
routes:              mongo-sample-quick-alligator.cap.engineerbetter.com
last uploaded:       Wed 05 Jun 23:15:02 CEST 2019
stack:               sle15
buildpacks:          nodejs

type:            web
instances:       1/1
memory usage:    1024M
start command:   node index.js
     state     since                  cpu    memory    disk      details
#0   running   2019-06-05T21:15:05Z   0.0%   0 of 1G   0 of 1G
```

---

### Accessing the App

Now, let's access our app.

You can get a summary of all apps in the current space and the URLs with:

```bash
cf apps
```

Notice that even though many people have pushed apps, **you can only see your own**. This is an example of Cloud Foundry's multi-tenancy in action.

Copy the URL from the `urls` output and visit it in a browser.

### Checking Your Work

You should see a simple line of text, saying that there's a `null` MongoDB instance.

```
Hello with service null
```

In the next task, we'll fix this by creating a MongoDB instance and binding it to the app.

## Provision a MongoDB Instance

Our app is expecting to be able to connect to a MongoDB instance. Let's create one, again without writing any YAML.

### The Marketplace

Cloud Foundry created the notion of a service marketplaces. In this sense, the term "service" means 'a thing an app can use', like a database or a message broker. Kubernetes uses the term "service" to mean a collection of pods that can be targeted with traffic.

Let's see what services are available to us:

```bash
cf marketplace
```

### Checking Your Work

You should see a single service with a single plan available. It's almost as if someone set up this Cloud Foundry _just_ for today's tutorial!

```
OK

service   plans   description              broker
mongodb   4-0-3   Helm Chart for mongodb   minibroker

TIP: Use 'cf marketplace -s SERVICE' to view descriptions of individual plans of a given service.
```

---

### Create a Service Instance

Let's create our own MongoDB server instance.

```bash
cf create-service mongodb 4-0-3 mymongo
```

### Checking Your Work

You should see the following:

```
Creating service instance mymongo in org students / space student1 as student117@engineerbetter.com...
OK
```

---

### Binding the App to the MongoDB Instance

We need to let Cloud Foundry know that our particular app would like to be able to communicate with this particular MongoDB instance.

The app will need credentials to be generated for it, and will need to be able to access those credentials. We do that with the `bind-service` command.

Use `cf bind-service --help` to figure out how to bind your app to the MongoDB instance called `mymongo` that you created previously.

_Hint: you **don't need any optional arguments**._

### Checking Your Work

Run `cf services`, and you should `mongo-sample` appear in the `bound apps` section:

```
Getting services in org students / space student117 as student117@engineerbetter.com...

name      service   plan    bound apps     last operation     broker       upgrade available
mymongo   mongodb   4-0-3   mongo-sample   create succeeded   minibroker
```

## Writing and Reading Data

Cloud Foundry provides credentials for the MongoDB instance to the app via environment variables.

Let's restart the app now the binding has been made:

```bash
cf restart mongo-sample
```

### Checking Your Work

If everything has been done correctly, when you visit your app you should see some details of the MongoDB instance it has connected to on the app's home page:

```
Hello with service mongodb://root:5fs2BoJBFF@rolling-turtle-mongodb.minibroker.svc.cluster.local:27017
```

---

### REST API

Let's _prove_ that our app can talk to MongoDB by posting some data to the app, and then reading it back.

Run the following command, substituting ${APP_URL} for the URL of _your_ app.

```bash
curl -i -k -X POST -d '{"num": 1}' https://${APP_URL}/items/ein
```

### Checking Your Work

Get the data back out with the following command:

```bash
curl -i -k https://${APP_URL}/items/ein
```

You'll get back the data you posted in, along with the ID that MongoDB assigned it based on the URL used:

```
HTTP/1.1 200 OK
Content-Length: 21
Content-Type: application/json; charset=utf-8
Date: Wed, 05 Jun 2019 21:33:36 GMT
Etag: W/"15-qhLrBlTLDJEI3jsD4fKE+ILR0CY"
X-Powered-By: Express
X-Vcap-Request-Id: 6b51ea25-0bd6-4c03-72e7-57b29829132e

{"_id":"ein","num":1}
```

## Kubernetes - Under The Hood

So far we've been using the `cf` CLI to complete abstract away the underlying platform, and all of the complicated YAML that goes with it. Cloud Foundry has provided us with sensible default behaviour for a 12 Factor app.

Sometimes you need access to Kubernetes directly - perhaps if you're running a machine learning workload, or running your own data services.

Let's take a look at the namespaces in our Kubernetes cluster:

```bash
kubectl get namespaces
```

### Checking Your Work

You should see a list similar to this:

```
NAME          STATUS   AGE
cf            Active   4h42m
default       Active   5h33m
eirini        Active   5h20m
kube-public   Active   5h33m
kube-system   Active   5h33m
minibroker    Active   5h20m
uaa           Active   5h20m
```

---

### Where Are Our Apps?

The `cf` namespace is where all the Cloud Foundry components run.

The `eirini` namespace is named after a component of Cloud Foundry that interfaces with Kubernetes, and contains all of the apps we have scheduled.

Let's take a look at the pods that make up all of the apps the class has deployed:

```bash
kubectl get pods -n eirini
```

### Checking Your Work

You should see a list similar to this:

```
NAME                              READY   STATUS    RESTARTS   AGE
mongo-sample-student117-7d8qv-0   1/1     Running   0          8m50s0s
mongo-sample-student343-8kj9t-0   1/1     Running   0          20m
...
```

Notice how **we can see all users' apps**, and not just those in our org and space. Now we're accessing Kubernetes directly, we're viewing things 'below' the Cloud Foundry tenancy abstraction.

---

### Where Are Our MongoDB Instances?

The `minibroker` namespace contains the **Minibroker service broker**, and all the MongoDB service instances that it created.

Using commands you've already used, take a look at the pods in the `minibroker` namespace.

## Discussion

### Apps

We didn't provide a container image to Cloud Foundry; instead, the platform built an image for us.

It does this using a technology called "buildpacks". If you've used Heroku you may be familiar with them already.

Buildpacks are a programmatic alternative to Dockerfiles. Cloud Foundry detects the right one for your app, asks it to provide all the files your app needs, and then layers this on top of a root filesystem.

This approach has three key advantages:

* developers don't need to care about building images, and picking Linux distributions; they just push their code
* if a zero-day vulnerability is found in an underlying library, **the operator can rebuild all images** on the platform without needing to disrupt developers.
* the operators can limit the root filesystems and buildpacks on offer, meaning they're in control of the bytes that are deployed into their cluster

Although buildpacks have been around for many years, they've been brought right up-to-date with [Cloud Native Buildpacks](buildpacks.io).

### Routes

Cloud Foundry assumes your app is a 12 Factor web app, and sets up an HTTP ingress for it. In our example. it even picked a random URL so your app's route did not clash with any of the other students' apps.

One app can have many routes, and one route can have many apps. This can be used to enable zero-downtime deployments, A/B testing, and more.

Routes can also be bound to Route Services. These are re-usable components that can intercept or modify HTTP requests. Common examples include caching, rate limiting, or performing authentication and authorisation checks. Re-using a route service means that these responsibilities aren't duplicated across all of your apps.

### Multi-tenancy

Cloud Foundry provides hard multi-tenancy. It's so trusted that it's used by governments in the USA, United Kingdom, South Korea, Australia, Switzerland, and many more. It's also used and trusted by the US Air Force, and virtually all the biggest banks and manufacturers.

Cloud Foundry has all the kernel security settings enabled by default - there are no 'privileged' containers possible.

### Services

Offering a marketplace of services means that the platform operator can curate a list of well-know and trusted integrations.

The [Open Service Broker API](https://www.openservicebrokerapi.org/) abstraction means that these services could be implemented in any number of ways:

* Kubernetes pods on the same cluster
* VMs deployed in the same data centre
* Databases-as-a-Service hosted in the cloud
* IaaS services, like Amazon RDS or Google Spanner
* Legacy, on-premises databases handled by a DBA team

Again, the app developer doesn't need to know or care about this.

**Plans** allow services to be offered in different sizes, or with different SLAs. Perhaps the `dev` plan runs in a container, and the `prod` plan has guaranteed uptime and runs on dedicated hardware.

## Further Reading

* [Cloud Foundry official site](https://www.cloudfoundry.org/)
* [SCF GitHub repo](https://github.com/SUSE/scf)
* [Stratos UI GitHub repo](https://github.com/cloudfoundry-incubator/stratos)
* [SUSE Cloud Application Platform](https://www.suse.com/products/cloud-application-platform/)
* Free online Cloud Foundry ["Zero To Hero" training](http://zero-to-hero.engineerbetter.com/)
* [Cloud Native Buildpacks](https://buildpacks.io/)
* [Why continuous delivery on a self-service platform is better for your brain](https://www.youtube.com/watch?v=k9duArRuSjQ)
