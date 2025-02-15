// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MemeToken is ERC20 {
    address public owner;
    uint256 public constant MAX_TOTAL_SUPPLY = 10_000_000;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        owner = msg.sender;
    }

    function mint(address to, uint256 amount) public {
        require(msg.sender == owner, "Only owner can mint");
        require(
            totalSupply() + amount <= MAX_TOTAL_SUPPLY,
            "Max supply exceeded"
        );
        _mint(to, amount);
    }
}
