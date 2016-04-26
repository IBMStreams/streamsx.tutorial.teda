---
layout: docs
title:  Telecommunications Event Data Analytics (TEDA) toolkit
description:  Introduction to IBM Streams TEDA Toolkit
---

# Introduction

Welcome to the streamsx.tutorial.teda documenation, which is related to the Telecommunications Event Data Analytics [com.ibm.streams.teda](http://www-01.ibm.com/support/knowledgecenter/SSCRJU_4.1.1/com.ibm.streams.toolkits.doc/spldoc/dita/tk$com.ibm.streams.teda/tk$com.ibm.streams.teda.html) toolkit!

The Telecommunications Event Data Analytics toolkit provides a set of generic operators that are used in telecommunications applications, and it also provides an application framework that enables you to set up mediation applications. These applications that are capable to process mass data and run near real-time analytics, are based on code templates and support customization, configurable parallel processing, graceful application shutdown, and reliable file processing.

The goal of this tutorial project is to introduce beginners into the application framework and its capabilities, to provide background information and links to reference documentation. While following the tutorial modules, you will incrementally create a complex mediation application, and learn how to setup, configure, customize, run, and monitor this application. The result of this tutorial is the mediation application that is provided with and can be imported from the com.ibm.streams.teda toolkit.

# Tutorials
{% include nav.html context="/docs/"%}

The tutorial uses a fictive customer project. The use case is hypothetical, but similar requirements are seen in real projects. It is a telecommunication company with a number of MSCs (Mobile Switching Center) from two vendors in its network. The MSCs generate CDRs (Call Detail Record) for several events. The customer wants to process voice call records and SMS (Short Message Service) records. The records must be transformed to a common format, which is written into a CDR repository.

If you are interested in an overview, please read the following streamsDev articles first:

* [An Introduction to Streaming Telecommunications Event Data Analytics (TEDA)](https://developer.ibm.com/streamsdev/docs/introduction-streaming-telecommunications-event-data-analytics-teda/) from 2016-01-04
* [Getting Started with Streaming Telecommunications Event Data Analytics (TEDA)](https://developer.ibm.com/streamsdev/docs/getting-started-streaming-telecommunications-event-data-analytics-teda/) from 2016-02-04

