contract DWG {  
    mapping(address => uint256) private balances;  
    function deposit() public payable {  
        balances[msg.sender] += msg.value;  
    }  
    function withdraw(uint256 amount) public {  
        uint256 balance = balances[msg.sender];  
        balances[msg.sender] -= amount;  
        payable(msg.sender).transfer(amount);  
    }  
    function getBalance() public view returns (uint256) {  
        return balances[msg.sender];  
    }  
}
