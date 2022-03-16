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

    mapping(address => uint) private stakes;
    mapping(address => uint) private timeOfStake;

    IBoredApeToken private immutable brtToken;
    IBoredApeYachtClub private constant baycToken = IBoredApeYachtClub(0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D);
    uint private constant ROI_FACTOR = 10;
    uint private constant ROI_PERIOD = 30 days;
    uint private constant MIN_VESTING_PERIOD = 3 days;

    constructor(address _brtAddress){
        brtToken = IBoredApeToken(_brtAddress);
    }

    function stakeToken(uint toStake) public returns (bool){
        require(stakes[msg.sender] == 0, "You already have a stake");
        require(baycToken.balanceOf(msg.sender) > 0, "You must have BAYC NFT");
        require(toStake % (MIN_VESTING_PERIOD * ROI_FACTOR) == 0, "stake should be divisible by MIN_VESTING PERIOD * ROI_FACTOR");
        require(brtToken.balanceOf(msg.sender) >= toStake, "Insufficient BRT" );
        require(brtToken.allowance(msg.sender, address(this)) >= toStake, "You haven't approved us");
        
        // Stake token
        brtToken.transferFrom(msg.sender, address(this), toStake);
        stakes[msg.sender] = toStake;
        timeOfStake[msg.sender] = block.timestamp;

        return true;
    }

    function withdrawStake() public returns (bool) {
        uint _stakes = stakes[msg.sender];
        require(_stakes > 0, "You have no stake");
        require(brtToken.balanceOf(address(this)) >= _stakes, "Servie Downtime. Try later" );
        stakes[msg.sender] = 0; 
        brtToken.transfer(msg.sender, _stakes + computeROI(msg.sender));
    }

    function withdrawProfit() public returns (bool) {
        uint _stakes = stakes[msg.sender];
        require(_stakes > 0, "You have no stake");

        uint roi = computeROI(msg.sender);
        require(roi > 0, "You have no returns now");

        require(brtToken.balanceOf(address(this)) >= roi, "Servie Downtime. Try later" );
        timeOfStake[msg.sender] = block.timestamp;
        brtToken.transfer(msg.sender, roi);

        return true;
    }

    function computeROI(address staker) internal view returns (uint) {
        uint daysOfStake = (block.timestamp - timeOfStake[staker]) / 1 days;
        if(daysOfStake < MIN_VESTING_PERIOD){
            return 0;
        }

        return (stakes[staker] / ( ROI_FACTOR * ROI_PERIOD ) ) * daysOfStake;
    }

    function resetTimeOfStake(address staker) internal {
        timeOfStake[staker] = block.timestamp;
    }

}