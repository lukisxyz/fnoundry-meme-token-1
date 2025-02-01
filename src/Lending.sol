
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

interface IAavePool {
  function supply(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;
  function borrow(address asset, uint256 amount, uint256 interestRateMode, uint16 referralCode, address onBehalfOf) external;
}

interface ISwapRouter {
      struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);
}

contract Lending {
  address public router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
  address public pool = 0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2;
  address public usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
  address public wbtc = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;

  function supplyAndBorrow(uint256 amountSupply, uint256 amountBorrow) public {
    // transfer dari user ke contract
    IERC20(wbtc).transferFrom(msg.sender,address(this),amountSupply);
    IERC20(wbtc).approve(pool,amountSupply);

    // supply
    IAavePool(pool).supply(wbtc,amountSupply,address(this),0);

    // borrow
    IAavePool(pool).borrow(usdc,amountBorrow,2,0,address(this));

    // transfer USDC ke msg.sender
    IERC20(usdc).transfer(msg.sender,amountBorrow);
  }

  function leverage(uint256 amountSupply, uint256 amountBorrow) public {
    // transfer dari user ke contract
    IERC20(wbtc).transferFrom(msg.sender,address(this),amountSupply);
    IERC20(wbtc).approve(pool,amountSupply);

    // supply
    IAavePool(pool).supply(wbtc,amountSupply,address(this),0);

    // borrow
    IAavePool(pool).borrow(usdc,amountBorrow,2,0,address(this));

    // swap with 
    ISwapRouter.ExactInputSingleParams memory params =
      ISwapRouter.ExactInputSingleParams({
        tokenIn: usdc,
        tokenOut: wbtc,
        fee: 3_000, // 0.3% -> 1_000_000 is 100%
        recipient: address(this),
        deadline: block.timestamp,
        amountIn: amountBorrow,
        amountOutMinimum: 0,
        sqrtPriceLimitX96: 0
      });

    IERC20(usdc).approve(router, amountBorrow); 
    ISwapRouter(router).exactInputSingle(params);

    // supply WBTC ke Aave
    uint256 wbtcBalance = IERC20(wbtc).balanceOf(address(this));
    IERC20(wbtc).approve(pool,wbtcBalance);
    IAavePool(pool).supply(wbtc,wbtcBalance,address(this),0);
  }
}
