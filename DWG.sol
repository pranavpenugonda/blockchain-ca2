// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DWG {
    mapping(address => uint256) private balances;

    // Events to log deposits and withdrawals
    event Deposit(address indexed account, uint256 amount);
    event Withdrawal(address indexed account, uint256 amount);

    // Deposit function to receive Ether and update balances
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

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

    // Function to get the balance of the caller
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    // Receive Ether sent directly to the contract without calling deposit()
    receive() external payable {
        balances[msg.sender] += msg.value;
    }
}
