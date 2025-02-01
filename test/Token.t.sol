// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Token} from "../src/Token.sol";

contract TokenTest is Test {
  Token public token;
  uint256 public constant SUPPLY_WILL_EXCEEDED = 10_001;

  function setUp() public {
    token = new Token();
  }

  function test_Balance() public {
    token.mint(address(this), 1000);
    assertEq(token.balanceOf(address(this)), 1000, "balance should be 1000");
  }

  function test_Mint() public {
    token.mint(address(this), 1000);
    assertEq(token.balanceOf(address(this)), 1000, "balance should be 1000");
  }

  function test_MintMaxSUpply() public {
    vm.expectRevert("Max supply exceeded");
    token.mint(address(this), SUPPLY_WILL_EXCEEDED);
  }
}
