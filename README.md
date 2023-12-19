# Curso Data Engineering

This repository represents the development of a data transformation and modeling project (based on ELT) for the Data Engineering course at the company Cívica.

## TABLE OF CONTENTS 

1. [Technologies](#technologies)
2. [Project Info](#project-info)
3. [Process](#process)
4. [Functionalities and Testings](#functionalities-and-testings)
   
***

# Technologies

Firstly, the working tools used for ELT were: Fivetran (data ingestion), DBT (data compilation tool working on our storage and analysis platform), and SNOWFLAKE (cloud-based data storage and analysis platform).

### Fivetran

Fivetran is a powerful data integration tool that simplifies the process of extracting, transforming, and loading (ETL) data from various sources into data warehouses. With an intuitive and pre-configured interface, it eliminates integration complexity, allowing teams to focus on data analysis rather than infrastructure.

#### Key Features:

* Frictionless Connectivity: Facilitates connection with over 150 data sources, including applications, databases, files, cloud services, and more.

* Intelligent Automation: Completely automates the ETL process, regularly updating data while maintaining its integrity.

* Predefined Configuration: Offers preconfigured connectors for various sources, simplifying setup and reducing implementation time.

* Scalability and Performance: Ensures high performance and scalability, adapting to the growth needs of any organization.
  
### DBT(DATA BUILD TOOL) 

DBT is an open-source tool that simplifies and streamlines the data transformation process in modern data warehouses. Focused on SQL and oriented towards developers, it enables teams to efficiently create, version, test, and deploy data transformations.

#### Key Features:

* SQL-based Transformations: Allows users to write data transformations using standard SQL, facilitating understanding and collaboration among teams.

* Versioning and Code Control: Facilitates versioning of transformations, enabling tracking changes, reverting updates, and collaborative work in a controlled environment.

* Orchestration and Automation: Integrates with existing workflows, allowing automated execution of transformations as per defined scheduling.

* Integrated Testing: Provides testing capabilities to validate transformations and ensure the quality of resulting data.

### SNOWFLAKE

Snowflake is a cloud-based data storage and analysis platform designed to offer a modern and scalable approach to data handling. Utilizing a unique architecture of separate storage and computing, Snowflake enables efficient and elastic data processing.

#### Key Features:

* Multi-Cluster Architecture: Provides independent and scalable storage and computing, allowing dynamic resource adjustment based on demand.

* Compatibility with Various Data Types: Supports structured and semi-structured data, enabling integration and analysis of different data formats.

* Advanced Security: Offers robust security features, including data encryption, access management, and compliance with security standards.

* Integration with Tools and Services: Easily integrates with various BI, ETL, and other data solutions.

***

# Project Info

Initially, two data sources providing data were Google Sheets and SQL SERVER. For the ingestion of our initial data, Fivetran was used, and this data was transferred from its sources to SNOWFLAKE (where the data will reside and undergo all transformations).

However, due to the limited data quantity from our source as it is a small project, it was decided to perform incremental ingestion from SNOWFLAKE to a series of stages. This process is carried out through a combination of stored procedures where existing metric data is selected and unique IDs are generated to create unique data with as realistic values as possible. These procedures are called by a task that runs repetitively at specified time intervals, generating new data in our bronze layer.

The data we have in our source is as follows:

![PROYECTO_CIVICA](https://github.com/JairoLuisAbril/curso_data_engineering/assets/150705587/f8bbf7fe-a68d-4011-b1b6-14e37212d74d)

This transformation process will take place in three stages: Bronze Layer (data storage as is), Silver Layer (data transformation and casting), and Gold Layer (modeling through dimension tables and fact tables).

***

# Process

#### Bronze Layer

As previously seen, this will be the structure of our Bronze Layer. Below is the directory structure in the different layers.

#### Silver Layer

This is where data transformation and casting occur (visible in the directory models/Staging).

![staging](https://github.com/JairoLuisAbril/curso_data_engineering/assets/150705587/f683e29b-36a2-42bb-a1c9-dfe182731efa)

https://github.com/JairoLuisAbril/curso_data_engineering/tree/main/models/staging

#### Gold Layer

This phase is the final result of modeling with the unification of our orders and orders_items tables to create a unique fact table for both. Additionally, dimensions are created for denormalized tables (visible in the directory models/marts/core).

![gold](https://github.com/JairoLuisAbril/curso_data_engineering/assets/150705587/19345118-9924-41c0-a758-8b1aafb293be)

https://github.com/JairoLuisAbril/curso_data_engineering/tree/main/models/marts/core

***

# Functionalities and Testings

#### Tests

For the transformation process performed with DBT, various tools have been used. The first one visible is the creation of YAML documents that declare data lineage, descriptive documentation of said data, and most importantly, perform tests on that data.

All these tests can be viewed in the section Tests Directory. An example of a test, in this case generic for our silver layer, would be as follows:

![test](https://github.com/JairoLuisAbril/curso_data_engineering/assets/150705587/2a17a154-6628-4549-b2b2-311335977a6f)

#### Incrementals

Incrementals have been considered in different tables such as orders and order_items. These tables will have an incremental ingestion of data thanks to the scheduled tasks performed in SNOWFLAKE.

This functionality saves computation as only the created lines or rows since the last ingestion will be executed. This saves time and workload for our models as they do not need to execute them entirely but only the updated, deleted, or inserted part. This can be seen in the models section in the corresponding orders and order_items models or their respective facts. An example of using incrementals would be:

![Captura](https://github.com/JairoLuisAbril/curso_data_engineering/assets/150705587/050ec522-e002-43c4-9424-bd0f2093d6fd)

#### Snapshot

Snapshots are instant copies of data and metadata at a specific point in time. These snapshots are logical and consistent backups of the database state and can be used to recover data or metadata at that particular state in the future. In this project, different snapshots are made to have a historical control of the tables. Some of these snapshots can be incremental, such as the snapshot of fact_order_items located in models.

All snapshots are located within the project in the snapshot directory, and the most characteristic example is the aforementioned fact_order_items, which is an incremental snapshot, saving both computation and time.

![Captura](https://github.com/JairoLuisAbril/curso_data_engineering/assets/150705587/3e1692b0-9b09-41ab-ac6d-4b72d15507c3)



