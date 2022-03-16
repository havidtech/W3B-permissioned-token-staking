//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";


interface IBoredApeToken {
    function decimals() external view returns (uint8);
    function balanceOf(address _owner) external view returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);
}

interface IBoredApeYachtClub {
    function balanceOf(address _owner) external view returns (uint256);
}

contract BoredApeTokenStaker {

    using SafeMath for uint256;

    mapping(address => uint) private stake;
    mapping(address => uint) private timeOfStake;

    address private immutable brtAddress;
    address private immutable baycAddress;
    uint private immutable roiRate;
    uint private immutable roiPeriod;
    uint private immutable minimumVestingPeriod;

    constructor(address _brtAddress, address _baycAddress, uint _roiRate, uint _roiPeriod, uint _minimumVestingPeriod){
        brtAddress = _brtAddress;
        baycAddress = _baycAddress;
        roiRate = _roiRate;
        roiPeriod = _roiPeriod;
        minimumVestingPeriod = _minimumVestingPeriod;
    }

    function stakeToken(uint _value) public returns (bool){
        // Require that msg.sender should not have a running stake
        // Require that msg.sender has BAYC NFT
        // Require sufficient allowance
        // Require _value to be a multiple of the roiRate
        // Stake a token
    }

    function withdrawStake() public returns (bool) {
        // Require this contract has sufficient balance. 
        // Bankcruptcy can happen here.
        // Require that msg.sender has some stakes
        // Reset vesting time.
    }

    function withdrawProfit() public returns (bool) {
        // Require minimum vesting time
        // Reset vesting time.
    }

}