# Azure Resource Graph (ARG) Queries

This directory contains the Kusto Query Language (KQL) queries used by Sovereign Control Panel (SCP) to evaluate resource compliance posture across a Sovereign View scope.

When a compliance evaluation result in the Azure portal references an ARG query, its **View query** link points to the corresponding versioned `.kql` file in this folder (`arg-queries/<query-id>.<version>.kql`).

<!-- BEGIN DataResidency -->
## Data Residency

### Microsoft.ApiManagement/service

Offerings: API Management

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-apimanagement-service-cmk.v1.kql](./dataresidency-replica-apimanagement-service-cmk.v1.kql) | CMK |  |
| [dataresidency-replica-apimanagement-service-vnet.v1.kql](./dataresidency-replica-apimanagement-service-vnet.v1.kql) | VNet |  |

### Microsoft.App/containerApps

Offerings: Azure Container Apps

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-app-containerapps-vnet.v1.kql](./dataresidency-replica-app-containerapps-vnet.v1.kql) | VNet |  |

### Microsoft.AppConfiguration/configurationStores

Offerings: Azure App Configuration

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-appconfig-keyvault.v1.kql](./dataresidency-replica-appconfig-keyvault.v1.kql) | Key Vault | DataResidencyReplica: an App Configuration store's customer-managed key (CMK) resolves to a Key Vault; the handler checks that vault's location against the allowed set. |
| [dataresidency-replica-appconfig-private-endpoint.v1.kql](./dataresidency-replica-appconfig-private-endpoint.v1.kql) | Private Endpoint |  |

### Microsoft.Automation/automationAccounts

Offerings: Automation

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-automation-automationaccounts-key-vault.v1.kql](./dataresidency-replica-automation-automationaccounts-key-vault.v1.kql) | Key Vault |  |
| [dataresidency-replica-automation-automationaccounts-private-endpoint.v1.kql](./dataresidency-replica-automation-automationaccounts-private-endpoint.v1.kql) | Private Endpoint |  |

### Microsoft.Batch/batchAccounts

Offerings: Batch

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-batch-batchaccounts-cmk.v1.kql](./dataresidency-replica-batch-batchaccounts-cmk.v1.kql) | CMK |  |
| [dataresidency-replica-batch-batchaccounts-key-vault.v1.kql](./dataresidency-replica-batch-batchaccounts-key-vault.v1.kql) | Key Vault |  |
| [dataresidency-replica-batch-batchaccounts-storageaccount.v1.kql](./dataresidency-replica-batch-batchaccounts-storageaccount.v1.kql) | Storage Account |  |
| [dataresidency-replica-batch-batchaccounts-user-assigned-managed-identity.v1.kql](./dataresidency-replica-batch-batchaccounts-user-assigned-managed-identity.v1.kql) | User Assigned Managed Identity |  |

### Microsoft.Cache/redis

Offerings: Redis Cache

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-cache-redis-linked-server.v1.kql](./dataresidency-replica-cache-redis-linked-server.v1.kql) | Linked Server | Find Azure Cache for Redis instances and their linked caches. |

### Microsoft.Cache/redisEnterprise

Offerings: Azure Managed Redis

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-cache-redisenterprise-cmk.v1.kql](./dataresidency-replica-cache-redisenterprise-cmk.v1.kql) | CMK |  |

### Microsoft.CognitiveServices/accounts

Offerings: Azure AI Content Understanding, Azure AI Document Intelligence, Azure Translator

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-cognitiveservices-accounts-cmk.v1.kql](./dataresidency-replica-cognitiveservices-accounts-cmk.v1.kql) | CMK |  |
| [dataresidency-replica-cognitiveservices-accounts-storage-account.v1.kql](./dataresidency-replica-cognitiveservices-accounts-storage-account.v1.kql) | Storage Account |  |
| [dataresidency-replica-cognitiveservices-accounts-user-assigned-managed-identity.v1.kql](./dataresidency-replica-cognitiveservices-accounts-user-assigned-managed-identity.v1.kql) | User Assigned Managed Identity |  |
| [dataresidency-replica-cognitiveservices-accounts-vnet.v1.kql](./dataresidency-replica-cognitiveservices-accounts-vnet.v1.kql) | VNet |  |

### Microsoft.Compute/disks

Offerings: Azure Managed Disks, Disk Storage, Ultra Disk Storage

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-compute-disks-diskencryptionset.v1.kql](./dataresidency-replica-compute-disks-diskencryptionset.v1.kql) | Disk Encryption Set |  |
| [dataresidency-replica-compute-disks-elastic-san.v1.kql](./dataresidency-replica-compute-disks-elastic-san.v1.kql) | Elastic SAN |  |
| [dataresidency-replica-compute-disks-gallery-image-version.v1.kql](./dataresidency-replica-compute-disks-gallery-image-version.v1.kql) | Gallery Image Version |  |
| [dataresidency-replica-compute-disks-key-vault.v1.kql](./dataresidency-replica-compute-disks-key-vault.v1.kql) | Key Vault |  |
| [dataresidency-replica-compute-disks-sourcedisk.v1.kql](./dataresidency-replica-compute-disks-sourcedisk.v1.kql) | Source Disk |  |
| [dataresidency-replica-compute-disks-storage-account.v1.kql](./dataresidency-replica-compute-disks-storage-account.v1.kql) | Storage Account |  |

### Microsoft.Compute/galleries/images/versions

Offerings: Shared Image Gallery (Azure Compute Gallery)

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-compute-galleries-images-versions-disk-snapshot.v1.kql](./dataresidency-replica-compute-galleries-images-versions-disk-snapshot.v1.kql) | Disk Snapshot |  |
| [dataresidency-replica-compute-galleries-images-versions-managed-image-version-source.v1.kql](./dataresidency-replica-compute-galleries-images-versions-managed-image-version-source.v1.kql) | Managed Image (Version Source) | Find managed images referenced as sources by Azure Compute Gallery image versions. |
| [dataresidency-replica-compute-galleries-images-versions-storage-profile.v1.kql](./dataresidency-replica-compute-galleries-images-versions-storage-profile.v1.kql) | Storage Profile |  |

### Microsoft.Compute/hostGroups/hosts

Offerings: Azure Dedicated Host

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-compute-hostgroups-hosts-hosted-vms.v1.kql](./dataresidency-replica-compute-hostgroups-hosts-hosted-vms.v1.kql) | Hosted VMs | Find virtual machines listed on Azure Dedicated Hosts. |

### Microsoft.Compute/virtualMachines

Offerings: Virtual Machines

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-vm-availabilityset.v1.kql](./dataresidency-replica-vm-availabilityset.v1.kql) | Availability Set | DataResidencyReplica: a virtual machine's availability set is a linked resource whose location must fall within the allowed set. |
| [dataresidency-replica-vm-capacity-reservation.v1.kql](./dataresidency-replica-vm-capacity-reservation.v1.kql) | Capacity Reservation |  |
| [dataresidency-replica-vm-datadisk.v1.kql](./dataresidency-replica-vm-datadisk.v1.kql) | Data Disk | DataResidencyReplica: a virtual machine's managed data disks are linked resources whose location must fall within the allowed set. |
| [dataresidency-replica-vm-diskencryptionset.v1.kql](./dataresidency-replica-vm-diskencryptionset.v1.kql) | Disk Encryption Set |  |
| [dataresidency-replica-vm-image.v1.kql](./dataresidency-replica-vm-image.v1.kql) | Image |  |
| [dataresidency-replica-vm-nic.v1.kql](./dataresidency-replica-vm-nic.v1.kql) | NIC | DataResidencyReplica: a virtual machine references one or more network interfaces (NICs); each NIC is a linked resource whose location must fall within the allowed set. |
| [dataresidency-replica-vm-os-disk.v1.kql](./dataresidency-replica-vm-os-disk.v1.kql) | OS Disk |  |
| [dataresidency-replica-vm-ppg.v1.kql](./dataresidency-replica-vm-ppg.v1.kql) | Proximity Placement Group | DataResidencyReplica: a virtual machine's proximity placement group (PPG) is a linked resource whose location must fall within the allowed set. |

### Microsoft.Compute/virtualMachineScaleSets

Offerings: Virtual Machine Scale Sets

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-compute-virtualmachinescalesets-cmk.v1.kql](./dataresidency-replica-compute-virtualmachinescalesets-cmk.v1.kql) | CMK |  |
| [dataresidency-replica-compute-virtualmachinescalesets-host-group.v1.kql](./dataresidency-replica-compute-virtualmachinescalesets-host-group.v1.kql) | Host Group |  |
| [dataresidency-replica-compute-virtualmachinescalesets-ppg.v1.kql](./dataresidency-replica-compute-virtualmachinescalesets-ppg.v1.kql) | Proximity Placement Group |  |
| [dataresidency-replica-compute-virtualmachinescalesets-user-assigned-managed-identity.v1.kql](./dataresidency-replica-compute-virtualmachinescalesets-user-assigned-managed-identity.v1.kql) | User Assigned Managed Identity |  |
| [dataresidency-replica-compute-virtualmachinescalesets-vnet.v1.kql](./dataresidency-replica-compute-virtualmachinescalesets-vnet.v1.kql) | VNet |  |

### Microsoft.ContainerInstance/containerGroups

Offerings: Container Instances

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-containerinstance-containergroups-cmk.v1.kql](./dataresidency-replica-containerinstance-containergroups-cmk.v1.kql) | CMK |  |
| [dataresidency-replica-containerinstance-containergroups-log-analytics.v1.kql](./dataresidency-replica-containerinstance-containergroups-log-analytics.v1.kql) | Log Analytics Workspace |  |

### Microsoft.ContainerRegistry/registries

Offerings: Container Registry

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-containerregistry-registries-key-vault.v1.kql](./dataresidency-replica-containerregistry-registries-key-vault.v1.kql) | Key Vault |  |
| [dataresidency-replica-containerregistry-registries-private-endpoint.v1.kql](./dataresidency-replica-containerregistry-registries-private-endpoint.v1.kql) | Private Endpoint |  |
| [dataresidency-replica-containerregistry-registries-replica.v1.kql](./dataresidency-replica-containerregistry-registries-replica.v1.kql) | Replica |  |

### Microsoft.ContainerRegistry/registries/agentPools

Offerings: Container Registry

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-containerregistry-registries-agentpools-vnet.v1.kql](./dataresidency-replica-containerregistry-registries-agentpools-vnet.v1.kql) | VNet |  |

### Microsoft.ContainerService/managedClusters

Offerings: Azure Kubernetes Service (AKS)

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-containerservice-managedclusters-diskencryptionset.v1.kql](./dataresidency-replica-containerservice-managedclusters-diskencryptionset.v1.kql) | Disk Encryption Set |  |
| [dataresidency-replica-containerservice-managedclusters-key-vault.v1.kql](./dataresidency-replica-containerservice-managedclusters-key-vault.v1.kql) | Key Vault |  |
| [dataresidency-replica-containerservice-managedclusters-loganalyticsworkspace.v1.kql](./dataresidency-replica-containerservice-managedclusters-loganalyticsworkspace.v1.kql) | Log Analytics Workspace |  |
| [dataresidency-replica-containerservice-managedclusters-snapshot-source.v1.kql](./dataresidency-replica-containerservice-managedclusters-snapshot-source.v1.kql) | Snapshot Source |  |
| [dataresidency-replica-containerservice-managedclusters-vnet.v1.kql](./dataresidency-replica-containerservice-managedclusters-vnet.v1.kql) | VNet |  |

### Microsoft.Dashboard/grafana

Offerings: Azure Grafana Service

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-dashboard-grafana-azure-monitor-workspace.v1.kql](./dataresidency-replica-dashboard-grafana-azure-monitor-workspace.v1.kql) | Azure Monitor Workspace |  |

### Microsoft.Databricks/workspaces

Offerings: Azure Databricks

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-databricks-workspaces-access-connector.v1.kql](./dataresidency-replica-databricks-workspaces-access-connector.v1.kql) | Access Connector |  |
| [dataresidency-replica-databricks-workspaces-azure-ml-workspace-parameter.v1.kql](./dataresidency-replica-databricks-workspaces-azure-ml-workspace-parameter.v1.kql) | Azure ML Workspace (Parameter) | Find Azure Machine Learning workspaces referenced by Azure Databricks workspace parameters. |
| [dataresidency-replica-databricks-workspaces-cmk.v1.kql](./dataresidency-replica-databricks-workspaces-cmk.v1.kql) | CMK |  |
| [dataresidency-replica-databricks-workspaces-vnet.v1.kql](./dataresidency-replica-databricks-workspaces-vnet.v1.kql) | VNet |  |

### Microsoft.DataFactory/factories

Offerings: Data Factory

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-datafactory-factories-cmk.v1.kql](./dataresidency-replica-datafactory-factories-cmk.v1.kql) | CMK |  |
| [dataresidency-replica-datafactory-factories-purview-account.v1.kql](./dataresidency-replica-datafactory-factories-purview-account.v1.kql) | Purview Account |  |

### Microsoft.DBforMySQL/flexibleServers

Offerings: Azure Database for MySQL

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-dbformysql-flexibleservers-cmk.v1.kql](./dataresidency-replica-dbformysql-flexibleservers-cmk.v1.kql) | CMK |  |
| [dataresidency-replica-dbformysql-flexibleservers-privatednszone.v1.kql](./dataresidency-replica-dbformysql-flexibleservers-privatednszone.v1.kql) | Private DNS Zone |  |
| [dataresidency-replica-dbformysql-flexibleservers-replica.v1.kql](./dataresidency-replica-dbformysql-flexibleservers-replica.v1.kql) | Replica |  |
| [dataresidency-replica-dbformysql-flexibleservers-vnet.v1.kql](./dataresidency-replica-dbformysql-flexibleservers-vnet.v1.kql) | VNet |  |

### Microsoft.DBforPostgreSQL/flexibleServers

Offerings: Azure Database for PostgreSQL

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-dbforpostgresql-flexibleservers-cmk.v1.kql](./dataresidency-replica-dbforpostgresql-flexibleservers-cmk.v1.kql) | CMK |  |
| [dataresidency-replica-dbforpostgresql-flexibleservers-privatednszone.v1.kql](./dataresidency-replica-dbforpostgresql-flexibleservers-privatednszone.v1.kql) | Private DNS Zone |  |
| [dataresidency-replica-dbforpostgresql-flexibleservers-replica.v1.kql](./dataresidency-replica-dbforpostgresql-flexibleservers-replica.v1.kql) | Replica |  |
| [dataresidency-replica-dbforpostgresql-flexibleservers-vnet.v1.kql](./dataresidency-replica-dbforpostgresql-flexibleservers-vnet.v1.kql) | VNet |  |

### Microsoft.Devices/IotHubs

Offerings: IoT Hub, Azure IoT Edge

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-devices-iothubs-event-hub.v1.kql](./dataresidency-replica-devices-iothubs-event-hub.v1.kql) | Event Hub |  |
| [dataresidency-replica-devices-iothubs-private-endpoint.v1.kql](./dataresidency-replica-devices-iothubs-private-endpoint.v1.kql) | Private Endpoint |  |
| [dataresidency-replica-devices-iothubs-service-bus.v1.kql](./dataresidency-replica-devices-iothubs-service-bus.v1.kql) | Service Bus |  |
| [dataresidency-replica-devices-iothubs-storage.v1.kql](./dataresidency-replica-devices-iothubs-storage.v1.kql) | Storage Account |  |

### Microsoft.Devices/provisioningServices

Offerings: IoT Hub Device Provisioning Service

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-devices-provisioningservices-linked-location.v1.kql](./dataresidency-replica-devices-provisioningservices-linked-location.v1.kql) | Linked Location |  |

### Microsoft.DeviceUpdate/accounts

Offerings: Device Update for IoT Hub

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-deviceupdate-accounts-cmk.v1.kql](./dataresidency-replica-deviceupdate-accounts-cmk.v1.kql) | CMK |  |
| [dataresidency-replica-deviceupdate-accounts-linked-iot-hubs.v1.kql](./dataresidency-replica-deviceupdate-accounts-linked-iot-hubs.v1.kql) | Linked IoT Hubs |  |
| [dataresidency-replica-deviceupdate-accounts-storage-account.v1.kql](./dataresidency-replica-deviceupdate-accounts-storage-account.v1.kql) | Storage Account |  |

### Microsoft.DocumentDB/cassandraClusters

Offerings: Azure Managed Instance for Apache Cassandra

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-documentdb-cassandraclusters-vnet.v1.kql](./dataresidency-replica-documentdb-cassandraclusters-vnet.v1.kql) | VNet |  |

### Microsoft.DocumentDB/databaseAccounts

Offerings: Azure Cosmos DB

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-documentdb-databaseaccounts-cmk.v1.kql](./dataresidency-replica-documentdb-databaseaccounts-cmk.v1.kql) | CMK |  |
| [dataresidency-replica-documentdb-databaseaccounts-vnet.v1.kql](./dataresidency-replica-documentdb-databaseaccounts-vnet.v1.kql) | VNet |  |

### Microsoft.ElasticSan/elasticSans

Offerings: Azure Elastic SAN

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-elasticsan-elasticsans-private-endpoint.v1.kql](./dataresidency-replica-elasticsan-elasticsans-private-endpoint.v1.kql) | Private Endpoint |  |
| [dataresidency-replica-elasticsan-elasticsans-vnet.v1.kql](./dataresidency-replica-elasticsan-elasticsans-vnet.v1.kql) | VNet |  |

### Microsoft.ElasticSan/elasticSans/volumeGroups

Offerings: Azure Elastic SAN

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-elasticsan-elasticsans-volumegroups-key-vault.v1.kql](./dataresidency-replica-elasticsan-elasticsans-volumegroups-key-vault.v1.kql) | Key Vault |  |

### Microsoft.EventGrid/systemTopics

Offerings: Event Grid

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-eventgrid-systemtopics-source.v1.kql](./dataresidency-replica-eventgrid-systemtopics-source.v1.kql) | Source |  |

### Microsoft.EventHub/namespaces

Offerings: Event Hubs

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-eventhub-namespaces-cmk.v1.kql](./dataresidency-replica-eventhub-namespaces-cmk.v1.kql) | CMK |  |
| [dataresidency-replica-eventhub-namespaces-private-endpoint.v1.kql](./dataresidency-replica-eventhub-namespaces-private-endpoint.v1.kql) | Private Endpoint |  |

### Microsoft.FluidRelay/fluidRelayServers

Offerings: Fluid Relay Service

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-fluidrelay-fluidrelayservers-cmk.v1.kql](./dataresidency-replica-fluidrelay-fluidrelayservers-cmk.v1.kql) | CMK |  |
| [dataresidency-replica-fluidrelay-fluidrelayservers-user-assigned-managed-identity.v1.kql](./dataresidency-replica-fluidrelay-fluidrelayservers-user-assigned-managed-identity.v1.kql) | User Assigned Managed Identity |  |

### Microsoft.HDInsight/clusters

Offerings: HDInsight

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-hdinsight-clusters-cmk.v1.kql](./dataresidency-replica-hdinsight-clusters-cmk.v1.kql) | CMK |  |
| [dataresidency-replica-hdinsight-clusters-storageaccount.v1.kql](./dataresidency-replica-hdinsight-clusters-storageaccount.v1.kql) | Storage Account |  |
| [dataresidency-replica-hdinsight-clusters-vnet.v1.kql](./dataresidency-replica-hdinsight-clusters-vnet.v1.kql) | VNet |  |

### Microsoft.HealthcareApis/workspaces

Offerings: Azure Health Data Services

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-healthcareapis-workspaces-private-endpoint.v1.kql](./dataresidency-replica-healthcareapis-workspaces-private-endpoint.v1.kql) | Private Endpoint |  |

### Microsoft.HealthcareApis/workspaces/dicomServices

Offerings: Azure Health Data Services

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-healthcareapis-workspaces-dicomservices-azure-key-vault.v1.kql](./dataresidency-replica-healthcareapis-workspaces-dicomservices-azure-key-vault.v1.kql) | Key Vault | Find Key Vaults referenced by Azure Health Data Services DICOM service encryption settings. |
| [dataresidency-replica-healthcareapis-workspaces-dicomservices-storage.v1.kql](./dataresidency-replica-healthcareapis-workspaces-dicomservices-storage.v1.kql) | Storage Account |  |

### Microsoft.Insights/dataCollectionRules

Offerings: Azure Monitor

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-insights-datacollectionrules-la-workspace-telemetry-destination.v1.kql](./dataresidency-replica-insights-datacollectionrules-la-workspace-telemetry-destination.v1.kql) | Log Analytics Workspace |  |

### Microsoft.Kusto/clusters

Offerings: Azure Data Explorer

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-kusto-clusters-cmk.v1.kql](./dataresidency-replica-kusto-clusters-cmk.v1.kql) | CMK |  |

### Microsoft.Kusto/clusters/databases/dataConnections

Offerings: Azure Data Explorer

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-kusto-clusters-databases-dataconnections-iot-hub.v1.kql](./dataresidency-replica-kusto-clusters-databases-dataconnections-iot-hub.v1.kql) | IoT Hub |  |

### Microsoft.LoadTestService/loadTests

Offerings: Azure App Testing

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-loadtestservice-loadtests-key-vault.v1.kql](./dataresidency-replica-loadtestservice-loadtests-key-vault.v1.kql) | Key Vault |  |
| [dataresidency-replica-loadtestservice-loadtests-user-assigned-managed-identity.v1.kql](./dataresidency-replica-loadtestservice-loadtests-user-assigned-managed-identity.v1.kql) | User Assigned Managed Identity |  |

### Microsoft.MachineLearningServices/workspaces

Offerings: Azure Machine Learning

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-machinelearningservices-workspaces-application-insights.v1.kql](./dataresidency-replica-machinelearningservices-workspaces-application-insights.v1.kql) | Application Insights |  |
| [dataresidency-replica-machinelearningservices-workspaces-container-registry.v1.kql](./dataresidency-replica-machinelearningservices-workspaces-container-registry.v1.kql) | Container Registry |  |
| [dataresidency-replica-machinelearningservices-workspaces-key-vault.v1.kql](./dataresidency-replica-machinelearningservices-workspaces-key-vault.v1.kql) | Key Vault |  |
| [dataresidency-replica-machinelearningservices-workspaces-storageaccount.v1.kql](./dataresidency-replica-machinelearningservices-workspaces-storageaccount.v1.kql) | Storage Account |  |

### Microsoft.Migrate/migrateProjects

Offerings: Azure Migrate

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-migrate-migrateprojects-storage-accounts.v1.kql](./dataresidency-replica-migrate-migrateprojects-storage-accounts.v1.kql) | Storage Account |  |

### Microsoft.Monitor/accounts

Offerings: Azure Monitor

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-monitor-accounts-private-endpoint.v1.kql](./dataresidency-replica-monitor-accounts-private-endpoint.v1.kql) | Private Endpoint | Find private endpoints connected to Azure Monitor workspaces. |

### Microsoft.NetApp/netAppAccounts

Offerings: Azure NetApp Files

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-netapp-netappaccounts-cmk.v1.kql](./dataresidency-replica-netapp-netappaccounts-cmk.v1.kql) | CMK |  |

### Microsoft.NetApp/netAppAccounts/capacityPools/volumes

Offerings: Azure NetApp Files

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-netapp-netappaccounts-capacitypools-volumes-remote-netapp-volume-crr-replica.v1.kql](./dataresidency-replica-netapp-netappaccounts-capacitypools-volumes-remote-netapp-volume-crr-replica.v1.kql) | Remote NetApp Volume (CRR Replica) |  |
| [dataresidency-replica-netapp-netappaccounts-capacitypools-volumes-remote-volume.v1.kql](./dataresidency-replica-netapp-netappaccounts-capacitypools-volumes-remote-volume.v1.kql) | Remote Volume |  |
| [dataresidency-replica-netapp-netappaccounts-capacitypools-volumes-vnet.v1.kql](./dataresidency-replica-netapp-netappaccounts-capacitypools-volumes-vnet.v1.kql) | VNet |  |

### Microsoft.Network/applicationGateways

Offerings: Application Gateway

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-network-applicationgateways-key-vault.v1.kql](./dataresidency-replica-network-applicationgateways-key-vault.v1.kql) | Key Vault |  |
| [dataresidency-replica-network-applicationgateways-vnet.v1.kql](./dataresidency-replica-network-applicationgateways-vnet.v1.kql) | VNet |  |
| [dataresidency-replica-network-applicationgateways-webapplicationfirewallpolicies.v1.kql](./dataresidency-replica-network-applicationgateways-webapplicationfirewallpolicies.v1.kql) | Web Application Firewall Policies |  |

### Microsoft.Network/azureFirewalls

Offerings: Azure Firewall

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-network-azurefirewalls-firewallpolicy.v1.kql](./dataresidency-replica-network-azurefirewalls-firewallpolicy.v1.kql) | Firewall Policy |  |
| [dataresidency-replica-network-azurefirewalls-publicipaddress.v1.kql](./dataresidency-replica-network-azurefirewalls-publicipaddress.v1.kql) | Public IP Address |  |
| [dataresidency-replica-network-azurefirewalls-virtualhub.v1.kql](./dataresidency-replica-network-azurefirewalls-virtualhub.v1.kql) | Virtual Hub |  |
| [dataresidency-replica-network-azurefirewalls-vnet.v1.kql](./dataresidency-replica-network-azurefirewalls-vnet.v1.kql) | VNet |  |

### Microsoft.Network/bastionHosts

Offerings: Azure Bastion

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-network-bastionhosts-publicipaddress.v1.kql](./dataresidency-replica-network-bastionhosts-publicipaddress.v1.kql) | Public IP Address |  |
| [dataresidency-replica-network-bastionhosts-vnet.v1.kql](./dataresidency-replica-network-bastionhosts-vnet.v1.kql) | VNet |  |

### Microsoft.Network/loadBalancers

Offerings: Azure Load Balancer

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-network-loadbalancers-backend-nic-ipconfigurations.v1.kql](./dataresidency-replica-network-loadbalancers-backend-nic-ipconfigurations.v1.kql) | Backend NIC IP Configurations |  |
| [dataresidency-replica-network-loadbalancers-frontend-ip-address.v1.kql](./dataresidency-replica-network-loadbalancers-frontend-ip-address.v1.kql) | Frontend IP Address |  |
| [dataresidency-replica-network-loadbalancers-load-balancer-ip-address.v1.kql](./dataresidency-replica-network-loadbalancers-load-balancer-ip-address.v1.kql) | Load Balancer IP Address |  |

### Microsoft.Network/natGateways

Offerings: Azure NAT Gateway - Virtual Network NAT

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-network-natgateways-public-ips-prefixes.v1.kql](./dataresidency-replica-network-natgateways-public-ips-prefixes.v1.kql) | Public IPs / Prefixes |  |
| [dataresidency-replica-network-natgateways-publicipaddress.v1.kql](./dataresidency-replica-network-natgateways-publicipaddress.v1.kql) | Public IP Address |  |

### Microsoft.Network/virtualNetworkGateways

Offerings: VPN Gateway

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-network-virtualnetworkgateways-local-network-gateway-2.v1.kql](./dataresidency-replica-network-virtualnetworkgateways-local-network-gateway-2.v1.kql) | Local Network Gateway |  |
| [dataresidency-replica-network-virtualnetworkgateways-publicipaddress.v1.kql](./dataresidency-replica-network-virtualnetworkgateways-publicipaddress.v1.kql) | Public IP Address |  |
| [dataresidency-replica-network-virtualnetworkgateways-vnet.v1.kql](./dataresidency-replica-network-virtualnetworkgateways-vnet.v1.kql) | VNet |  |

### Microsoft.Network/virtualNetworks

Offerings: Virtual Network

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-network-virtualnetworks-ddos-protection-plan-id.v1.kql](./dataresidency-replica-network-virtualnetworks-ddos-protection-plan-id.v1.kql) | DDoS Protection Plan |  |
| [dataresidency-replica-network-virtualnetworks-nsg.v1.kql](./dataresidency-replica-network-virtualnetworks-nsg.v1.kql) | NSG |  |
| [dataresidency-replica-network-virtualnetworks-peered-vnet.v1.kql](./dataresidency-replica-network-virtualnetworks-peered-vnet.v1.kql) | Peered VNet |  |
| [dataresidency-replica-network-virtualnetworks-subnet-nat-gateway.v1.kql](./dataresidency-replica-network-virtualnetworks-subnet-nat-gateway.v1.kql) | Subnet NAT Gateway |  |
| [dataresidency-replica-network-virtualnetworks-subnet-route-table.v1.kql](./dataresidency-replica-network-virtualnetworks-subnet-route-table.v1.kql) | Subnet Route Table |  |

### Microsoft.OffAzure/HyperVSites

Offerings: Azure Migrate

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-offazure-hypervsites-key-vault.v1.kql](./dataresidency-replica-offazure-hypervsites-key-vault.v1.kql) | Key Vault |  |

### Microsoft.OffAzure/MasterSites

Offerings: Azure Migrate

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-offazure-mastersites-discovery-master-site-storage-account.v1.kql](./dataresidency-replica-offazure-mastersites-discovery-master-site-storage-account.v1.kql) | Discovery Master Site Storage Account | Find storage accounts referenced by Azure Migrate discovery master sites. |
| [dataresidency-replica-offazure-mastersites-private-endpoint.v1.kql](./dataresidency-replica-offazure-mastersites-private-endpoint.v1.kql) | Private Endpoint | Find private endpoints connected to Azure Migrate discovery master sites. |

### Microsoft.OffAzure/VMwareSites

Offerings: Azure Migrate

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-offazure-vmwaresites-key-vault.v1.kql](./dataresidency-replica-offazure-vmwaresites-key-vault.v1.kql) | Key Vault |  |

### Microsoft.RecoveryServices/vaults

Offerings: Backup, Site Recovery

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-recoveryservices-vaults-cmk.v1.kql](./dataresidency-replica-recoveryservices-vaults-cmk.v1.kql) | CMK |  |
| [dataresidency-replica-recoveryservices-vaults-key-vault.v1.kql](./dataresidency-replica-recoveryservices-vaults-key-vault.v1.kql) | Key Vault |  |

### Microsoft.RedHatOpenShift/openShiftClusters

Offerings: Azure Red Hat OpenShift (ARO)

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-redhatopenshift-openshiftclusters-vnet.v1.kql](./dataresidency-replica-redhatopenshift-openshiftclusters-vnet.v1.kql) | VNet |  |

### Microsoft.Resources/deploymentScripts

Offerings: Azure Resource Manager

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-resources-deploymentscripts-storage-account.v1.kql](./dataresidency-replica-resources-deploymentscripts-storage-account.v1.kql) | Storage Account | Find storage accounts referenced by Azure deployment scripts. |

### Microsoft.Search/searchServices

Offerings: Azure AI Search

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-search-searchservices-privatelinkresource.v1.kql](./dataresidency-replica-search-searchservices-privatelinkresource.v1.kql) | Private Link Resource |  |

### Microsoft.ServiceBus/namespaces

Offerings: Service Bus

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-servicebus-namespaces-cmk.v1.kql](./dataresidency-replica-servicebus-namespaces-cmk.v1.kql) | CMK |  |

### Microsoft.Solutions/applications

Offerings: Azure Managed Applications

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-solutions-applications-application-definition.v1.kql](./dataresidency-replica-solutions-applications-application-definition.v1.kql) | Application Definition |  |

### Microsoft.Sql/managedInstances

Offerings: Azure SQL Managed Instance

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-sql-managedinstances-dns-zone-partner.v1.kql](./dataresidency-replica-sql-managedinstances-dns-zone-partner.v1.kql) | DNS Zone Partner |  |
| [dataresidency-replica-sql-managedinstances-instance-pool-id.v1.kql](./dataresidency-replica-sql-managedinstances-instance-pool-id.v1.kql) | Instance Pool |  |
| [dataresidency-replica-sql-managedinstances-vnet.v1.kql](./dataresidency-replica-sql-managedinstances-vnet.v1.kql) | VNet |  |

### Microsoft.Sql/servers/databases

Offerings: Azure SQL Database

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-sql-servers-databases-elastic-pool-id.v1.kql](./dataresidency-replica-sql-servers-databases-elastic-pool-id.v1.kql) | Elastic Pool |  |

### Microsoft.SqlVirtualMachine/sqlVirtualMachines

Offerings: SQL Server on Azure Virtual Machines

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-sqlvirtualmachine-sqlvirtualmachines-underlying-virtual-machine.v1.kql](./dataresidency-replica-sqlvirtualmachine-sqlvirtualmachines-underlying-virtual-machine.v1.kql) | Underlying Virtual Machine |  |
| [dataresidency-replica-sqlvirtualmachine-sqlvirtualmachines-virtual-machine-identity-setting.v1.kql](./dataresidency-replica-sqlvirtualmachine-sqlvirtualmachines-virtual-machine-identity-setting.v1.kql) | Virtual Machine Identity Setting | Find user-assigned managed identities referenced by SQL virtual machine identity settings. |
| [dataresidency-replica-sqlvirtualmachine-sqlvirtualmachines-virtualmachinegroupresource.v1.kql](./dataresidency-replica-sqlvirtualmachine-sqlvirtualmachines-virtualmachinegroupresource.v1.kql) | Virtual Machine Group Resource |  |

### Microsoft.Storage/storageAccounts

Offerings: Storage, Archive Storage, Azure Data Lake Storage Gen2, Azure Files, Premium Block Blobs, Queues, Tables

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-autogeo-storage.v1.kql](./dataresidency-autogeo-storage.v1.kql) |  | DirectResult: an Auto Geo-Redundant storage account's own SKU deterministically decides residency compliance (the geo-replica is guaranteed to stay in the primary geography). |
| [dataresidency-replica-storage-cmk.v1.kql](./dataresidency-replica-storage-cmk.v1.kql) | CMK |  |
| [dataresidency-replica-storage-keyvault.v1.kql](./dataresidency-replica-storage-keyvault.v1.kql) | CMK | DataResidencyReplica: a storage account's customer-managed key (CMK) resolves to a Key Vault; the handler checks that vault's location against the allowed set. |
| [dataresidency-replica-storage-vnet.v1.kql](./dataresidency-replica-storage-vnet.v1.kql) | VNet | DataResidencyReplica: a storage account's network ACL virtual-network rules reference subnets; each subnet's parent virtual network is a linked resource whose location must fall within the allowed set. |

### Microsoft.StorageCache/amlFilesystems

Offerings: Azure Managed Lustre (AMLFS)

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-storagecache-amlfilesystems-cmk.v1.kql](./dataresidency-replica-storagecache-amlfilesystems-cmk.v1.kql) | CMK |  |
| [dataresidency-replica-storagecache-amlfilesystems-file-system-subnet.v1.kql](./dataresidency-replica-storagecache-amlfilesystems-file-system-subnet.v1.kql) | File System Subnet |  |
| [dataresidency-replica-storagecache-amlfilesystems-hsm-backing-storage.v1.kql](./dataresidency-replica-storagecache-amlfilesystems-hsm-backing-storage.v1.kql) | HSM Backing Storage |  |

### Microsoft.StorageSync/storageSyncServices

Offerings: Azure File Sync

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-storagesync-storagesyncservices-privateendpoint.v1.kql](./dataresidency-replica-storagesync-storagesyncservices-privateendpoint.v1.kql) | Private Endpoint |  |

### Microsoft.StreamAnalytics/streamingJobs

Offerings: Azure Stream Analytics

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-streamanalytics-streamingjobs-dedicated-cluster.v1.kql](./dataresidency-replica-streamanalytics-streamingjobs-dedicated-cluster.v1.kql) | Dedicated Cluster |  |

### Microsoft.Synapse/workspaces

Offerings: Azure Synapse Analytics

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-synapse-workspaces-cmk.v1.kql](./dataresidency-replica-synapse-workspaces-cmk.v1.kql) | CMK |  |
| [dataresidency-replica-synapse-workspaces-key-vault.v1.kql](./dataresidency-replica-synapse-workspaces-key-vault.v1.kql) | Key Vault |  |
| [dataresidency-replica-synapse-workspaces-private-endpoint.v1.kql](./dataresidency-replica-synapse-workspaces-private-endpoint.v1.kql) | Private Endpoint |  |
| [dataresidency-replica-synapse-workspaces-purview-account.v1.kql](./dataresidency-replica-synapse-workspaces-purview-account.v1.kql) | Purview Account |  |
| [dataresidency-replica-synapse-workspaces-storage-account.v1.kql](./dataresidency-replica-synapse-workspaces-storage-account.v1.kql) | Storage Account |  |
| [dataresidency-replica-synapse-workspaces-virtual-network-subnet.v1.kql](./dataresidency-replica-synapse-workspaces-virtual-network-subnet.v1.kql) | VNet Subnet | Find virtual networks referenced by Azure Synapse workspace compute subnet settings. |

### Microsoft.VirtualMachineImages/imageTemplates

Offerings: Azure VM Image Builder

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-virtualmachineimages-imagetemplates-source-image-id.v1.kql](./dataresidency-replica-virtualmachineimages-imagetemplates-source-image-id.v1.kql) | Source Image |  |

### Microsoft.Web/sites

Offerings: App Service, Functions, Logic Apps

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-web-app-service-environment.v1.kql](./dataresidency-replica-web-app-service-environment.v1.kql) | App Service Environment |  |
| [dataresidency-replica-web-serverfarm.v1.kql](./dataresidency-replica-web-serverfarm.v1.kql) | Server Farms | DataResidencyReplica: a Web/site's linked App Service Plan (server farm) is the residency-relevant linked resource; the handler checks its location against the allowed set. |
| [dataresidency-replica-web-vnet.v1.kql](./dataresidency-replica-web-vnet.v1.kql) | VNet |  |

### Microsoft.Web/sites/config

Offerings: App Service

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-web-sites-config-api-management-backend.v1.kql](./dataresidency-replica-web-sites-config-api-management-backend.v1.kql) | API Management (Backend) | Find API Management services referenced by web app configuration resources. |

### Microsoft.Web/sites/slots

Offerings: App Service, Functions, Logic Apps

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-web-sites-slots-server-farms.v1.kql](./dataresidency-replica-web-sites-slots-server-farms.v1.kql) | Server Farms | Find App Service plans referenced by web app deployment slots. |
<!-- END DataResidency -->
