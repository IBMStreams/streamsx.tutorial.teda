---
layout: docs
title:  TEDA Toolkit
description:  Introduction to IBM Streams TEDA Toolkit
weight: 70
---

Welcome to the streamsx.tutorial.teda wiki, which is related to the Telecommunications Event Data Analytics [com.ibm.streams.teda](http://www-01.ibm.com/support/knowledgecenter/SSCRJU_4.1.1/com.ibm.streams.toolkits.doc/spldoc/dita/tk$com.ibm.streams.teda/tk$com.ibm.streams.teda.html) toolkit!

The Telecommunications Event Data Analytics toolkit provides a set of generic operators that are used in telecommunications applications, and it also provides an application framework that enables you to set up mediation applications. These applications that are capable to process mass data and run near real-time analytics, are based on code templates and support customization, configurable parallel processing, graceful application shutdown, and reliable file processing.

The goal of this tutorial project is to introduce beginners into the application framework and its capabilities, to provide background information and links to reference documentation. While following the tutorial modules, you will incrementally create a complex mediation application, and learn how to setup, configure, customize, run, and monitor this application. The result of this tutorial is the mediation application that is provided with and can be imported from the com.ibm.streams.teda toolkit.

The tutorial is released for Streams version 4.1.1.

The tutorial uses a fictive customer project. The use case is hypothetical, but similar requirements are seen in real projects. It is a telecommunication company with a number of MSCs (Mobile Switching Center) from two vendors in its network. The MSCs generate CDRs (Call Detail Record) for several events. The customer wants to process voice call records and SMS (Short Message Service) records. The records must be transformed to a common format, which is written into a CDR repository.

If you are interested in an overview, please read the following streamsDev articles first:

* [An Introduction to Streaming Telecommunications Event Data Analytics (TEDA)](https://developer.ibm.com/streamsdev/docs/introduction-streaming-telecommunications-event-data-analytics-teda/) from 2016-01-04
* [Getting Started with Streaming Telecommunications Event Data Analytics (TEDA)](https://developer.ibm.com/streamsdev/docs/getting-started-streaming-telecommunications-event-data-analytics-teda/) from 2016-02-04

Please perform the tasks that are described in the following tutorial modules:

* [Module 1: Preparing your development system]( https://github.com/IBMStreams/streamsx.tutorial.teda/wiki/Module-1:-Preparing-your-development-system )
* [Module 2: Creating, running, and monitoring the basic mediation application](https://github.com/IBMStreams/streamsx.tutorial.teda/wiki/Module-2:-Creating,-running,-and-monitoring-the-basic-mediation-application)
* [Module 3: Customizing for input files in CSV format]( https://github.com/IBMStreams/streamsx.tutorial.teda/wiki/Module-3:-Customizing-for-input-files-in-CSV-format)
* [Module 4: Customizing the business logic (first steps)]( https://github.com/IBMStreams/streamsx.tutorial.teda/wiki/Module-4:-Customizing-the-business-logic-(first-steps))
* Module 5: Customizing for input files in binary format (fixed-size structures) [under construction]
* Module 6: Customizing for input files in binary format (ASN.1) [under construction]
* Module 7: [under construction]
* Module 8: [under construction]
* Module 9: [under construction]

Hint: The screenshots in the modules might show paths to an older Streams version, for example, version 4.1.0.0. The screenshots will be updated only if there is an important change or information that needs to be explained. Apply the correct paths to the Streams versions, for which this tutorial is released.