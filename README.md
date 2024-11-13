# DWG Smart Contract

## Issues and Fixes

### Issue 1: **Reentrancy Vulnerability**
**Core reason:**  
The `withdraw` function first transfers funds to the user and then updates the state (balances). This creates a reentrancy vulnerability where an attacker could call the `withdraw` function recursively before the state is updated, draining the contract’s balance.

**Fix:**  
Update the balance before transferring funds. Additionally, use the `call` method to avoid gas limit issues during transfer, which is considered more secure than using `transfer` in modern contracts.

```solidity
// Withdraw function with reentrancy protection, amount checks, and transfer mechanism
function withdraw(uint256 amount) public {
    require(balances[msg.sender] >= amount, "Insufficient balance");
    require(amount > 0, "Withdrawal amount must be greater than zero");

    balances[msg.sender] -= amount;

    // Using call to avoid gas limit issues
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Transfer failed");

    emit Withdrawal(msg.sender, amount);
}
```

### Issue 2: Missing Balance Check on Deposit
**Core reason:**  
The deposit function does not check if the deposit amount is greater than zero. Users might accidentally send zero Ether, wasting gas without any meaningful transaction.

**Fix:**  
Add a require statement to ensure the deposit amount is greater than zero.

```solidity
// Deposit function to receive Ether and update balances
function deposit() public payable {
    require(msg.value > 0, "Deposit amount must be greater than zero");
    balances[msg.sender] += msg.value;
    emit Deposit(msg.sender, msg.value);
}
```


