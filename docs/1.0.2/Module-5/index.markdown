---
layout: docs
title:  Module 5 - Customizing for input files in binary format (fixed-size structures) 
description:  Customizing-for-input-files-in-binary-format-(fixed-size-structures)
weight:  15
---

# Objectives

In this module, you extend the ITE application that you created while following the instructions of the modules 1-4, with a file reader for binary data files that contain fixed-size structures. 

After completing this module you should be able to:

* Configure the file ingestion to recognize the new type of input data files
* Configure the file reader for your new input data file type
* Implement a file reader for the fixed-size structure binary data

# Prerequisites

You finished at least [module 3](http://ibmstreams.github.io/streamsx.tutorial.teda/docs/1.0.2/Module-3/) of the tutorial, in which you created a scalable Streams application that processes CDRs for SMS and voice calls from CSV files.

# Concepts

Fixed-size structures are a vendor-specific format. A data file contains for example Call Detail Records (CDRs) encoded as fixed-size structures, which means, a number of fields that have fixed lengths each. The following picture shows a fictive data record. 

<img src="/streamsx.tutorial.teda/images/1.0.2/module-05/DataRecord.png" alt="Data Record" style="width: 95%;"/>

A record as a whole and the included data fields can contain fill bytes. An example for a data field with fill bytes is a digit field for telephone numbers. The maximum length of a telephone number defines the length of the field. In case the number is shorter, the rest of the field contains fill bytes or fill digits. Typically a file contains more than one record. Nevertheless, you need a description issued by the creator of the data files to understand and decode these files.

At the end of this module, your application can process CDRs for SMS and voice calls, which are stored in fixed-size structure binary data files.

Terms used in this tutorial:

* vendor:	The manufacturer of  the network elements that generate the data files.
* StructureParse:	The com.ibm.streams.teda.parser.binary::StructureParse operator is the parser operator that decodes the fixed-size structure binary data. It is a part of the TEDA toolkit. For getting familiar with the operator, read the description in the IBM Knowledge Center under [Reference > Toolkits > SPL standard and specialized toolkits > com.ibm.streams.teda > com.ibm.streams.teda.parser.binary > StructureParse] (https://www.ibm.com/support/knowledgecenter/SSCRJU_4.1.1/com.ibm.streams.toolkits.doc/spldoc/dita/tk$com.ibm.streams.teda/op$com.ibm.streams.teda.parser.binary$StructureParse.html).

## Customization Points

When customizing the ITE application, it is recommended to follow the functional flow within the application structure.

The following figure and table show the points that you need to customize in the ITE application during this module or that influence the customization like the different formats and stream schemas. Other parts don't need to be customized because it is not necessary for this module.

<img src="/streamsx.tutorial.teda/images/1.0.2/module-05/Architecture.png" alt="The customization points"/>

|    Number    |    Functional Block                             |    What needs to be customized?                                                                                                                |
|--------------|-------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
|    1         |    FileTypeValidator                            |    Custom code is necessary to derive the type of file format from the file name, the type is a custom string and needed later in the framework to route the file to the correct FileReader|
|    2         |    FileReader                                   |    Different FileReaders are necessary: one containing an fixed-size structure binary parser    |

## Configuration

While creating an ITE or - in later modules - a Lookup Manager Application project a `config/config.cfg` configuration file is created that contains the compile-time parameters or submission-time parameter defaults for the application. Typically, you open the config.cfg file once and keep it open during the configuration and customization tasks because you change it during various tasks. Remember to save your changes before building the application.

If config.cfg is mentioned in a task description, this file is meant.

The configuration file contains the description of all non-deprecated parameters as well as settings that are specific to the choices made during the project creation. As an application developer, you decide which parameters are needed in the project. Lastly, it contains settings that are mandatory and need to be changed to fit to the project needs. For getting familiar with all configuration parameters, read the parameter reference in the IBM Knowledge Center under [Reference > Toolkits > SPL standard and specialized toolkits >com.ibm.streams.teda > Parameter reference](http://www.ibm.com/support/knowledgecenter/SSCRJU_4.1.1/com.ibm.streams.toolkits.doc/spldoc/dita/tk$com.ibm.streams.teda/tk$com.ibm.streams.teda$167.html).

Typically, you add parameter assignments below their descriptions.

# Tasks

The configuration and customization consists of the following tasks:

1. Configure the frameworks ingestion part to detect the new type of input data files.
2. Configure the framework to connect the new file type to the appropriate file reader.
3. Configure the framework to use a new file reader for your new input data file type.
4. Provide a structure definition document for the vendor-specific data structures, and a mapping document to map the vendor-specific data structure fields to SPL attributes. 
5. Create a file reader composite for the fixed-size structure binary data

## Customizing the file ingestion

According to the requirements, the file names have the following naming schema:
`CDR_RGN<MSC_ID>_<YYYYMMDDhhmmss>.bin`.

You already configured the file name pattern for CSV files. Find the ite.ingest.directoryScan.processFilePattern parameter in the config.cfg and add the pattern for fixed-size structure binary data files.  

    ite.ingest.directoryScan.processFilePattern=.*_([0-9]{14})\.csv$|.*_([0-9]{14})\.bin$

## Customizing different file types

Every format (file type) requires another reader, so you specify the `ite.ingest.customFileTypeValidator` parameter to enable the support for multiple readers and file type verification. You customize the demoapp.fileingestion.custom/FileTypeValidator composite operator, which is mentioned in the detailed parameter description. During this customization, you assign the uppercase file name extension to the fileType SPL attribute. That means, the .csv extension results in the CSV fileType value and .bin in BIN.

Add the following line below the description of the `ite.ingest.customFileTypeValidator` parameter in the `config.cfg` file.

    ite.ingest.customFileTypeValidator=on

The demoapp.fileingestion.custom/FileTypeValidator is responsible to determine a file type. This determination can often be done using the file names or their extensions. In this case, you map the extensions to their uppercase counterpart. Since the file name patterns that are specified with the ite.ingest.directoryScan.processFilePattern parameter already ensure that each filename has a valid extension, you do not need to send tuples to the output port for invalid file names.

Open **teda.demoapp/Resources/demoapp.fileingestion.custom/FileTypeValidator.spl** and replace the operator implementation with the following code.

    public composite FileTypeValidator
    (
    input
        stream<ProcessFileInfo> FilesIn;
    output
        stream<ProcessFileInfo> FileOut,
        stream<ProcessFileInfo> InvalidOut
    )
    {
    graph
        (
            stream<ProcessFileInfo> FileOut;
            stream<ProcessFileInfo> InvalidOut
        ) as FileTypePrepare = Custom(FilesIn as FileIn)
        {
            logic
            onTuple FileIn:
            {
                // The file name pattern that is specified with the
                // ite.ingest.directoryScan.processFilePattern parameter,
                // ensures that each incoming file name has an extension,
                // which is either .asn, .csv, or .bin.
                // The extension is used to build the value for the
                // fileType attribute, which can be: ASN, CSV, or BIN.
                FileIn.fileType = upper(substring(FileIn.filenameOnly, length(FileIn.filenameOnly) - 3, 3));
                submit(FileIn, FileOut);
            }
            onPunct FileIn:
            {
                if (currentPunct() == Sys.WindowMarker) submit(Sys.WindowMarker, FileOut);
            }
        }
    }

## Configuring the file reader

You create a custom file reader to read your fixed-size structure binary data input files. Your custom file reader is a built-in composite operator. Add the relation between the file type identifier and the reader composite operator to the `ite.ingest.reader.parserList` parameter.

    ite.ingest.reader.parserList=CSV|FileReaderCustomCSV,BIN|FileReaderCustomBIN

## Customizing the binary parser

The StructureParse operator decodes the fixed-size structure binary data and submits the data as SPL tuples. Therefore, the operator requires the description of the layout of the fixed-size structures and a mapping between input data field and SPL tuple attribute.  

The structure definition document (for example `structure.xml`) describes the layout, and the mapping definition document (for example `mapping.xml`) describes the data field mapping. The StructureParse operator expects both documents in the application’s `etc` directory. You create these files as a next step. The tuples that the parser produces have the SPL type ReaderRecordType, which is the common CDR schema.

### The structure definition document

To understand and decode the data files, you need a layout description. You get this description from the vendor. Based on that description you develop an XML equivalent that the StructureParse operator requires. 

The structure definition document is an XML document that specifies the fixed-size data structures that can occur in the binary data stream and that the StructureParse operator parses. This document follows a specific format and can be composed of mandatory and optional sections.

The first line in that document specifies the encoding format of the file. The second line, which starts with the <structures> XML element, specifies the schema location and other settings that are required for the XSD-driven validation.

    <structures xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xsi:schemaLocation="http://www.ibm.com/software/data/infosphere/streams/parser StructurePars-erStructure.xsd"
                    xmlns="http://www.ibm.com/software/data/infosphere/streams/parser">


In the current sample project, you have data records that can contain two different fixed-size structures. The content of the records is the same as you already processed in your CSV parser but encoded as fixed-size structures now. 

The first element of each structure determines the structure type. One of the types in your example is the "voiceRecord". 

    <structure name="voiceRecord">
        <!-- Condition for voice record is fieldRecordType equal 1 -->
        <condition>
            <cmp op="equal">
                <field name="fieldRecordType"/>
                <value>1</value>
            </cmp>
        </condition>

Each single data field within the structure has a name, a length, and a data type. You specify the name and the type in the document. For rstring and blob types, size information must be specified. The order of the field definitions must be the same as they occur in the input data stream. 

    <field name="fieldRecordType" type="uint8"/>                        <!-- 01   1 byte -->

For a detailed description, refer to [Reference>Toolkits>SPL standard and specialized toolkits>com.ibm.streams.teda>com.ibm.streams.teda.parser.binary>StructureParse>Structure Definition Document](https://www.ibm.com/support/knowledgecenter/SSCRJU_4.1.1/com.ibm.streams.toolkits.doc/spldoc/dita/tk$com.ibm.streams.teda/op$com.ibm.streams.teda.parser.binary$StructureParse$1.html).

Use the Streams Studio's Project Explorer to create the `structure.xml` file in the project’s `etc` folder. 

<img src="/streamsx.tutorial.teda/images/1.0.2/module-05/StructureXML.png" alt="The structure definition document" style="width: 95%;"/>

Add the following content to the file.

[structure.xml](http://ibmstreams.github.io/streamsx.tutorial.teda/docs/1.0.2/Module-5/structure.xml)

### The mapping definition document

The mapping document is an XML document that defines the mapping between the fields of the binary structure and the SPL tuple attributes for the StructureParse operator.

The first line of a mapping definition document specifies the encoding of the file, with the <mapping> XML tag as the XML root element. The schema location and other settings are required to ensure that the XSD-driven validation is executed.

    <mapping xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xsi:schemaLocation="http://www.ibm.com/software/data/infosphere/streams/parser StructureParserMapping.xsd"
                    xmlns="http://www.ibm.com/software/data/infosphere/streams/parser">

The following mapping principle is used:

For each of the output port attributes, specify the structure and field that feeds the attribute. Structures that are detected in the binary data stream but that do not have specified mapping information do not generate output tuples.

If you specified more than one structure in the `structure.xml` file, you can also have multiple source specifications as shown in the following example. The structure and the field in `mapping.xml` is identified by the name as defined in `structure.xml`.

In the tutorial, the binary file can contain two different structures, a voice CDR (structure name is **voiceRecord**) and an SMS CDR (structure name is **smsRecord**). The SPL output schema contains the attribute cdrRecordType. Both binary structures (voiceRecord and smsRecord) contain an element (fieldRecordType) to feed the SPL tuple attribute. 

    <attribute name="cdrRecordType">
        <from structure="voiceRecord" field="fieldRecordType"/>
        <from structure="smsRecord" field="fieldRecordType"/>
    </attribute>

Use the Streams Studio’s Project Explorer to create the file mapping.xml in the project’s etc folder.

<img src="/streamsx.tutorial.teda/images/1.0.2/module-05/MappingXML.png" alt="The mapping definition document" style="width: 90%;"/>

Replace the content of the XML file with the following content.

[mapping.xml](http://ibmstreams.github.io/streamsx.tutorial.teda/docs/1.0.2/Module-5/mapping.xml)

A detailed description of the mapping file of the fixed-size structure binary data parser is contained in the toolkit’s reference in the IBM Knowledge Center under [Reference>Toolkits>Specialized toolkits>com.ibm.streams.teda 1.0.1>com.ibm.streams.teda.parser.binary>StructureParse>Mapping Definition Document>Mapping Definition](https://www.ibm.com/support/knowledgecenter/SSCRJU_4.1.1/com.ibm.streams.toolkits.doc/spldoc/dita/tk$com.ibm.streams.teda/op$com.ibm.streams.teda.parser.binary$StructureParse$12.html).

## Creating the custom binary-encoded data file reader composite

Analog to the reader for CSV files, you copy the **Resources/demoapp.chainprocessor.reader.custom/FileReaderCustom.spl** file to **FileReaderCustomBIN.spl** and rename the contained composite from FileReaderCustom to FileReaderCustomBIN. This composite must be customized to use the built-in binary structure reader, which is demoapp.chainprocessor.reader::FileReaderStructure.

The file contains the composite with the instantiation of a file reader, which follows the frameworks reader interfaces. The framework already contains three configurable file readers: FileReaderCSV, FileReaderASN1, and **FileReaderStructure**. You select the FileReaderStructure file reader and set its parameter values. Two of them are the previously created `structure.xml` and `mapping.xml`. 

The third mandatory parameter is the **parserRecordOutputType**. Similar to the FileReaderCustomCSV, you parameterize this parser operator to generate just the common CDR format ReaderRecordType, which must be the same as in FileReaderCustomCSV.

    public composite FileReaderCustomBIN (
        input 
            stream<TypesCommon.FileIngestSchema> FileIn;
        output
            stream<TypesCommon.ReaderOutStreamType> ReaderRec,
            stream<TypesCommon.ParserStatisticsStream> ReaderStat
    ) {
        param
            expression<rstring> $groupId;
            expression<rstring> $chainId;

        graph

            (
            stream<TypesCommon.ReaderOutStreamType> ReaderRec;
            stream<TypesCommon.ParserStatisticsStream> ReaderStat
            ) = 
                // ------------------------------------------------
                // custom code begin
                // ------------------------------------------------
                // Select the file reader operator
                // a) FileReaderCSV or
                // b) FileReaderASN1 or
                // c) FileReaderStructure or
                // d) Create your own parsers based on CustomParserTemplate
                FileReaderStructure
                // ------------------------------------------------
                // custom code end
                // ------------------------------------------------
                (FileIn as IN) {
                param
                    groupId : $groupId;
                    chainId : $chainId;
                    // ------------------------------------------------
                    // custom code begin
                    // ------------------------------------------------
                    // enable parameters below to customize the Parsers

                    /**
                     * FileReaderCSV/FileReaderStructure/FileReaderASN1: operator record stream output type.
                     */
                    parserRecordOutputType: ReaderRecordType; 
                    /**
                     * FileReaderStructure: The structure document parameter
                     */
                    structureDocument: "etc/structure.xml";
                    /**
                     * FileReaderStructure: The mapping document parameter
                     */
                    mappingDocument: "etc/mapping.xml";
                    // ------------------------------------------------
                    // custom code end
                    // ------------------------------------------------
            }
    }


## Building and starting the ITE application

To build the ITE application, right-click on the **teda.demoapp** project in the Project Explorer, and select **Build Project** from the context menu. Then, start the Monitoring GUI. Remember that you have installed the Monitoring GUI in the `MonitoringGUI` directory directly under your home directory. Open a terminal window and run the following commands:

    cd $HOME/MonitoringGUI
    ./teda-monitor.sh

Now start the ITE application. Go to the Project Explorer.

* Expand the namespace **demoapp**.
* Right-click on **ITEMain [External builder]**.
* Select **Launch…** from the menu. The **Edit Configuration** dialog window opens.
* You can keep all submission time values. Click **Continue**.
* In the **Save Changes** dialog, click **No**.

The application is submitted to your Streams instance.

Shortly after that, the submitted application appears in the Monitoring GUI, and its status goes to healthy after some seconds. If you select the application in the Monitoring GUI, you see that all metrics have the value 0.

<img src="/streamsx.tutorial.teda/images/1.0.2/module-05/MonitoringGUI.png" alt="Monitoring GUI after job submission"/>

## Moving sample data files to the application's input directory to process the data

Since you did not configure directories for input and output, the default directories are used for the file interface. All these directories are subdirectories of the data directory of your SPL application. The input directory is WORKSPACE/teda.demoapp/data/in.

In module 3 of the tutorial, you already copied the *.bin data input files to the directory WORKSPACE/teda.demoapp/data/in/archive.

Now move them into the in directory to get them detected and processed. You must always move the files into the input directory to make the files appear atomically within the directory that is being scanned. This way, you avoid that a file is processed while it is still being copied.

Open a terminal window and run the following commands to move the files into the `input` directory of the ITE application:

    cd WORKSPACE/teda.demoapp/data/in
    mv -v archive/*.bin .

The files are processed within 5 seconds. You can press F5 in the Monitoring GUI to refresh the metrics immediately, not waiting for the next refresh cycle.

<img src="/streamsx.tutorial.teda/images/1.0.2/module-05/MonitoringGUI_ProcessedRecords.png" alt="Monitoring GUI after file processing"/>

You can see, that the application processed two files with a total of 20000 tuples.

Refresh the **Resources** tree of the ITE project in the Project Explorer to see the newly created files.

**What happened?**

The ITE application processed the input files from the `in` directory and moved them back to `in/archive`. Note, that the `archive` directory contains also other files, which you copied before and which are ignored for now. The ITE application created also the files in the `out/load` directory. These files are the output files.

<img src="/streamsx.tutorial.teda/images/1.0.2/module-05/FileExplorer_Outputs.png" alt="Output files"/>

## Shutting down the ITE application gracefully and cleaning up

Shutdown and clean up the ITE application as described in [Module 2: Shutting down the ITE application gracefully](http://ibmstreams.github.io/streamsx.tutorial.teda/docs/1.0.2/Module-2/#shutting-down-the-ite-application-gracefully).

The quick summary is:

* Use the teda-shutdown-job command line tool to gracefully shutdown the ITE application. In progress files are finished before the application is cancelled.

* Remove the checkpoint, control, and out directories that are sub directories of the data directory. Either you remove them using Streams Studio or the rm command. This step is required to get rid of the file name history that is used for the file duplicate detection, and to start the next time from scratch.

* Optionally, you can close the Monitoring GUI.

# Next Steps

As next step, you can optionally add support for processing input files in [ASN.1](http://ibmstreams.github.io/streamsx.tutorial.teda/docs/1.0.2/Module-6/) format. You can also skip this step and continue with adding [lookups](http://ibmstreams.github.io/streamsx.tutorial.teda/docs/1.0.2/Module-7/) to the application.
