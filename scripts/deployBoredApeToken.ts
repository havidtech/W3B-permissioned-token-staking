/* eslint-disable node/no-missing-import */
/* eslint-disable no-undef */
import { ethers } from "hardhat";

async function deployBoredApeToken() {
  // We get the contract to deploy
  const BoredApeToken = await ethers.getContractFactory("BoredApeToken");
  const boredApeToken = await BoredApeToken.deploy();

  await boredApeToken.deployed();

  console.log("BoredApeToken deployed to:", boredApeToken.address);
}

deployBoredApeToken().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
