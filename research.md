---
title: "HiPCastor - Research"
layout: textlay
excerpt: "HiPCastor -- Research"
sitemap: false
permalink: /research/
---

# Research

Our overarching goal is to research and develop new techniques applied to a diverse spectrum of computer systems (including edge, cloud, and high-performance computing) and across layers of abstraction (including computer architecture, operating systems, virtualization, middleware, and applications). 

Here are some themes and techniques that we currently work on:

**Function-as-a-Service, serverless workflows.** Modern Function-as-a-Service (FaaS) cloud platforms offer great potential for supporting event-driven scientific workflows. Nonetheless, there remain barriers to adoption by the scientific community in domains such as environmental sciences, where R is the focal language used for the development of applications and where users are typically not well-versed with FaaS APIs. We have designed and implemented [FaaSr](https://faasr.io), a novel open-source middleware that supports event-driven scientific workflows in R. A key novelty in FaaSr is the ability to deploy workflows across FaaS providers without the need for any managed servers for coordination.


**Software-defined virtual networks for edge-to-cloud computing.** The advent of virtualization and cloud computing has fundamentally changed how distributed applications and services are deployed and managed. With the proliferation of IoT and mobile devices, virtualized systems akin to those offered by cloud providers are increasingly needed geographically near the network’s edge to perform processing tasks in proximity to the data sources and sinks. While, within cloud data centers, nodes can communicate without the presence of Network Address Translators (NATs), edge computing applications require devices to communicate across different private networks and must deal with NAT traversal to enable edge-to-edge communication. We have designed and implemented [EdgeVPN](https://edgevpn.io), a novel technique that enables virtual private Ethernet networks that span edge and cloud resources – including those constrained by NAT and firewall middleboxes. EdgeVPN builds upon a scalable structured peer-to-peer overlay, and is novel in how it integrates overlay tunnels with Software Defined Networking (SDN) software switches to create a virtual network with dynamic membership – supporting unmodified Ethernet/IP stacks to facilitate the deployment of edge applications. 

