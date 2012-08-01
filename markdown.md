% Dzidorius Martinaitis
% Data mining and R language
% \today

Cyber security
===========================
- Misuse/Signature Detection
- Anomaly Detection
:   Supervised learning
:   Unsupervised Learning
- Hybrid Detection
- Scan Detection
- Profiling Modules

Supervised learning 
==========================
* Rule based
:   SNORT

Unsupervised learning
==========================
* Clustering based: 
:   distance based (K-means, random Forest and etc.)
:   density based

* Rule based
:   based on user profiles

Feature selection
=========================
* Basic features:
:   source IP address
:   source port
:   destination IP address
:   destination port
:   protocol
:   flags
:   number of bytes
:   number of packets 
* Derived features:
:   time-window
:   connection window based features


Scan Detection
============================
* vertical scan - a range of ports on a single host
* horizontal scan - port running in any host among networks
* coordinated scan - portion of ports among a range of IP 

Profiling Modules
===========================

