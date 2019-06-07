# scf-tutorial

## Students

Before starting, make sure you're using a **new Incognito window**, and have **credentials provided by your instructor**.

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.png)](https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/EngineerBetter/scf-tutorial&tutorial=tutorial.md)

This course will only work while the EngineerBetter environment is online. If you wish to try Cloud Foundry yourself after the course, please check out the links below.

### Further Reading

* [Cloud Foundry official site](https://www.cloudfoundry.org/)
* [Try Cloud Foundry](https://trycloudfoundry.com/posts/try/index.html)
* [SCF GitHub repo](https://github.com/SUSE/scf)
* [Stratos UI GitHub repo](https://github.com/cloudfoundry-incubator/stratos)
* [SUSE Cloud Application Platform](https://www.suse.com/products/cloud-application-platform/)
* Free online Cloud Foundry ["Zero To Hero" training](http://zero-to-hero.engineerbetter.com/), including instructions on various **free trial accounts**
* [Cloud Native Buildpacks](https://buildpacks.io/)
* [Why continuous delivery on a self-service platform is better for your brain](https://www.youtube.com/watch?v=k9duArRuSjQ)

---

## Development Notes

```terminal
$ fly -t ebci sp -p scf-tutorial -c ci/pipeline.yml -l ci/instances/default.yml
```

* [SCF Installation docs](https://github.com/SUSE/scf/wiki/How-to-Install-SCF#helm-installation)

### Resources Used In Pipeline

* https://github.com/ljfranklin/terraform-resource
* https://github.com/linkyard/concourse-helm-resource
* https://github.com/zlabjp/kubernetes-resource
