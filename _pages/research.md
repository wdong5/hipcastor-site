---
title: "HiPCastor - Research"
layout: textlay
excerpt: "HiPCastor -- Research"
sitemap: true
permalink: /research/
---

Our overarching goal is to research and develop new techniques applied to
a diverse spectrum of computer systems (including edge, cloud and
high-performance computing) and across layers of abstraction (including
computer architecture, operating systems, virtualization, middleware, software engineering, and
applications).

Here are some areas that we currently work in:

### Serverless Workflows (FaaS)
<div class="hpc-card">
**Function-as-a-Service, serverless workflows.** Modern Function-as-a-Service
(FaaS) cloud platforms offer great potential for supporting event-driven
scientific workflows. Nonetheless, there remain barriers to adoption by the
scientific community in domains such as environmental sciences, where R is the
focal language used for the development of applications and where users are
typically not well-versed with FaaS APIs. We have designed and implemented
[FaaSr](https://faasr.io), a novel open-source middleware that supports
event-driven scientific workflows in R. A key novelty in FaaSr is the ability
to deploy workflows across FaaS providers without the need for any managed
servers for coordination. We have also explored using lightweight per-function
virtual machines ([virtines](https://github.com/virtines/wasp)) to enable more strongly isolated FaaS platforms.
</div>

### High-performance Memory Systems
<div class="hpc-card">
Modern memory systems involve designs aimed at surmounting the "memory wall,"
where memory capacity and bandwidth can limit workload performance. We are
investigating new system software support for disaggregated memory, where
a workload's memory is transparently expanded across nodes in a cluster. In
particular, we developed a new compiler and runtime system for high-performance
far memory called [TrackFM](https://dl.acm.org/doi/10.1145/3617232.3624856). To
address memory bandwidth limitations, near-data processing architectures move
compute nearer to memory, for example with processing units integrated near
DRAM banks. We are investigating new software and hardware abstractions for
next-generation processing-in-memory (PIM) architectures.
</div>

### System Software for HPC
<div class="hpc-card">
We are interested in ground-up redesigns of the
hardware/software layer for high-performance computing. In the past, we have developed new
[operating systems](https://users.cs.northwestern.edu/~pdinda/Papers/sc21.pdf), [virtual machine monitors](https://github.com/virtines/wasp),
[languages](https://doi.org/10.1145/3453483.3460969), [compilers](https://dl.acm.org/doi/10.1145/3617232.3624856), and [hardware designs](https://ieeexplore.ieee.org/document/8842897) for HPC.
</div>

### Software-defined virtual networks for edge-to-cloud computing
<div class="hpc-card">
While within cloud data centers, nodes can communicate without the presence of
Network Address Translators (NATs), edge computing applications require devices
to communicate across different private networks and must deal with NAT
traversal to enable edge-to-edge communication. We have designed and
implemented [EdgeVPN](https://edgevpn.io), a technique that enables
virtual private Ethernet networks that span edge and cloud resources
– including those constrained by NAT and firewall middleboxes. EdgeVPN builds
upon a scalable structured peer-to-peer overlay, and
integrates overlay tunnels with Software Defined Networking (SDN) software
switches to create a virtual network with dynamic membership – supporting
unmodified Ethernet/IP stacks to facilitate the deployment of edge
applications.
</div>

## Software
<div class="hpc-card">
- [EdgeVPN](https://github.com/edgevpnio) - VPN at the edge
- [FaaSr](https://github.com/FaaSr) - Function-as-a-Service for R
- [Shipyard](https://github.com/xyang76/shipyard) - Load balanced, sharded consensus
- [TrackFM compiler](https://github.com/compiler-disagg/TrackFM) - automated far memory for legacy apps
- [Wasp](https://github.com/virtines/wasp) - a microhypervisor for function-granularity virtualization
</div>

## Sponsors
<div class="hpc-card" markdown="0">
  <div class="hpc-sponsor-logos">
    <a href="https://www.nsf.gov" target="_blank" rel="noopener">
      <img src="{{ site.url }}{{ site.baseurl }}/images/logopic/nsf.png" alt="National Science Foundation" class="hpc-sponsor-logo">
    </a>
    <a href="https://www.intel.com" target="_blank" rel="noopener">
      <img src="{{ site.url }}{{ site.baseurl }}/images/logopic/intel-logo.svg" alt="Intel" class="hpc-sponsor-logo">
    </a>
    <a href="https://www.samsung.com" target="_blank" rel="noopener">
      <img src="{{ site.url }}{{ site.baseurl }}/images/logopic/samsung.png" alt="Samsung" class="hpc-sponsor-logo">
    </a>
  </div>
</div>
