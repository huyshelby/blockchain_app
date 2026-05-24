import { network } from "hardhat";

const { viem, networkName } = await network.connect();

console.log(`Deploying Marketplace to ${networkName}...`);

const marketplace = await viem.deployContract("Marketplace");

console.log("Marketplace address:", marketplace.address);
