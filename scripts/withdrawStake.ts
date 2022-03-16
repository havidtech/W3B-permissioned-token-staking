/* eslint-disable node/no-missing-import */
/* eslint-disable no-undef */
import { ethers } from "hardhat";
import { baycHolder, BRTStakerTokenAddress } from "../sampleData";
import { BoredApeTokenStaker } from "../typechain";

async function withdrawStake() {
  const tokenAddress = BRTStakerTokenAddress;
  const token = (await ethers.getContractAt(
    "BoredApeTokenStaker",
    tokenAddress
  )) as BoredApeTokenStaker;

  // Adjust the timestamp - code coming soon

  // Carry out the impersonation
  // @ts-ignore
  await hre.network.provider.request({
    method: "hardhat_impersonateAccount",
    params: [baycHolder],
  });

  // Call Get Signer
  const signer = await ethers.getSigner(baycHolder);

  // Approve Spender
  await token.connect(signer).withdrawStake();
}

withdrawStake().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
