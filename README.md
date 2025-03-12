# Blockchain-Based Medical Supply Chain

A decentralized solution for tracking, verifying, and securing the medical supply chain from manufacturer to patient.

## Overview

This blockchain platform provides end-to-end visibility and trust for medical supplies by leveraging smart contracts to track product registration, monitor storage conditions, verify authenticity, and manage expiration dates.

## Core Smart Contracts

### Product Registration Contract
- Registers new medical products on the blockchain
- Records manufacturing details, batch numbers, and product specifications
- Creates a unique digital identity for each product
- Tracks chain of custody throughout the supply chain

### Temperature Monitoring Contract
- Connects with IoT sensors to continuously monitor storage conditions
- Records temperature data at configurable intervals
- Triggers alerts when conditions fall outside acceptable parameters
- Provides immutable temperature history for compliance and quality assurance

### Authenticity Verification Contract
- Validates the legitimacy of medical products
- Prevents counterfeit products from entering the supply chain
- Enables stakeholders to verify product authenticity via QR codes or NFC tags
- Maintains a cryptographic proof of product provenance

### Expiration Tracking Contract
- Manages inventory based on product shelf life
- Provides alerts for approaching expiration dates
- Enables FEFO (First Expired, First Out) inventory management
- Reduces waste and ensures patient safety

## Benefits

- **Enhanced Traceability**: Track medical supplies from manufacture to use
- **Quality Assurance**: Ensure proper storage conditions throughout the supply chain
- **Counterfeiting Prevention**: Verify product authenticity with cryptographic proof
- **Regulatory Compliance**: Maintain immutable records for auditing and compliance
- **Improved Inventory Management**: Reduce waste through expiration tracking
- **Supply Chain Efficiency**: Streamline processes and reduce paperwork
- **Patient Safety**: Ensure patients receive genuine products stored appropriately

## Getting Started

### Prerequisites
- Node.js (v16.0+)
- Truffle Suite
- Ganache or access to an Ethereum test network
- Web3.js
- Solidity compiler (v0.8.0+)

### Installation
1. Clone the repository
   ```
   git clone https://github.com/your-organization/medical-supply-chain.git
   cd medical-supply-chain
   ```

2. Install dependencies
   ```
   npm install
   ```

3. Compile smart contracts
   ```
   truffle compile
   ```

4. Deploy to test network
   ```
   truffle migrate --network development
   ```

### Running Tests
```
truffle test
```

## Usage Examples

### Registering a New Product
```javascript
const productRegistration = await ProductRegistration.deployed();
await productRegistration.registerProduct(
  "Insulin-A23", // Product name
  "MED12345",    // SKU
  "Batch-789",   // Batch number
  1615448400,    // Manufacturing timestamp
  1646984400,    // Expiration timestamp
  "Manufacturer Inc.", // Manufacturer name
  { from: manufacturerAccount }
);
```

### Recording Temperature Data
```javascript
const tempMonitor = await TemperatureMonitoring.deployed();
await tempMonitor.recordTemperature(
  "Batch-789",  // Batch ID
  "TRAN-456",   // Transport ID
  4.2,          // Temperature in Celsius
  1615538400,   // Timestamp
  { from: transporterAccount }
);
```

### Verifying Product Authenticity
```javascript
const authenticity = await AuthenticityVerification.deployed();
const isAuthentic = await authenticity.verifyProduct(
  "MED12345",   // SKU
  "Batch-789",  // Batch number
  { from: distributorAccount }
);
console.log("Product is authentic:", isAuthentic);
```

### Checking Expiration Status
```javascript
const expirationTracker = await ExpirationTracking.deployed();
const daysUntilExpiration = await expirationTracker.getDaysUntilExpiration(
  "MED12345",   // SKU
  "Batch-789",  // Batch number
  { from: pharmacyAccount }
);
console.log("Days until expiration:", daysUntilExpiration.toString());
```

## Architecture

The system consists of four main smart contracts deployed on the Ethereum blockchain:

1. **ProductRegistration.sol**: Handles the registration and tracking of products
2. **TemperatureMonitoring.sol**: Records and verifies temperature conditions
3. **AuthenticityVerification.sol**: Manages product verification processes
4. **ExpirationTracking.sol**: Tracks expiration dates and alerts

These contracts interact with a front-end application and potentially IoT devices for temperature monitoring.

## Security Considerations

- All contracts implement role-based access control
- Critical functions require multi-signature authorization
- Data encryption for sensitive information
- Regular security audits recommended
- Emergency pause functionality for critical issues

## Roadmap

- Mobile application for easy scanning and verification
- Integration with existing ERP systems
- Machine learning for predictive analytics
- Support for additional compliance frameworks
- Cold-chain specific features

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Contact

For questions and support, please contact the development team at support@medical-supply-chain.example.com.
