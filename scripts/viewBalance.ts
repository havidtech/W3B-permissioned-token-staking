/* eslint-disable no-unused-vars */
/* eslint-disable node/no-missing-import */
import { ethers } from "hardhat";
import { baycHolder, BRTTokenAddress } from "../sampleData";

async function viewBalance() {
  const tokenAddress = BRTTokenAddress;
  const owner = baycHolder;
  const token = await ethers.getContractAt("BoredApeToken", tokenAddress);

  console.log(await token.balanceOf(baycHolder));
}

viewBalance().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
