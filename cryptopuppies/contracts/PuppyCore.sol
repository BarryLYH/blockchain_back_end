pragma solidity ^0.4.18;

import "./PuppyMinting.sol";

contract PuppyCore is PuppyMinting {

  function PuppyCore() public {
    paused = true;
    BossAddress = msg.sender;
    _createPuppy(0, 0, 0, 0, address(0));
    _createAuction(0,address(0),0,0);
  }

  function() external payable {}

  function puppyOfOwnerByIndex(address _owner, uint256 _number) public view returns (uint256) {
    uint256 count = 0;
    for (uint256 i = 1; i <= totalSupply(); i++) {
      if (puppyIndexToOwner[i] == _owner) {
          if (count == _number) {
            return i;
          }
          else {
            count++;
          }
      }
    }
    revert();
  }

  function checkPuppyDetail(uint256 _puppyId)
    public
    view
    returns(
      uint256 genes,
      uint256 birthtime,
      uint256 cooldownEndTime,
      uint256 matronId,
      uint256 sireId,
      uint256 siringWithId,
      uint256 generation
  ){
    Puppy storage pup = puppies[_puppyId];
    genes = pup.genes;
    birthtime = pup.birthtime;
    cooldownEndTime = pup.cooldownEndTime;
    matronId = pup.matronId;
    sireId = pup.sireId;
    siringWithId = pup.siringWithId;
    generation = pup.generation;
  }


}
