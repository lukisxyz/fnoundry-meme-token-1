// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";


contract Vault is ERC20 {
  error AmountCannotBeZero();
  error SharedCannotBeMoreThanBalance();

  address public assetToken;
  address public owner;

  constructor(address _assetToken) ERC20("Deposito Vault", "DEPO") {
    assetToken = _assetToken;
    owner = msg.sender;
  }

  function deposit(uint256 amount) external {
    if (amount == 0) revert AmountCannotBeZero();

    uint256 shares = 0;

    // shares yang akan diperoleh = ( deposit * total shares ) / titak assets
    uint256 totalAssets = IERC20(assetToken).balanceOf(address(this));

    // check supply
    if (totalSupply() == 0) {
      shares = amount;
    } else {
      shares = (amount * totalSupply() / totalAssets);
    }

    _mint(msg.sender, shares);
    IERC20(assetToken).transferFrom(msg.sender, address(this), amount);
  }

  function withdraw(uint256 shares) external {
    if (shares > balanceOf(msg.sender) || balanceOf(msg.sender) == 0) revert SharedCannotBeMoreThanBalance();

    uint256 totalAssets = IERC20(assetToken).balanceOf(address(this));
    uint256 amount = (shares * totalAssets / totalSupply());

    _burn(msg.sender, shares);
    IERC20(assetToken).transfer(msg.sender, amount);
  }

  function distributeYield(uint256 amount) public {
    require(msg.sender == owner, "Only owner can distribute yield");
    IERC20(assetToken).transferFrom(msg.sender, address(this), amount);
  }
}
