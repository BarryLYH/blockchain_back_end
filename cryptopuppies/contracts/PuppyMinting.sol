pragma solidity ^0.4.18;

import "./PuppyAuction.sol";

contract PuppyMinting is PuppyAuction{
  uint256 public giftPuppies = 5000;
  uint256 public giftPuppiesCount;

  function createGiftPuppy(uint256 _genes, address _owner) public onlyBoss {
    if (_owner == address(0)) {
      _owner == BossAddress;
    }

    require(giftPuppiesCount < giftPuppies);
    giftPuppiesCount ++;
    _createPuppy(0, 0, 0, _genes, _owner);
  }

}
