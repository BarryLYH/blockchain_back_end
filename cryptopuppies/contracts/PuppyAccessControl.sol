pragma solidity ^0.4.18;

contract PuppyAccessControl {

   address public BossAddress;

   bool public paused = false;

   modifier onlyBoss() {
     require(msg.sender == BossAddress);
     _;
   }

   function setBoss(address _newboss) public onlyBoss {
     require(_newboss != address(0));
     BossAddress = _newboss;
   }

   function withdrawBalance() external onlyBoss {
     BossAddress.transfer(this.balance);
   }

   modifier whenNotPaused() {
     require(!paused);
     _;
   }

   modifier wheaused() {
     require(paused);
     _;
   }

   function pause() public onlyBoss whenNotPaused {
     paused = true;
   }

   function unpause() public onlyBoss whenPaused {
     paused = false;
   }
}
