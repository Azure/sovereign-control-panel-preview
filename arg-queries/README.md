# Azure Resource Graph (ARG) Queries

This directory contains the Kusto Query Language (KQL) queries used by Sovereign Control Panel (SCP) to evaluate resource compliance posture across a Sovereign View scope.

When a compliance evaluation result in the Azure portal references an ARG query, its **View query** link points to the corresponding versioned `.kql` file in this folder (`arg-queries/<query-id>.<version>.kql`).

<!-- BEGIN DataResidency -->
## Data Residency

### Microsoft.ApiManagement/service

Offerings: API Management

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-apimanagement-service-cmk.v1.kql](./dataresidency-replica-apimanagement-service-cmk.v1.kql) | CMK | Find Key Vaults referenced by API Management custom hostname configurations. |
| [dataresidency-replica-apimanagement-service-replica.v1.kql](./dataresidency-replica-apimanagement-service-replica.v1.kql) | Replica | Find API Management services deployed to additional gateway locations. |
| [dataresidency-replica-apimanagement-service-vnet.v1.kql](./dataresidency-replica-apimanagement-service-vnet.v1.kql) | VNet | Find virtual networks referenced by API Management services. |

### Microsoft.App/containerApps

Offerings: Azure Container Apps

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-app-containerapps-vnet.v1.kql](./dataresidency-replica-app-containerapps-vnet.v1.kql) | VNet | Find virtual networks referenced by Container Apps through their managed environments. |

### Microsoft.AppConfiguration/configurationStores

Offerings: Azure App Configuration

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-appconfig-keyvault.v1.kql](./dataresidency-replica-appconfig-keyvault.v1.kql) | Key Vault | Find App Configuration stores configured with a customer-managed encryption key. |
| [dataresidency-replica-appconfig-private-endpoint.v1.kql](./dataresidency-replica-appconfig-private-endpoint.v1.kql) | Private Endpoint | Find private endpoints connected to App Configuration stores. |

### Microsoft.Automation/automationAccounts

Offerings: Automation

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-automation-automationaccounts-key-vault.v1.kql](./dataresidency-replica-automation-automationaccounts-key-vault.v1.kql) | Key Vault | Find Key Vaults referenced by Automation account encryption settings. |
| [dataresidency-replica-automation-automationaccounts-private-endpoint.v1.kql](./dataresidency-replica-automation-automationaccounts-private-endpoint.v1.kql) | Private Endpoint | Find private endpoints connected to Automation accounts. |

### Microsoft.Batch/batchAccounts

Offerings: Batch

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-batch-batchaccounts-cmk.v1.kql](./dataresidency-replica-batch-batchaccounts-cmk.v1.kql) | CMK | Find Key Vaults referenced by Batch account encryption settings. |
| [dataresidency-replica-batch-batchaccounts-key-vault.v1.kql](./dataresidency-replica-batch-batchaccounts-key-vault.v1.kql) | Key Vault | Find Key Vaults referenced by Batch accounts. |
| [dataresidency-replica-batch-batchaccounts-storageaccount.v1.kql](./dataresidency-replica-batch-batchaccounts-storageaccount.v1.kql) | Storage Account | Find storage accounts referenced by Batch account automatic storage settings. |
| [dataresidency-replica-batch-batchaccounts-user-assigned-managed-identity.v1.kql](./dataresidency-replica-batch-batchaccounts-user-assigned-managed-identity.v1.kql) | User Assigned Managed Identity | Find user-assigned managed identities referenced by Batch automatic storage settings. |

### Microsoft.Cache/redis

Offerings: Redis Cache

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-cache-redis-linked-server.v1.kql](./dataresidency-replica-cache-redis-linked-server.v1.kql) | Linked Server | Find Azure Cache for Redis instances and their linked caches. |

### Microsoft.Cache/redisEnterprise

Offerings: Azure Managed Redis

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-cache-redisenterprise-cmk.v1.kql](./dataresidency-replica-cache-redisenterprise-cmk.v1.kql) | CMK | Find Key Vaults referenced by Redis Enterprise customer-managed encryption settings. |

### Microsoft.CognitiveServices/accounts

Offerings: Azure AI Content Understanding, Azure AI Document Intelligence, Azure Translator

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-cognitiveservices-accounts-cmk.v1.kql](./dataresidency-replica-cognitiveservices-accounts-cmk.v1.kql) | CMK | Find Key Vaults referenced by Azure AI services account encryption settings. |
| [dataresidency-replica-cognitiveservices-accounts-storage-account.v1.kql](./dataresidency-replica-cognitiveservices-accounts-storage-account.v1.kql) | Storage Account | Find storage accounts referenced by Azure AI services accounts. |
| [dataresidency-replica-cognitiveservices-accounts-user-assigned-managed-identity.v1.kql](./dataresidency-replica-cognitiveservices-accounts-user-assigned-managed-identity.v1.kql) | User Assigned Managed Identity | Find user-assigned managed identities attached to Azure AI services accounts. |
| [dataresidency-replica-cognitiveservices-accounts-vnet.v1.kql](./dataresidency-replica-cognitiveservices-accounts-vnet.v1.kql) | VNet | Find virtual networks referenced by Azure AI services account network rules. |

### Microsoft.Compute/disks

Offerings: Azure Managed Disks, Disk Storage, Ultra Disk Storage

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-compute-disks-diskencryptionset.v1.kql](./dataresidency-replica-compute-disks-diskencryptionset.v1.kql) | Disk Encryption Set | Find disk encryption sets referenced by managed disks. |
| [dataresidency-replica-compute-disks-elastic-san.v1.kql](./dataresidency-replica-compute-disks-elastic-san.v1.kql) | Elastic SAN | Find Elastic SAN snapshots referenced through the source snapshots of managed disks. |
| [dataresidency-replica-compute-disks-gallery-image-version.v1.kql](./dataresidency-replica-compute-disks-gallery-image-version.v1.kql) | Gallery Image Version | Find gallery image resources referenced when creating managed disks. |
| [dataresidency-replica-compute-disks-key-vault.v1.kql](./dataresidency-replica-compute-disks-key-vault.v1.kql) | Key Vault | Find Key Vaults referenced by managed disk encryption settings. |
| [dataresidency-replica-compute-disks-sourcedisk.v1.kql](./dataresidency-replica-compute-disks-sourcedisk.v1.kql) | Source Disk | Find the source resources referenced when creating managed disks. |
| [dataresidency-replica-compute-disks-storage-account.v1.kql](./dataresidency-replica-compute-disks-storage-account.v1.kql) | Storage Account | Find storage accounts referenced when creating managed disks. |

### Microsoft.Compute/galleries/images/versions

Offerings: Shared Image Gallery (Azure Compute Gallery)

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-compute-galleries-images-versions-disk-snapshot.v1.kql](./dataresidency-replica-compute-galleries-images-versions-disk-snapshot.v1.kql) | Disk Snapshot | Find source resources referenced by Azure Compute Gallery image versions. |
| [dataresidency-replica-compute-galleries-images-versions-managed-image-version-source.v1.kql](./dataresidency-replica-compute-galleries-images-versions-managed-image-version-source.v1.kql) | Managed Image (Version Source) | Find managed images referenced as sources by Azure Compute Gallery image versions. |
| [dataresidency-replica-compute-galleries-images-versions-replica.v1.kql](./dataresidency-replica-compute-galleries-images-versions-replica.v1.kql) | Replica | Find Azure Compute Gallery image versions and the regions they are replicated to. |

### Microsoft.Compute/hostGroups/hosts

Offerings: Azure Dedicated Host

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-compute-hostgroups-hosts-hosted-vms.v1.kql](./dataresidency-replica-compute-hostgroups-hosts-hosted-vms.v1.kql) | Hosted VMs | Find virtual machines listed on Azure Dedicated Hosts. |

### Microsoft.Compute/virtualMachines

Offerings: Virtual Machines

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-vm-availabilityset.v1.kql](./dataresidency-replica-vm-availabilityset.v1.kql) | Availability Set | Find availability sets referenced by virtual machines. |
| [dataresidency-replica-vm-capacity-reservation.v1.kql](./dataresidency-replica-vm-capacity-reservation.v1.kql) | Capacity Reservation | Find capacity reservation groups referenced by virtual machines. |
| [dataresidency-replica-vm-datadisk.v1.kql](./dataresidency-replica-vm-datadisk.v1.kql) | Data Disk | Find managed data disks referenced by virtual machines. |
| [dataresidency-replica-vm-diskencryptionset.v1.kql](./dataresidency-replica-vm-diskencryptionset.v1.kql) | Disk Encryption Set | Find disk encryption sets referenced by virtual machine operating system disks. |
| [dataresidency-replica-vm-image.v1.kql](./dataresidency-replica-vm-image.v1.kql) | Image | Find image resources referenced by virtual machines. |
| [dataresidency-replica-vm-nic.v1.kql](./dataresidency-replica-vm-nic.v1.kql) | NIC | Find network interfaces referenced by virtual machines. |
| [dataresidency-replica-vm-os-disk.v1.kql](./dataresidency-replica-vm-os-disk.v1.kql) | OS Disk | Find managed operating system disks referenced by virtual machines. |
| [dataresidency-replica-vm-ppg.v1.kql](./dataresidency-replica-vm-ppg.v1.kql) | Proximity Placement Group | Find proximity placement groups referenced by virtual machines. |

### Microsoft.Compute/virtualMachineScaleSets

Offerings: Virtual Machine Scale Sets

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-compute-virtualmachinescalesets-cmk.v1.kql](./dataresidency-replica-compute-virtualmachinescalesets-cmk.v1.kql) | CMK | Find disk encryption sets referenced by virtual machine scale set operating system disks. |
| [dataresidency-replica-compute-virtualmachinescalesets-host-group.v1.kql](./dataresidency-replica-compute-virtualmachinescalesets-host-group.v1.kql) | Host Group | Find dedicated host groups referenced by virtual machine scale sets. |
| [dataresidency-replica-compute-virtualmachinescalesets-ppg.v1.kql](./dataresidency-replica-compute-virtualmachinescalesets-ppg.v1.kql) | Proximity Placement Group | Find proximity placement groups referenced by virtual machine scale sets. |
| [dataresidency-replica-compute-virtualmachinescalesets-user-assigned-managed-identity.v1.kql](./dataresidency-replica-compute-virtualmachinescalesets-user-assigned-managed-identity.v1.kql) | User Assigned Managed Identity | Find user-assigned managed identities attached to virtual machine scale sets. |
| [dataresidency-replica-compute-virtualmachinescalesets-vnet.v1.kql](./dataresidency-replica-compute-virtualmachinescalesets-vnet.v1.kql) | VNet | Find virtual networks referenced by virtual machine scale set network configurations. |

### Microsoft.ContainerInstance/containerGroups

Offerings: Container Instances

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-containerinstance-containergroups-cmk.v1.kql](./dataresidency-replica-containerinstance-containergroups-cmk.v1.kql) | CMK | Find Key Vaults referenced by Container Instances container group encryption settings. |
| [dataresidency-replica-containerinstance-containergroups-log-analytics.v1.kql](./dataresidency-replica-containerinstance-containergroups-log-analytics.v1.kql) | Log Analytics Workspace | Find Log Analytics workspaces referenced by Container Instances diagnostic settings. |

### Microsoft.ContainerRegistry/registries

Offerings: Container Registry

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-containerregistry-registries-key-vault.v1.kql](./dataresidency-replica-containerregistry-registries-key-vault.v1.kql) | Key Vault | Find Key Vaults referenced by Container Registry encryption settings. |
| [dataresidency-replica-containerregistry-registries-private-endpoint.v1.kql](./dataresidency-replica-containerregistry-registries-private-endpoint.v1.kql) | Private Endpoint | Find private endpoints connected to container registries. |
| [dataresidency-replica-containerregistry-registries-replica.v1.kql](./dataresidency-replica-containerregistry-registries-replica.v1.kql) | Replica | Find Container Registry replicas and their parent registries. |

### Microsoft.ContainerRegistry/registries/agentPools

Offerings: Container Registry

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-containerregistry-registries-agentpools-vnet.v1.kql](./dataresidency-replica-containerregistry-registries-agentpools-vnet.v1.kql) | VNet | Find virtual networks referenced by Container Registry agent pools. |

### Microsoft.ContainerService/managedClusters

Offerings: Azure Kubernetes Service (AKS)

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-containerservice-managedclusters-diskencryptionset.v1.kql](./dataresidency-replica-containerservice-managedclusters-diskencryptionset.v1.kql) | Disk Encryption Set | Find disk encryption sets referenced by Azure Kubernetes Service clusters. |
| [dataresidency-replica-containerservice-managedclusters-key-vault.v1.kql](./dataresidency-replica-containerservice-managedclusters-key-vault.v1.kql) | Key Vault | Find Key Vaults referenced by Azure Kubernetes Service key management settings. |
| [dataresidency-replica-containerservice-managedclusters-loganalyticsworkspace.v1.kql](./dataresidency-replica-containerservice-managedclusters-loganalyticsworkspace.v1.kql) | Log Analytics Workspace | Find Log Analytics workspaces referenced by Azure Kubernetes Service monitoring settings. |
| [dataresidency-replica-containerservice-managedclusters-snapshot-source.v1.kql](./dataresidency-replica-containerservice-managedclusters-snapshot-source.v1.kql) | Snapshot Source | Find snapshots referenced when creating Azure Kubernetes Service node pools. |
| [dataresidency-replica-containerservice-managedclusters-vnet.v1.kql](./dataresidency-replica-containerservice-managedclusters-vnet.v1.kql) | VNet | Find virtual networks referenced by Azure Kubernetes Service node pools. |

### Microsoft.Dashboard/grafana

Offerings: Azure Grafana Service

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-dashboard-grafana-azure-monitor-workspace.v1.kql](./dataresidency-replica-dashboard-grafana-azure-monitor-workspace.v1.kql) | Azure Monitor Workspace | Find Azure Monitor workspaces referenced by Azure Managed Grafana integrations. |

### Microsoft.Databricks/workspaces

Offerings: Azure Databricks

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-databricks-workspaces-access-connector.v1.kql](./dataresidency-replica-databricks-workspaces-access-connector.v1.kql) | Access Connector | Find access connectors referenced by Azure Databricks workspaces. |
| [dataresidency-replica-databricks-workspaces-azure-ml-workspace-parameter.v1.kql](./dataresidency-replica-databricks-workspaces-azure-ml-workspace-parameter.v1.kql) | Azure ML Workspace (Parameter) | Find Azure Machine Learning workspaces referenced by Azure Databricks workspace parameters. |
| [dataresidency-replica-databricks-workspaces-cmk.v1.kql](./dataresidency-replica-databricks-workspaces-cmk.v1.kql) | CMK | Find Key Vaults referenced by Azure Databricks managed services encryption settings. |
| [dataresidency-replica-databricks-workspaces-vnet.v1.kql](./dataresidency-replica-databricks-workspaces-vnet.v1.kql) | VNet | Find virtual networks referenced by Azure Databricks workspace parameters. |

### Microsoft.DataFactory/factories

Offerings: Data Factory

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-datafactory-factories-cmk.v1.kql](./dataresidency-replica-datafactory-factories-cmk.v1.kql) | CMK | Find Key Vaults referenced by Data Factory encryption settings. |
| [dataresidency-replica-datafactory-factories-purview-account.v1.kql](./dataresidency-replica-datafactory-factories-purview-account.v1.kql) | Purview Account | Find Microsoft Purview accounts referenced by Data Factory instances. |

### Microsoft.DBforMySQL/flexibleServers

Offerings: Azure Database for MySQL

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-dbformysql-flexibleservers-cmk.v1.kql](./dataresidency-replica-dbformysql-flexibleservers-cmk.v1.kql) | CMK | Find Key Vaults referenced by Azure Database for MySQL flexible server encryption settings. |
| [dataresidency-replica-dbformysql-flexibleservers-privatednszone.v1.kql](./dataresidency-replica-dbformysql-flexibleservers-privatednszone.v1.kql) | Private DNS Zone | Find private DNS zones referenced by Azure Database for MySQL flexible servers. |
| [dataresidency-replica-dbformysql-flexibleservers-replica.v1.kql](./dataresidency-replica-dbformysql-flexibleservers-replica.v1.kql) | Replica | Find Azure Database for MySQL flexible server replicas and their source servers. |
| [dataresidency-replica-dbformysql-flexibleservers-vnet.v1.kql](./dataresidency-replica-dbformysql-flexibleservers-vnet.v1.kql) | VNet | Find virtual networks referenced by Azure Database for MySQL flexible servers. |

### Microsoft.DBforPostgreSQL/flexibleServers

Offerings: Azure Database for PostgreSQL

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-dbforpostgresql-flexibleservers-cmk.v1.kql](./dataresidency-replica-dbforpostgresql-flexibleservers-cmk.v1.kql) | CMK | Find Key Vaults referenced by Azure Database for PostgreSQL flexible server encryption settings. |
| [dataresidency-replica-dbforpostgresql-flexibleservers-privatednszone.v1.kql](./dataresidency-replica-dbforpostgresql-flexibleservers-privatednszone.v1.kql) | Private DNS Zone | Find private DNS zones referenced by Azure Database for PostgreSQL flexible servers. |
| [dataresidency-replica-dbforpostgresql-flexibleservers-replica.v1.kql](./dataresidency-replica-dbforpostgresql-flexibleservers-replica.v1.kql) | Replica | Find Azure Database for PostgreSQL flexible server replicas and their source servers. |
| [dataresidency-replica-dbforpostgresql-flexibleservers-vnet.v1.kql](./dataresidency-replica-dbforpostgresql-flexibleservers-vnet.v1.kql) | VNet | Find virtual networks referenced by Azure Database for PostgreSQL flexible servers. |

### Microsoft.Devices/IotHubs

Offerings: IoT Hub, Azure IoT Edge

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-devices-iothubs-event-hub.v1.kql](./dataresidency-replica-devices-iothubs-event-hub.v1.kql) | Event Hub | Find Event Hubs referenced by IoT Hub message routing endpoints. |
| [dataresidency-replica-devices-iothubs-private-endpoint.v1.kql](./dataresidency-replica-devices-iothubs-private-endpoint.v1.kql) | Private Endpoint | Find private endpoints connected to IoT hubs. |
| [dataresidency-replica-devices-iothubs-replica.v1.kql](./dataresidency-replica-devices-iothubs-replica.v1.kql) | Replica | Find IoT hubs and their disaster recovery secondary locations. |
| [dataresidency-replica-devices-iothubs-service-bus.v1.kql](./dataresidency-replica-devices-iothubs-service-bus.v1.kql) | Service Bus | Find Service Bus namespaces referenced by IoT Hub queue routing endpoints. |
| [dataresidency-replica-devices-iothubs-storage.v1.kql](./dataresidency-replica-devices-iothubs-storage.v1.kql) | Storage Account | Find storage accounts referenced by IoT Hub storage container routing endpoints. |

### Microsoft.Devices/provisioningServices

Offerings: IoT Hub Device Provisioning Service

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-devices-provisioningservices-linked-location.v1.kql](./dataresidency-replica-devices-provisioningservices-linked-location.v1.kql) | Linked Location | Find IoT hubs linked to Device Provisioning Service instances. |

### Microsoft.DeviceUpdate/accounts

Offerings: Device Update for IoT Hub

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-deviceupdate-accounts-cmk.v1.kql](./dataresidency-replica-deviceupdate-accounts-cmk.v1.kql) | CMK | Find Key Vaults referenced by Device Update account encryption settings. |
| [dataresidency-replica-deviceupdate-accounts-linked-iot-hubs.v1.kql](./dataresidency-replica-deviceupdate-accounts-linked-iot-hubs.v1.kql) | Linked IoT Hubs | Find IoT hubs referenced by Device Update account instances. |
| [dataresidency-replica-deviceupdate-accounts-storage-account.v1.kql](./dataresidency-replica-deviceupdate-accounts-storage-account.v1.kql) | Storage Account | Find diagnostic storage accounts referenced by Device Update account instances. |

### Microsoft.DocumentDB/cassandraClusters

Offerings: Azure Managed Instance for Apache Cassandra

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-documentdb-cassandraclusters-vnet.v1.kql](./dataresidency-replica-documentdb-cassandraclusters-vnet.v1.kql) | VNet | Find virtual networks referenced by Azure Managed Instance for Apache Cassandra clusters. |

### Microsoft.DocumentDB/databaseAccounts

Offerings: Azure Cosmos DB

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-documentdb-databaseaccounts-cmk.v1.kql](./dataresidency-replica-documentdb-databaseaccounts-cmk.v1.kql) | CMK | Find Key Vaults referenced by Azure Cosmos DB account encryption settings. |
| [dataresidency-replica-documentdb-databaseaccounts-replica.v1.kql](./dataresidency-replica-documentdb-databaseaccounts-replica.v1.kql) | Replica | Find Azure Cosmos DB accounts and every region the account is deployed to. |
| [dataresidency-replica-documentdb-databaseaccounts-vnet.v1.kql](./dataresidency-replica-documentdb-databaseaccounts-vnet.v1.kql) | VNet | Find virtual networks referenced by Azure Cosmos DB account network rules. |

### Microsoft.ElasticSan/elasticSans

Offerings: Azure Elastic SAN

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-elasticsan-elasticsans-private-endpoint.v1.kql](./dataresidency-replica-elasticsan-elasticsans-private-endpoint.v1.kql) | Private Endpoint | Find private endpoints connected to Elastic SAN volume groups. |
| [dataresidency-replica-elasticsan-elasticsans-vnet.v1.kql](./dataresidency-replica-elasticsan-elasticsans-vnet.v1.kql) | VNet | Find virtual networks referenced by Elastic SAN volume group network rules. |

### Microsoft.ElasticSan/elasticSans/volumeGroups

Offerings: Azure Elastic SAN

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-elasticsan-elasticsans-volumegroups-key-vault.v1.kql](./dataresidency-replica-elasticsan-elasticsans-volumegroups-key-vault.v1.kql) | Key Vault | Find Key Vaults referenced by Elastic SAN volume group encryption settings. |

### Microsoft.EventGrid/systemTopics

Offerings: Event Grid

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-eventgrid-systemtopics-source.v1.kql](./dataresidency-replica-eventgrid-systemtopics-source.v1.kql) | Source | Find source resources referenced by Event Grid system topics. |

### Microsoft.EventHub/namespaces

Offerings: Event Hubs

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-eventhub-namespaces-cmk.v1.kql](./dataresidency-replica-eventhub-namespaces-cmk.v1.kql) | CMK | Find Key Vaults referenced by Event Hubs namespace encryption settings. |
| [dataresidency-replica-eventhub-namespaces-private-endpoint.v1.kql](./dataresidency-replica-eventhub-namespaces-private-endpoint.v1.kql) | Private Endpoint | Find private endpoints connected to Event Hubs namespaces. |
| [dataresidency-replica-eventhub-namespaces-replica.v1.kql](./dataresidency-replica-eventhub-namespaces-replica.v1.kql) | Replica | Find Event Hubs namespaces with geo-replication configured. |

### Microsoft.FluidRelay/fluidRelayServers

Offerings: Fluid Relay Service

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-fluidrelay-fluidrelayservers-cmk.v1.kql](./dataresidency-replica-fluidrelay-fluidrelayservers-cmk.v1.kql) | CMK | Find Key Vaults referenced by Azure Fluid Relay customer-managed encryption settings. |
| [dataresidency-replica-fluidrelay-fluidrelayservers-user-assigned-managed-identity.v1.kql](./dataresidency-replica-fluidrelay-fluidrelayservers-user-assigned-managed-identity.v1.kql) | User Assigned Managed Identity | Find managed identities referenced by Azure Fluid Relay customer-managed encryption settings. |

### Microsoft.HDInsight/clusters

Offerings: HDInsight

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-hdinsight-clusters-cmk.v1.kql](./dataresidency-replica-hdinsight-clusters-cmk.v1.kql) | CMK | Find Key Vaults referenced by HDInsight disk encryption settings. |
| [dataresidency-replica-hdinsight-clusters-storageaccount.v1.kql](./dataresidency-replica-hdinsight-clusters-storageaccount.v1.kql) | Storage Account | Find storage accounts referenced by HDInsight clusters. |
| [dataresidency-replica-hdinsight-clusters-vnet.v1.kql](./dataresidency-replica-hdinsight-clusters-vnet.v1.kql) | VNet | Find virtual networks referenced by HDInsight cluster roles. |

### Microsoft.HealthcareApis/workspaces

Offerings: Azure Health Data Services

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-healthcareapis-workspaces-private-endpoint.v1.kql](./dataresidency-replica-healthcareapis-workspaces-private-endpoint.v1.kql) | Private Endpoint | Find private endpoints connected to Azure Health Data Services workspaces. |

### Microsoft.HealthcareApis/workspaces/dicomServices

Offerings: Azure Health Data Services

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-healthcareapis-workspaces-dicomservices-azure-key-vault.v1.kql](./dataresidency-replica-healthcareapis-workspaces-dicomservices-azure-key-vault.v1.kql) | Key Vault | Find Key Vaults referenced by Azure Health Data Services DICOM service encryption settings. |
| [dataresidency-replica-healthcareapis-workspaces-dicomservices-storage.v1.kql](./dataresidency-replica-healthcareapis-workspaces-dicomservices-storage.v1.kql) | Storage Account | Find storage accounts referenced by Azure Health Data Services DICOM services. |

### Microsoft.Insights/dataCollectionRules

Offerings: Azure Monitor

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-insights-datacollectionrules-la-workspace-telemetry-destination.v1.kql](./dataresidency-replica-insights-datacollectionrules-la-workspace-telemetry-destination.v1.kql) | Log Analytics Workspace | Find Log Analytics workspaces referenced by data collection rule destinations. |

### Microsoft.KeyVault/managedHSMs

Offerings: Azure Key Vault Managed HSM

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-keyvault-managedhsms-replica.v1.kql](./dataresidency-replica-keyvault-managedhsms-replica.v1.kql) | Replica | Find Key Vault Managed HSM pools extended to additional regions. |

### Microsoft.Kusto/clusters

Offerings: Azure Data Explorer

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-kusto-clusters-cmk.v1.kql](./dataresidency-replica-kusto-clusters-cmk.v1.kql) | CMK | Find Key Vaults or Managed HSMs referenced by Azure Data Explorer encryption settings. |

### Microsoft.Kusto/clusters/databases/dataConnections

Offerings: Azure Data Explorer

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-kusto-clusters-databases-dataconnections-iot-hub.v1.kql](./dataresidency-replica-kusto-clusters-databases-dataconnections-iot-hub.v1.kql) | IoT Hub | Find IoT hubs referenced by Azure Data Explorer data connections. |

### Microsoft.LoadTestService/loadTests

Offerings: Azure App Testing

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-loadtestservice-loadtests-key-vault.v1.kql](./dataresidency-replica-loadtestservice-loadtests-key-vault.v1.kql) | Key Vault | Find Key Vaults referenced by Azure Load Testing encryption settings. |
| [dataresidency-replica-loadtestservice-loadtests-user-assigned-managed-identity.v1.kql](./dataresidency-replica-loadtestservice-loadtests-user-assigned-managed-identity.v1.kql) | User Assigned Managed Identity | Find user-assigned managed identities referenced by Azure Load Testing resources. |

### Microsoft.MachineLearningServices/registries

Offerings: Azure Machine Learning

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-machinelearningservices-registries-replica.v1.kql](./dataresidency-replica-machinelearningservices-registries-replica.v1.kql) | Replica | Find Azure Machine Learning registries and the regions they replicate to. |

### Microsoft.MachineLearningServices/workspaces

Offerings: Azure Machine Learning

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-machinelearningservices-workspaces-application-insights.v1.kql](./dataresidency-replica-machinelearningservices-workspaces-application-insights.v1.kql) | Application Insights | Find Application Insights resources referenced by Azure Machine Learning workspaces. |
| [dataresidency-replica-machinelearningservices-workspaces-container-registry.v1.kql](./dataresidency-replica-machinelearningservices-workspaces-container-registry.v1.kql) | Container Registry | Find container registries referenced by Azure Machine Learning workspaces. |
| [dataresidency-replica-machinelearningservices-workspaces-key-vault.v1.kql](./dataresidency-replica-machinelearningservices-workspaces-key-vault.v1.kql) | Key Vault | Find Key Vaults referenced by Azure Machine Learning workspaces. |
| [dataresidency-replica-machinelearningservices-workspaces-storageaccount.v1.kql](./dataresidency-replica-machinelearningservices-workspaces-storageaccount.v1.kql) | Storage Account | Find storage accounts referenced by Azure Machine Learning workspaces. |

### Microsoft.Migrate/migrateProjects

Offerings: Azure Migrate

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-migrate-migrateprojects-storage-accounts.v1.kql](./dataresidency-replica-migrate-migrateprojects-storage-accounts.v1.kql) | Storage Account | Find utility storage accounts referenced by Azure Migrate projects. |

### Microsoft.Monitor/accounts

Offerings: Azure Monitor

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-monitor-accounts-private-endpoint.v1.kql](./dataresidency-replica-monitor-accounts-private-endpoint.v1.kql) | Private Endpoint | Find private endpoints connected to Azure Monitor workspaces. |

### Microsoft.NetApp/netAppAccounts

Offerings: Azure NetApp Files

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-netapp-netappaccounts-cmk.v1.kql](./dataresidency-replica-netapp-netappaccounts-cmk.v1.kql) | CMK | Find Key Vaults or Managed HSMs referenced by Azure NetApp Files account encryption settings. |

### Microsoft.NetApp/netAppAccounts/capacityPools/volumes

Offerings: Azure NetApp Files

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-netapp-netappaccounts-capacitypools-volumes-remote-volume.v1.kql](./dataresidency-replica-netapp-netappaccounts-capacitypools-volumes-remote-volume.v1.kql) | Remote Volume | Find remote volumes referenced by Azure NetApp Files replication settings. |
| [dataresidency-replica-netapp-netappaccounts-capacitypools-volumes-vnet.v1.kql](./dataresidency-replica-netapp-netappaccounts-capacitypools-volumes-vnet.v1.kql) | VNet | Find virtual networks referenced by Azure NetApp Files volumes. |

### Microsoft.Network/applicationGateways

Offerings: Application Gateway

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-network-applicationgateways-key-vault.v1.kql](./dataresidency-replica-network-applicationgateways-key-vault.v1.kql) | Key Vault | Find Key Vaults referenced by Application Gateway certificate settings. |
| [dataresidency-replica-network-applicationgateways-vnet.v1.kql](./dataresidency-replica-network-applicationgateways-vnet.v1.kql) | VNet | Find virtual networks referenced by Application Gateway IP configurations. |
| [dataresidency-replica-network-applicationgateways-webapplicationfirewallpolicies.v1.kql](./dataresidency-replica-network-applicationgateways-webapplicationfirewallpolicies.v1.kql) | Web Application Firewall Policies | Find Web Application Firewall policies referenced by Application Gateways. |

### Microsoft.Network/azureFirewalls

Offerings: Azure Firewall

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-network-azurefirewalls-firewallpolicy.v1.kql](./dataresidency-replica-network-azurefirewalls-firewallpolicy.v1.kql) | Firewall Policy | Find firewall policies referenced by Azure Firewall resources. |
| [dataresidency-replica-network-azurefirewalls-publicipaddress.v1.kql](./dataresidency-replica-network-azurefirewalls-publicipaddress.v1.kql) | Public IP Address | Find public IP addresses referenced by Azure Firewall resources. |
| [dataresidency-replica-network-azurefirewalls-virtualhub.v1.kql](./dataresidency-replica-network-azurefirewalls-virtualhub.v1.kql) | Virtual Hub | Find virtual hubs referenced by Azure Firewall resources. |
| [dataresidency-replica-network-azurefirewalls-vnet.v1.kql](./dataresidency-replica-network-azurefirewalls-vnet.v1.kql) | VNet | Find virtual networks referenced by Azure Firewall resources. |

### Microsoft.Network/bastionHosts

Offerings: Azure Bastion

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-network-bastionhosts-publicipaddress.v1.kql](./dataresidency-replica-network-bastionhosts-publicipaddress.v1.kql) | Public IP Address | Find public IP resources referenced by Azure Bastion IP configurations. |
| [dataresidency-replica-network-bastionhosts-vnet.v1.kql](./dataresidency-replica-network-bastionhosts-vnet.v1.kql) | VNet | Find virtual networks referenced by Azure Bastion IP configurations. |

### Microsoft.Network/loadBalancers

Offerings: Azure Load Balancer

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-network-loadbalancers-backend-nic-ipconfigurations.v1.kql](./dataresidency-replica-network-loadbalancers-backend-nic-ipconfigurations.v1.kql) | Backend NIC IP Configurations | Find resources referenced by load balancer backend network interface IP configurations. |
| [dataresidency-replica-network-loadbalancers-frontend-ip-address.v1.kql](./dataresidency-replica-network-loadbalancers-frontend-ip-address.v1.kql) | Frontend IP Address | Find resources referenced by load balancer frontend IP configurations. |
| [dataresidency-replica-network-loadbalancers-load-balancer-ip-address.v1.kql](./dataresidency-replica-network-loadbalancers-load-balancer-ip-address.v1.kql) | Load Balancer IP Address | Find virtual networks referenced by load balancer backend address entries. |

### Microsoft.Network/natGateways

Offerings: Azure NAT Gateway - Virtual Network NAT

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-network-natgateways-public-ips-prefixes.v1.kql](./dataresidency-replica-network-natgateways-public-ips-prefixes.v1.kql) | Public IPs / Prefixes | Find public IP prefixes referenced by NAT gateways. |
| [dataresidency-replica-network-natgateways-publicipaddress.v1.kql](./dataresidency-replica-network-natgateways-publicipaddress.v1.kql) | Public IP Address | Find public IP addresses referenced by NAT gateways. |

### Microsoft.Network/virtualNetworkGateways

Offerings: VPN Gateway

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-network-virtualnetworkgateways-local-network-gateway-2.v1.kql](./dataresidency-replica-network-virtualnetworkgateways-local-network-gateway-2.v1.kql) | Local Network Gateway | Find local network gateways linked to virtual network gateways through connection resources. |
| [dataresidency-replica-network-virtualnetworkgateways-publicipaddress.v1.kql](./dataresidency-replica-network-virtualnetworkgateways-publicipaddress.v1.kql) | Public IP Address | Find public IP addresses referenced by virtual network gateway IP configurations. |
| [dataresidency-replica-network-virtualnetworkgateways-vnet.v1.kql](./dataresidency-replica-network-virtualnetworkgateways-vnet.v1.kql) | VNet | Find virtual networks referenced by virtual network gateway IP configurations. |

### Microsoft.Network/virtualNetworks

Offerings: Virtual Network

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-network-virtualnetworks-ddos-protection-plan-id.v1.kql](./dataresidency-replica-network-virtualnetworks-ddos-protection-plan-id.v1.kql) | DDoS Protection Plan | Find DDoS protection plans referenced by virtual networks. |
| [dataresidency-replica-network-virtualnetworks-nsg.v1.kql](./dataresidency-replica-network-virtualnetworks-nsg.v1.kql) | NSG | Find network security groups referenced by virtual network subnets. |
| [dataresidency-replica-network-virtualnetworks-peered-vnet.v1.kql](./dataresidency-replica-network-virtualnetworks-peered-vnet.v1.kql) | Peered VNet | Find remote networks referenced by virtual network peerings. |
| [dataresidency-replica-network-virtualnetworks-subnet-nat-gateway.v1.kql](./dataresidency-replica-network-virtualnetworks-subnet-nat-gateway.v1.kql) | Subnet NAT Gateway | Find NAT gateways referenced by virtual network subnets. |
| [dataresidency-replica-network-virtualnetworks-subnet-route-table.v1.kql](./dataresidency-replica-network-virtualnetworks-subnet-route-table.v1.kql) | Subnet Route Table | Find route tables referenced by virtual network subnets. |

### Microsoft.OffAzure/HyperVSites

Offerings: Azure Migrate

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-offazure-hypervsites-key-vault.v1.kql](./dataresidency-replica-offazure-hypervsites-key-vault.v1.kql) | Key Vault | Find Key Vaults referenced by Azure Migrate Hyper-V site agents. |

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
| [dataresidency-replica-offazure-vmwaresites-key-vault.v1.kql](./dataresidency-replica-offazure-vmwaresites-key-vault.v1.kql) | Key Vault | Find Key Vaults referenced by Azure Migrate VMware site agents. |

### Microsoft.OperationalInsights/workspaces

Offerings: Azure Monitor

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-operationalinsights-workspaces-replica.v1.kql](./dataresidency-replica-operationalinsights-workspaces-replica.v1.kql) | Replica | Find Log Analytics workspaces with workspace replication enabled. |

### Microsoft.RecoveryServices/vaults

Offerings: Backup, Site Recovery

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-recoveryservices-vaults-key-vault.v1.kql](./dataresidency-replica-recoveryservices-vaults-key-vault.v1.kql) | Key Vault | Find Key Vaults referenced by Recovery Services vault encryption settings. |

### Microsoft.RedHatOpenShift/openShiftClusters

Offerings: Azure Red Hat OpenShift (ARO)

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-redhatopenshift-openshiftclusters-vnet.v1.kql](./dataresidency-replica-redhatopenshift-openshiftclusters-vnet.v1.kql) | VNet | Find virtual networks referenced by Azure Red Hat OpenShift cluster nodes. |

### Microsoft.Resources/deploymentScripts

Offerings: Azure Resource Manager

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-resources-deploymentscripts-storage-account.v1.kql](./dataresidency-replica-resources-deploymentscripts-storage-account.v1.kql) | Storage Account | Find storage accounts referenced by Azure deployment scripts. |

### Microsoft.Search/searchServices

Offerings: Azure AI Search

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-search-searchservices-privatelinkresource.v1.kql](./dataresidency-replica-search-searchservices-privatelinkresource.v1.kql) | Private Link Resource | Find resources referenced by Azure AI Search shared private link configurations. |

### Microsoft.ServiceBus/namespaces

Offerings: Service Bus

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-servicebus-namespaces-cmk.v1.kql](./dataresidency-replica-servicebus-namespaces-cmk.v1.kql) | CMK | Find Key Vaults referenced by Service Bus namespace encryption settings. |
| [dataresidency-replica-servicebus-namespaces-replica.v1.kql](./dataresidency-replica-servicebus-namespaces-replica.v1.kql) | Replica | Find Service Bus namespaces with geo-replication configured. |

### Microsoft.Solutions/applications

Offerings: Azure Managed Applications

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-solutions-applications-application-definition.v1.kql](./dataresidency-replica-solutions-applications-application-definition.v1.kql) | Application Definition | Find application definitions referenced by Azure managed applications. |

### Microsoft.Sql/managedInstances

Offerings: Azure SQL Managed Instance

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-sql-managedinstances-dns-zone-partner.v1.kql](./dataresidency-replica-sql-managedinstances-dns-zone-partner.v1.kql) | DNS Zone Partner | Find SQL managed instances that share a DNS zone with another managed instance. |
| [dataresidency-replica-sql-managedinstances-instance-pool-id.v1.kql](./dataresidency-replica-sql-managedinstances-instance-pool-id.v1.kql) | Instance Pool | Find instance pools referenced by SQL managed instances. |
| [dataresidency-replica-sql-managedinstances-vnet.v1.kql](./dataresidency-replica-sql-managedinstances-vnet.v1.kql) | VNet | Find virtual networks referenced by SQL managed instances. |

### Microsoft.Sql/servers/databases

Offerings: Azure SQL Database

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-sql-servers-databases-elastic-pool-id.v1.kql](./dataresidency-replica-sql-servers-databases-elastic-pool-id.v1.kql) | Elastic Pool | Find elastic pools referenced by Azure SQL databases. |

### Microsoft.SqlVirtualMachine/sqlVirtualMachines

Offerings: SQL Server on Azure Virtual Machines

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-sqlvirtualmachine-sqlvirtualmachines-underlying-virtual-machine.v1.kql](./dataresidency-replica-sqlvirtualmachine-sqlvirtualmachines-underlying-virtual-machine.v1.kql) | Underlying Virtual Machine | Find Compute virtual machines referenced by SQL virtual machine resources. |
| [dataresidency-replica-sqlvirtualmachine-sqlvirtualmachines-virtual-machine-identity-setting.v1.kql](./dataresidency-replica-sqlvirtualmachine-sqlvirtualmachines-virtual-machine-identity-setting.v1.kql) | Virtual Machine Identity Setting | Find user-assigned managed identities referenced by SQL virtual machine identity settings. |
| [dataresidency-replica-sqlvirtualmachine-sqlvirtualmachines-virtualmachinegroupresource.v1.kql](./dataresidency-replica-sqlvirtualmachine-sqlvirtualmachines-virtualmachinegroupresource.v1.kql) | Virtual Machine Group Resource | Find SQL virtual machine groups referenced by SQL virtual machine resources. |

### Microsoft.Storage/storageAccounts

Offerings: Storage, Archive Storage, Azure Data Lake Storage Gen2, Azure Files, Premium Block Blobs, Queues, Tables

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-autogeo-storage.v1.kql](./dataresidency-autogeo-storage.v1.kql) | Replica | Check whether storage account SKU names indicate geo-redundant replication. |
| [dataresidency-replica-storage-keyvault.v1.kql](./dataresidency-replica-storage-keyvault.v1.kql) | CMK | Find Key Vaults referenced by storage account encryption settings. |
| [dataresidency-replica-storage-vnet.v1.kql](./dataresidency-replica-storage-vnet.v1.kql) | VNet | Find virtual networks referenced by storage account network rules. |

### Microsoft.StorageCache/amlFilesystems

Offerings: Azure Managed Lustre (AMLFS)

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-storagecache-amlfilesystems-cmk.v1.kql](./dataresidency-replica-storagecache-amlfilesystems-cmk.v1.kql) | CMK | Find Key Vaults referenced by Azure Managed Lustre encryption settings. |
| [dataresidency-replica-storagecache-amlfilesystems-file-system-subnet.v1.kql](./dataresidency-replica-storagecache-amlfilesystems-file-system-subnet.v1.kql) | File System Subnet | Find subnets referenced by Azure Managed Lustre file systems. |
| [dataresidency-replica-storagecache-amlfilesystems-hsm-backing-storage.v1.kql](./dataresidency-replica-storagecache-amlfilesystems-hsm-backing-storage.v1.kql) | HSM Backing Storage | Find storage accounts referenced by Azure Managed Lustre storage tiering settings. |

### Microsoft.StorageSync/storageSyncServices

Offerings: Azure File Sync

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-storagesync-storagesyncservices-privateendpoint.v1.kql](./dataresidency-replica-storagesync-storagesyncservices-privateendpoint.v1.kql) | Private Endpoint | Find private endpoints referenced by Storage Sync services. |

### Microsoft.StreamAnalytics/streamingJobs

Offerings: Azure Stream Analytics

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-streamanalytics-streamingjobs-dedicated-cluster.v1.kql](./dataresidency-replica-streamanalytics-streamingjobs-dedicated-cluster.v1.kql) | Dedicated Cluster | Find dedicated clusters referenced by Stream Analytics jobs. |

### Microsoft.Synapse/workspaces

Offerings: Azure Synapse Analytics

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-synapse-workspaces-key-vault.v1.kql](./dataresidency-replica-synapse-workspaces-key-vault.v1.kql) | Key Vault | Find Key Vaults referenced by Azure Synapse workspace encryption settings. |
| [dataresidency-replica-synapse-workspaces-private-endpoint.v1.kql](./dataresidency-replica-synapse-workspaces-private-endpoint.v1.kql) | Private Endpoint | Find private endpoints connected to Azure Synapse workspaces. |
| [dataresidency-replica-synapse-workspaces-purview-account.v1.kql](./dataresidency-replica-synapse-workspaces-purview-account.v1.kql) | Purview Account | Find Microsoft Purview accounts referenced by Azure Synapse workspaces. |
| [dataresidency-replica-synapse-workspaces-storage-account.v1.kql](./dataresidency-replica-synapse-workspaces-storage-account.v1.kql) | Storage Account | Find storage accounts referenced by Azure Synapse default data lake settings. |
| [dataresidency-replica-synapse-workspaces-virtual-network-subnet.v1.kql](./dataresidency-replica-synapse-workspaces-virtual-network-subnet.v1.kql) | VNet Subnet | Find virtual networks referenced by Azure Synapse workspace compute subnet settings. |

### Microsoft.VirtualMachineImages/imageTemplates

Offerings: Azure VM Image Builder

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-virtualmachineimages-imagetemplates-source-image-id.v1.kql](./dataresidency-replica-virtualmachineimages-imagetemplates-source-image-id.v1.kql) | Source Image | Find managed images referenced as sources by Azure VM Image Builder templates. |

### Microsoft.Web/sites

Offerings: App Service, Functions, Logic Apps

| Query | Linked Resource | Description |
| --- | --- | --- |
| [dataresidency-replica-web-app-service-environment.v1.kql](./dataresidency-replica-web-app-service-environment.v1.kql) | App Service Environment | Find App Service Environments referenced by web apps. |
| [dataresidency-replica-web-serverfarm.v1.kql](./dataresidency-replica-web-serverfarm.v1.kql) | Server Farms | Find App Service plans referenced by web apps. |
| [dataresidency-replica-web-vnet.v1.kql](./dataresidency-replica-web-vnet.v1.kql) | VNet | Find virtual networks referenced by web app virtual network integration settings. |

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
