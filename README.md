# lok-nexus

## Set up Configmaps

The `nexus-credentials` configMap is intended to be created from the console using the following command:

```
kubectl create configmap nexus-credentials --from-literal=user.name=<username> --from-literal=user.password=<password> --from-literal=user.email=<email> --from-literal=user.fname=<first_name> --from-literal=user.lname=<last_name>
```

You have to create user.name, user.password, user.email, user.fname, user.lname there is a quick script in /jobs/ that will do this automatically.


## Launching the pod

1. Create the deployment: `kubectl create -f deployments/nexus.yaml`

2. Create the service: `kubectl create -f services/nexus.yaml`

3. Create the job: `kubectl create -f jobs/nexus-job.yaml`
