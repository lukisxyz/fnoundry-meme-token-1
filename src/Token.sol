// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
  address public owner;
  uint256 public constant MAX_TOTAL_SUPPLAY = 10_000;

  constructor() ERC20("BERGIZI", "BGZ") {
    owner = msg.sender;
  }

  function mint(address to, uint256 amount) public {
    // must owner
    require(msg.sender == owner, "Only owner can mint");

    // supply not overflow
    require(totalSupply() + amount <= MAX_TOTAL_SUPPLAY, "Max supply exceeded");

    // mint to address
    _mint(to, amount);
  }
}
