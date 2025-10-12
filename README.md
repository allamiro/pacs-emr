# PACS-EMR Integration Ecosystem

A fully interoperable clinical imaging ecosystem that connects Electronic Medical Record (OpenEMR) to Picture Archiving and Communication System (DCM4CHEE PACS), using Mirth Connect as the integration engine and OHIF Viewer as the imaging viewer.

## 🏥 Architecture Overview

This project replicates the **EMR ↔ RIS ↔ PACS** workflow pattern used in real hospitals:

- **OpenEMR** = Electronic Medical Record (Clinical context)
- **Mirth Connect** = Radiology Information System/Integration Engine (HL7 routing)
- **DCM4CHEE** = Picture Archiving and Communication System (Imaging archive)
- **OHIF Viewer** = Web-based DICOM viewer (Clinician interface)

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- 8GB+ RAM recommended
- Ports 389, 3000, 5432, 8080, 8081, 8300, 8443, 9990, 11112, 11113 available

### Launch the Stack

```bash
# Clone and navigate to project
cd pacs-emr

# Start all services
docker-compose up -d

# Check service health
docker-compose ps
```

### Service Access URLs

| Service | URL | Credentials |
|---------|-----|-------------|
| **OpenEMR** | http://localhost:8300 | admin / pass |
| **DCM4CHEE PACS** | http://localhost:8080/dcm4chee-arc/ui2 | admin / admin |
| **Mirth Connect** | https://localhost:8443 | admin / admin |
| **OHIF Viewer** | http://localhost:3000 | - |
| **LDAP Admin** | ldap://localhost:389 | cn=admin,dc=dcm4che,dc=org / secret |

## 📋 Services Overview

### Core Services

#### 🏥 OpenEMR (Electronic Medical Record)
- **Image**: `openemr/openemr:7.0.3`
- **Port**: 8300
- **Database**: MariaDB 11.8
- **Purpose**: Patient management, clinical workflows, imaging orders

#### 🔄 Mirth Connect (Integration Engine)
- **Image**: `nextgenhealthcare/connect:4.5.2`
- **Ports**: 8081 (HTTP), 8443 (HTTPS), 11113 (HL7)
- **Database**: PostgreSQL 15
- **Purpose**: HL7 message routing, data transformation

#### 🗄️ DCM4CHEE PACS (Imaging Archive)
- **Image**: `dcm4che/dcm4chee-arc-psql:5.34.2`
- **Ports**: 8080 (Web), 9990 (Admin), 11112 (DICOM), 2575 (HL7)
- **Database**: PostgreSQL 17.4
- **Purpose**: DICOM image storage, worklist management

#### 👁️ OHIF Viewer (Image Viewer)
- **Image**: `ohif/app:v3.8.0`
- **Port**: 3000
- **Purpose**: Web-based DICOM image viewing

### Supporting Services

#### 📁 LDAP Directory
- **Image**: `dcm4che/slapd-dcm4chee:2.6.8-34.1`
- **Port**: 389
- **Purpose**: User authentication for DCM4CHEE

#### 🗃️ Databases
- **PACS DB**: PostgreSQL 17.4 (port 5432)
- **Mirth DB**: PostgreSQL 15 (internal)
- **OpenEMR DB**: MariaDB 11.8 (internal)

## 🔧 Configuration

### Environment Variables

Key settings in `.env` file:

```bash
# Versions
OEMR_TAG=7.0.3
MIRTH_TAG=4.5.2
ARC_TAG=5.34.2
OHIF_TAG=v3.8.0

# DCM4CHEE PACS
AE_TITLE=DCM4CHEE
ARCHIVE_DEVICE_NAME=dcm4chee-arc

# Database Credentials
POSTGRES_USER=pacs
POSTGRES_PASSWORD=pacs
MIRTH_DB_USER=mirthdb
OEMR_DB_USER=openemr
```

### Custom Configurations

- **OHIF Config**: `config/ohif-config.js` - DICOM Web endpoints
- **OpenEMR Menu**: `openemr/custom_menus/patient_menus/pacs.json` - Imaging menu integration

## 🔗 Integration Workflow

### Current Setup
1. **OpenEMR** provides clinical context and patient management
2. **Custom menu** in OpenEMR links to OHIF viewer
3. **OHIF viewer** connects to DCM4CHEE via DICOM Web APIs
4. **DCM4CHEE** stores and serves DICOM images
5. **Mirth Connect** ready for HL7 message processing

### Planned HL7 Integration
- **ORM messages**: Imaging orders from OpenEMR → Mirth → DCM4CHEE
- **ORU messages**: Results from DCM4CHEE → Mirth → OpenEMR
- **Patient matching**: Correlate EMR patients with PACS studies

## 🛠️ Development

### Adding HL7 Channels

1. Access Mirth Connect at https://localhost:8443
2. Create channels for:
   - OpenEMR → PACS orders (ORM)
   - PACS → OpenEMR results (ORU)
   - Patient demographics sync (ADT)

### Testing DICOM Connectivity

```bash
# Test DICOM echo to DCM4CHEE
dcmecho -c DCM4CHEE@localhost:11112

# Send test DICOM file
dcmsend -c DCM4CHEE@localhost:11112 test.dcm
```

### Viewing Logs

```bash
# View all service logs
docker-compose logs -f

# View specific service
docker-compose logs -f mirth
docker-compose logs -f arc
```

## 📊 Monitoring

### Health Checks
All services include health checks:
- **OpenEMR**: HTTP endpoint check
- **DCM4CHEE**: Web UI availability
- **Mirth**: HTTPS endpoint check
- **OHIF**: HTTP endpoint check
- **Databases**: Connection tests

### Volume Persistence
- `pacs-db`: PACS database data
- `pacs-storage`: DICOM image files
- `mirth-appdata`: Mirth configuration
- `oemr-sites`: OpenEMR site data

## 🔒 Security Considerations

### Production Deployment
- Change default passwords in `.env`
- Use Docker secrets for sensitive data
- Configure proper SSL certificates
- Implement network segmentation
- Enable audit logging

### Default Credentials (Change in Production!)
- OpenEMR: admin/pass
- DCM4CHEE: admin/admin
- Mirth: admin/admin
- LDAP: secret

## 🐛 Troubleshooting

### Common Issues

1. **Port conflicts**: Ensure all ports are available
2. **Memory issues**: Increase Docker memory limit (8GB+)
3. **Database startup**: Wait for health checks to pass
4. **DICOM connectivity**: Check firewall settings

### Service Dependencies
```
ldap + db → arc → ohif
mirth-db → mirth
openemr-db → openemr
```

## 📚 Documentation

- [OpenEMR Documentation](https://www.open-emr.org/wiki/index.php/OpenEMR_Wiki)
- [DCM4CHEE Documentation](https://github.com/dcm4che/dcm4chee-arc-light/wiki)
- [Mirth Connect Documentation](https://www.nextgen.com/products-and-services/integration-engine)
- [OHIF Viewer Documentation](https://docs.ohif.org/)

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions welcome! Please read the contributing guidelines and submit pull requests.

---

**Note**: This is a development/testing environment. For production use, implement proper security measures, monitoring, and backup strategies.
