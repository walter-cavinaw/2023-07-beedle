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

2. Swap amounts do not get approved before swap in Fees.sol. This will lock collateral tokens in the contract.

3. Swap can only happen on Uniswap v3 pools with fee tier of 0.3%

```solidity
    ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
        .ExactInputSingleParams({
            tokenIn: _profits,
            tokenOut: WETH,
            fee: 3000,
            ....
```

This will results in suboptimal trades.

4. Incorrect (or at least inconsistent) use of the Repaid event:

```solidity
    emit Repaid(
        loan.borrower,
        loan.lender,
        loanId,
        loan.debt + lenderInterest + protocolInterest,
        loan.collateral,
        loan.interestRate,
        loan.startTimestamp
    );
```
It sums up debt, interest and protocol fee and calls it the debt repaid. In other places it only uses the debt and omits the interest and protocol fee.

5. Spelling error in Lender.sol:

```solidity
    event LoanSiezed(
        address indexed borrower,
        address indexed lender,
        uint256 indexed loanId,
        uint256 collateral
    );
```
### Problems with front-running the borrower

6. Lender can front-run the borrower and change the interest rate in the pool.

Example provided in Lender.t.sol:

```solidity
function test_front_run_interest_change() public {
...
}
```
This test shows how a lender can front-run the borrower and change the interest rate in the pool right before the borrower takes a loan.

7. Lender can front-run the borrower and change the auction length to 1 block. Then after the borrower takes a loan, the lender can force an auction and seize the collateral.

```solidity
function test_front_run_auction_length() public {
...
}
```


