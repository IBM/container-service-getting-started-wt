# Highly Available Deployments With the IBM Bluemix Containers Service

This section is under construction. An outline of what is to come is show below. 

# Outline
Goal: Understand how to deploy a highly availible application. It's easier than many think, but can be expensive if deploying across multiple AZs. The example I would like to do shows how to deploy an application across three worker nodes in the same AZ (basic level of high availibility, to explore the concepts) it will also include anti affinity so the pod replicas of the deployment spread across worker nodes, thus giving basic high availibility to the application.


1. Introduction

  ..* Background and explanation of high-availibility https://console.bluemix.net/docs/containers/cs_planning.html#cs_planning
  ..* graphic detailing high-availibility at scale

2. Body
  ..* Application demo showing multiple worker nodes with one deployment (basic level of high availibility)
  ..* Affinity and Anti-affinity explanation https://console.bluemix.net/docs/containers/cs_planning.html#cs_planning
  ..* wasliberty anit-affinity example for paid clusters
  
3. Conclusion
  ..* Review of highly availible clusters 
  ..* Review and affinty
