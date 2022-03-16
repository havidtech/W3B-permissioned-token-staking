/* eslint-disable node/no-missing-import */
/* eslint-disable no-undef */
import { ethers } from "hardhat";
import {
  baycHolder,
  BRTStakerTokenAddress,
  BRTTokenAddress,
} from "../sampleData";
import { IBoredApeToken } from "../typechain";

async function addLiquidity() {
  const token = (await ethers.getContractAt(
    "IBoredApeToken",
    BRTTokenAddress
  )) as IBoredApeToken;

  await token.transfer(
    BRTStakerTokenAddress,
    1000 * 10 ** (await token.decimals())
  );

  await token.transfer(baycHolder, 30 * 10 ** (await token.decimals()));
}

addLiquidity().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
