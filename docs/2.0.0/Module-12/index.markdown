<!--(
---
layout: docs
title:  Module 12 - Export streams
description:  Export streams of the ITE application
weight:  22
---
)-->
# Objectives

In this module, you extend the ITE application that you created in the modules 1-8.

At the end of this module, your application export streams, which can be imported by another application.

After completing this module you should be able to:

* Configure the export streams of the ITE application
* Connect another application to the exported streams of the ITE application

# Prerequisites

You finished at least [module 8](http://ibmstreams.github.io/streamsx.tutorial.teda/docs/2.0.0/Module-8/) of the tutorial, in which you added the record deduplication.

# Concepts

Imagine, you have the project requirement to plug-in another application to the ITE application in order to apply new business rules. The performance of the external application must not affect the performance of the ITE application. If the importing application is too slow, then the ITE application drops the tuples at export.

## Customization Points

The following figure and table show the points that you need to customize in the ITE application during this module or that influence the customization like the different formats and stream schemes. Other parts don't need to be customized because it is not necessary for this module.

<img src="/streamsx.tutorial.teda/images/2.0.0/module-12/Architecture.png" alt="The customization points"/>

|    Number    |    Functional Block                     |    What needs to be customized?                                                                                                                |
|--------------|-----------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
|    1         |    Dedup                                |    Configure the context output stream to be exported.|


## Configuration

You do all configuration settings in the same manner as you did it in the previous modules. Expand **teda.demoapp/Resources/config** in the Streams Studio's Project Explorer and open the **config.cfg** file. In all later steps, this opened file is referenced when config.cfg is mentioned.

# Tasks

The configuration and customization consists of the following tasks:

1. Configure the exported streams
2. Build the application importing the tuples from ITE application

## Configure the exported streams

You specify the export streams `dedup` to select the output stream of the BloomFilter operator to be exported in each group. The export operator provides the **demoapp.streams::TypesCommon.TransformerOutType** streams schema. You configure the export stream in the `config.cfg` file of the teda.demoapp project:

    ite.export.streams=dedup
    
The ITE application framework creates an exporter with **ite="demoapp.context_output_Dedup"** property and the `dropConnection` congestion policy to prevent back-pressure of the slow importer application. 

You use the property to create the application that imports the output of ITE `DedupCore` composite. The 

This is an example of the generated code in the ITE application framework:
    
    () as Exporter = Export(OutDedupedStream) {
        param
    		properties: { ite="demoapp.context_output_Dedup" };
    		allowFilter: true;
    		congestionPolicy: dropConnection; // prevents back-pressure from slow importer 
	}

You find the other supported **ite.export.streams** configuration settings in the IBM Knowledge Center under [Reference>Toolkits>SPL standard and specialized toolkits>com.ibm.streams.teda 2.0.0> Parameter reference](http://www.ibm.com/support/knowledgecenter/SSCRJU_4.2.0/com.ibm.streams.toolkits.doc/spldoc/dita/tk$com.ibm.streams.teda/tk$com.ibm.streams.teda$184.html)

## Build the application importing the tuples from ITE application

Your application, that imports the tuples from ITE application, it must subscribe the **ite=="demoapp.context_output_Dedup"** property.
You must use the same streams schema specification, that you obtain with **use demoapp.streams::*;'** inclusion in the spl code of your importer application.

The example of the Import operator shows the specified settings:

	stream<TypesCommon.TransformerOutType> In = Import() {
		param subscription : ite=="demoapp.context_output_Dedup";
	}


## Building and starting the ITE application

After restructuring the project, it is best practice to clean the project before starting a new build process. To do so, select on the Streams Studio main menu **Project > Clean…** and select the **teda.demoapp** project. Press OK.

You need to do the same steps as in [Module 7: Starting the applications](http://ibmstreams.github.io/streamsx.tutorial.teda/docs/2.0.0/Module-7/#starting-the-applications) to launch the applications and to process the input files.

***Note:***

*If your Lookup Manager is still running and the lookup data was loaded already before, then you can launch the ITE application and trigger the* **restart** *command in the* **control** *directory. In this case the* **init** *command does not need to be processed again in order to synchronize the Lookup Manager and ITE applications.*

*Change into `<WORKSPACE>/teda.lookupmgr/data/control` directory and create the `appl.ctl.cmd` file with content of the
desired command, in our case: `restart,demoapp`.*

    cd <WORKSPACE>/teda.lookupmgr/data/control
    echo 'restart,demoapp' > appl.ctl.cmd

*ITE application and Lookup Manager application will establish a control sequence where at the end both applications are in RUN state using the data already available, without reload.*

## Discussing the results



# Next steps

This module covers the basics of writing applications with the Telecommunications Event Data Analytics (TEDA) application framework. To learn more about the details, refer to the knowledge center.

We continue to improve this tutorial.
If you have any feedback, please click the Feedback button at the top and let us know what you think!
