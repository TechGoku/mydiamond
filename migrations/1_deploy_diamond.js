const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    // Deploy DiamondCut Facet
    const DiamondCutFacet = await ethers.getContractFactory("DiamondCutFacet");
    const diamondCutFacet = await DiamondCutFacet.deploy();
    await diamondCutFacet.deployed();
    console.log("DiamondCutFacet deployed to:", diamondCutFacet.address);

    // Deploy facets
    const LouiceAccountFacet = await ethers.getContractFactory("LouiceAccountFacet");
    const louiceAccountFacet = await LouiceAccountFacet.deploy();
    await louiceAccountFacet.deployed();
    console.log("LouiceAccountFacet deployed to:", louiceAccountFacet.address);

    const SignatureValidatorFacet = await ethers.getContractFactory("SignatureValidatorFacet");
    const signatureValidatorFacet = await SignatureValidatorFacet.deploy();
    await signatureValidatorFacet.deployed();
    console.log("SignatureValidatorFacet deployed to:", signatureValidatorFacet.address);

    const TokenCallbackHandlerFacet = await ethers.getContractFactory("TokenCallbackHandlerFacet");
    const tokenCallbackHandlerFacet = await TokenCallbackHandlerFacet.deploy();
    await tokenCallbackHandlerFacet.deployed();
    console.log("TokenCallbackHandlerFacet deployed to:", tokenCallbackHandlerFacet.address);

    // Deploy Diamond (using DiamondCut facet to link all facets)
    const Diamond = await ethers.getContractFactory("Diamond");
    const diamond = await Diamond.deploy(diamondCutFacet.address);
    await diamond.deployed();
    console.log("Diamond deployed to:", diamond.address);
    
    // Additional logic to initialize facets if needed, such as setting up the entry point or verifier
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
