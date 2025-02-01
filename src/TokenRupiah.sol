// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenRupiah is ERC20 {
  address public owner;
  uint256 public constant MAX_TOTAL_SUPPLAY = 10_000;

  constructor() ERC20("TOKEN RUPIAH", "IDRT") {
    owner = msg.sender;
  }

  function mint(address to, uint256 amount) public {    // mint to address
    _mint(to, amount);
  }
}
