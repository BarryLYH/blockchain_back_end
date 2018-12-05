pragma solidity ^0.4.18;

contract AccessControl {
  address public company;

  bool public paused;

  modifier onlyCompany() {
    require(msg.sender == company);
    _;
  }

  function withdrawBalance() external onlyCompany {
    company.transfer(this.balance);
  }

  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  modifier whenPaused() {
    require(paused);
    _;
  }

  function pause() public onlyCompany whenNotPaused {
    paused = true;
  }

  function unpause() public onlyCompany whenPaused {
    paused = false;
  }

}
