# blockchain-ca2

## Issue 1: Reentrancy Vulnerability
### Core reason:
The withdraw function first transfers funds to the user and then updates the state (balances). This creates a reentrancy vulnerability where an attacker could call the withdraw function recursively before the state is updated, draining the contract’s balance.

### Fix:
Update the balance before transferring funds. Additionally, use the call method to avoid gas limit issues during transfer, which is considered more secure than using transfer in modern contracts.

// Withdraw function with reentrancy protection, amount checks, and transfer mechanism <br>

function withdraw(uint256 amount) public {
    require(balances[msg.sender] >= amount, "Insufficient balance");
    require(amount > 0, "Withdrawal amount must be greater than zero");
    balances[msg.sender] -= amount;
    // Using call to avoid gas limit issues
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Transfer failed");
    emit Withdrawal(msg.sender, amount);
}
