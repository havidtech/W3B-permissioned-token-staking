//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;


import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


contract BoredApeToken is ERC20, Ownable {

    using SafeMath for uint256;
    uint private immutable maxSupply;
    uint private immutable tokenPerGwei;
    uint private constant ETHER_TO_GWEI = 1000000000000000;


    constructor () ERC20("BoredApeToken", "BRT"){
        maxSupply = 1000000 * 10 ** decimals();
        tokenPerGwei = 1000 * 10 ** decimals();
        _mint(msg.sender, 10000);
    }

    function buyToken(address reciever) public payable {
        require(valueIsWholeNumberGwei(msg.value), "value must be a whole number of Gwei" );
        uint amount = valueToToken(msg.value);
        require(maxSupplyNotReached(amount), "Total Supply limit Reached");
        _mint(reciever, amount);

        // Withdraw
         (bool sent, bytes memory data) = payable(owner()).call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }

    function valueIsWholeNumberGwei(uint value) internal pure returns(bool) {
        return value % ETHER_TO_GWEI == 0;
    }

    function valueToToken(uint value) internal view returns (uint) {
        return (value / ETHER_TO_GWEI) * tokenPerGwei;
    }

    function maxSupplyNotReached(uint amount) internal view returns (bool) {
        return amount + totalSupply() <= maxSupply;
    }
}