// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
  uint256 public number;
  uint256 public price;

  // owner f=of transaction
  address public owner;

  constructor() {
    owner = msg.sender;
  }

  function setPrice(uint256 _price) public {
    require(msg.sender == owner, "Only owner can change price");
    price = _price;
  }

  function setNumber(uint256 newNumber) public {
    number = newNumber;
  }

  function increment() public {
    number++;
  }
}
