# Smart Contract Audit

## Protocol Description

Allows borrowers to provide collateral and borrow against it. Lenders create pools and set the rules for borrowing.

Possible Areas for bugs:
- Lenders can set pool parameters at any time. Possibly changing parameters in a way that benefits them unfairly.
- Refinancing a loan and moving it to another pool might be prone to exploits.
- Auctioning a loan might unfairly impact the borrower.

## Issues found

1. Hardcoded swap router address in Fees.sol

```solidity
    ISwapRouter public constant swapRouter =
        ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
```

This should be configurable by the owner instead of hardcoding the address.

2. Swap can only happen on Uniswap v3 pools with fee tier of 0.3%

```solidity
    ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
        .ExactInputSingleParams({
            tokenIn: _profits,
            tokenOut: WETH,
            fee: 3000,
            ....
```

This will results in significantly suboptimal trades.

3. 