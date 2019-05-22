# scf-tutorial

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.png)](https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/EngineerBetter/scf-tutorial&tutorial=tutorial.md)

```terminal
$ fly -t ebci sp -p scf-tutorial -c ci/pipeline.yml -l ci/instances/default.yml
```

* [SCF Installation docs](https://github.com/SUSE/scf/wiki/How-to-Install-SCF#helm-installation)

## Resources Used In Pipeline

* https://github.com/ljfranklin/terraform-resource
* https://github.com/linkyard/concourse-helm-resource
* https://github.com/zlabjp/kubernetes-resource
