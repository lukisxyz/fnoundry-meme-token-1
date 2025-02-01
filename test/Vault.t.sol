
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/Vault.sol";
import {TokenRupiah} from "../src/TokenRupiah.sol";

contract VaultTest is Test {
  TokenRupiah public tokenRupiah;
  Vault public vault;
  uint256 public constant SUPPLY_WILL_EXCEEDED = 10_001;

  address public alice = makeAddr("alice");
  address public bob = makeAddr("bob");
  address public carol = makeAddr("carol");
  address public david = makeAddr("david");

  function setUp() public {
    tokenRupiah = new TokenRupiah();
    vault = new Vault(address(tokenRupiah));
    tokenRupiah.mint(address(alice), 6_000_000e6);
    tokenRupiah.mint(address(bob), 6_000_000e6);
    tokenRupiah.mint(address(carol), 6_000_000e6);
    tokenRupiah.mint(address(david), 6_000_000e6);
    tokenRupiah.mint(address(this), 6_000_000e6);
  }

  function test_Deposit_Amount_Should_Not_Zero() public {
    vm.expectRevert(Vault.AmountCannotBeZero.selector);
    vault.deposit(0);
  }

  function test_Withdraw_Shares_Cannot_More_Than_Balance() public {
    vm.startPrank(alice);
    tokenRupiah.approve(address(vault), 1_000_000e6);
    vault.deposit(1_000_000e6);
    vm.stopPrank();

    vm.startPrank(bob);
    tokenRupiah.approve(address(vault), 1_000_000e6);
    vault.deposit(1_000_000e6);
    vm.stopPrank();

    vm.startPrank(alice);
    vm.expectRevert(Vault.SharedCannotBeMoreThanBalance.selector);
    vault.withdraw(2_000_000e6);
    console.log("alice balance: ", tokenRupiah.balanceOf(alice));
  }

  function test_Scenario_1() public {
    vm.startPrank(alice);
    tokenRupiah.approve(address(vault), 1_000_000e6);
    vault.deposit(1_000_000e6);
    vm.stopPrank();

    vm.startPrank(bob);
    tokenRupiah.approve(address(vault), 1_000_000e6);
    vault.deposit(1_000_000e6);
    vm.stopPrank();

    tokenRupiah.approve(address(vault), 1_000_000e6);
    vault.distributeYield(1_000_000e6);

    uint256 aliceBalanceBefore = tokenRupiah.balanceOf(alice);
    console.log("alice balance before:", aliceBalanceBefore);

    vm.startPrank(alice);
    uint256 aliceShares = vault.balanceOf(alice);
    vault.withdraw(aliceShares);
    vm.stopPrank();

    uint256 aliceBalanceAfter = tokenRupiah.balanceOf(alice);
    console.log("alice balance after: ", aliceBalanceAfter);

    vm.startPrank(carol);
    tokenRupiah.approve(address(vault), 2_000_000e6);
    vault.deposit(2_000_000e6);
    vm.stopPrank();
    tokenRupiah.approve(address(vault), 2_000_000e6);
    vault.distributeYield(2_000_000e6);
  }
}
