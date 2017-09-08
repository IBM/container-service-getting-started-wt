# Highly Available Deployments With the IBM Bluemix Containers Service

This section is under construction. An outline of what is to come is show below. 

# Outline
Goal: Understand how to deploy a highly availible application. It's easier than many think, but can be expensive if deploying across multiple AZs. The example I would like to do shows how to deploy an application across three worker nodes in the same AZ (basic level of high availibility, to explore the concepts) it will also include anti affinity so the pod replicas of the deployment spread across worker nodes, thus giving basic high availibility to the application.


1. Introduction
  a. Background and explanation of high-availibility https://console.bluemix.net/docs/containers/cs_planning.html#cs_planning
  b. graphic detailing high-availibility at scale

2. Body
  a. Application demo showing multiple worker nodes with one deployment (basic level of high availibility)
  b. Affinity and Anti-affinity explanation https://console.bluemix.net/docs/containers/cs_planning.html#cs_planning
  c. wasliberty anit-affinity example for paid clusters
  
3. Conclusion
  a. Review of highly availible clusters 
  b. Review and affinty
