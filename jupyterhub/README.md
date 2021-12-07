# INFRAStructure as CODE

## JupyterHub

This deployment will run *out-of-the-box*, but is generally unconfigured. You can run it *as-is* by just using `deploy.bash` script. You can also tear down the deployment using the `uninstall.bash` script.

I generally just wanted something which allowed users to see their username and have their own home directories named accordingly. This allows for connections to other systems (like when using ssh) to be rather simple to perform, but I **do not** update the ownership and use a unique UID/GID for each user since this breaks the current conda/mamba installation (in my opinion). However, here is the list of things that need to be done to generally make this ready for production deployment:

1. Decide if you want to use the single-user lab pod scheduler that's provided by Z2JH. If you are using a cloud provider and will be needing to scale your deployment up or down (add/remove nodes), then you should *enable* the scheduler. It's currently *disabled* in `config.yaml`, and this is because having a fixed-size cluster would be better served by using the default k8s scheduler which spreads user pods out across the nodes.

2. You need to generate two secret hex keys for your deployment. These are in the hub and proxy sections of the `config.yaml`. Use the following command:
```
openssl rand -hex 32
```








3. Decide on an authenticator and use it. I have provided two snippets in `authenticator-openldap.yaml` and `authenticator-azuread.yaml` that work for me. Just edit them with the relevant details and drop them in the location specified in `config.yaml` (it's under the hub configuration section).

4. You may have to think about what storage provisioner you will be using - this is outside the scope of this deployment and, in theory, should work as expected depending on how your k8s cluster is set up. K3S, for example, will just spread out across the cluster with the default local path provisioner. I prefer to use an NFS-based provisioner instead on my hardware (a separate section in INFRASCODE). 

5. If you don't have a k8s cluster which can fully enforce network policy (k3s default cannot for example), then you may want to disable the default network policy for singleuser and *then* use `kubectl -n jupyterhub create -f netpol-block-singleuser-ingress.yaml` (only do this if you need it). If you installed calico or use some other k8s distribution which provides network policy support then this should not be needed.

6. Consider changing the cull-timeout to better suit your deployment (may want this to be shorter when scaling in the cloud). It's currently one week, then single-user pods get shutdown.

7. Drop in you SSL cert and key into the proxy section where shown - or at least put this behind an already configured reverse proxy or load balancer. I like to be a little more careful by configuring them here as well.

8. Choose a notebook image you would like to use. I have provided the default `jupyter/minimal-notebook:latest`, but also a recent image/tag that I use(d) in my classes. Note that my images are quite large, so you might want to actually set this -last- after all other things are working. You can they just run `deploy.bash` again with the new values and the new image will get pulled (might take awhile).

