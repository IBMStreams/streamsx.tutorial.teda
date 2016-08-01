---
layout: docs
title: Tutorial com.ibm.streams.teda 2.0.0 
description:  Tutorial com.ibm.streams.teda 2.0.0
weight: 11
---

{% include nav.html context="/docs/2.0.0/"%}

The goal of this tutorial project is to introduce beginners into the application framework and its capabilities, to provide background information and links to reference documentation. While following the tutorial modules, you will incrementally create a complex mediation application, and learn how to setup, configure, customize, run, and monitor this application. The result of this tutorial is the mediation application that is provided with and can be imported from the com.ibm.streams.teda toolkit.

The tutorial uses a fictive customer project. The use case is hypothetical, but similar requirements are seen in real projects. It is a telecommunication company with a number of MSCs (Mobile Switching Center) from two vendors in its network. The MSCs generate CDRs (Call Detail Record) for several events. The customer wants to process voice call records and SMS (Short Message Service) records. The records must be transformed to a common format, which is written into a CDR repository.
