pragma solidity ^0.4.18;

import "./Tokens.sol";

contract BuySellTokens is Tokens {
  uint256 public sellPrice;
  uint256 public buyPrice;

  function priceUpdate(uint256 newSellPrice, uint256 newBuyPrice) public onlyCompany {
    sellPrice = newSellPrice;
    buyPrice =  newBuyPrice;
  }

  function buyToken() payable public whenNotPaused returns (uint amount) {
    amount = msg.value / sellPrice;
    require(accountBalance[company] >= amount);
    accountBalance[msg.sender] += amount;
    accountBalance[company] -= amount;
    Transfer(company, msg.sender, amount);
    return amount;
  }

  function sellToken(uint256 amount) public whenNotPaused returns(uint revenue) {
    require(_checkBalance(msg.sender, amount));
    revenue = amount * buyPrice;
    accountBalance[company] += amount;
    accountBalance[msg.sender] -= amount;
    msg.sender.transfer(revenue);
    Transfer(msg.sender, company, amount);
    return revenue;
  }
}
