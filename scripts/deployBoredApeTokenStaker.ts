/* eslint-disable node/no-missing-import */
/* eslint-disable no-undef */
import { ethers } from "hardhat";
import { BRTTokenAddress } from "../sampleData";

async function deployBoredApeTokenStaker() {
  // We get the contract to deploy
  const BoredApeTokenStaker = await ethers.getContractFactory(
    "BoredApeTokenStaker"
  );
  const boredApeTokenStaker = await BoredApeTokenStaker.deploy(BRTTokenAddress);

  await boredApeTokenStaker.deployed();

  console.log("BoredApeTokenStaker deployed to:", boredApeTokenStaker.address);
}

deployBoredApeTokenStaker().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
