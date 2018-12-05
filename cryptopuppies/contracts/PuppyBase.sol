pragma solidity ^0.4.18;

import "./PuppyAccessControl.sol";

contract PuppyBase is PuppyAccessControl {

  event NewBrith(address NewPuppyOwner, uint256 PuppyId, uint256 MatronId, uint256 SireId, uint256 Generation);

  struct Puppy {
    uint256 genes;
    uint256 birthtime;
    uint256 cooldownEndTime;
    uint256 matronId;
    uint256 sireId;
    uint256 siringWithId;
    uint256 generation;
  }

  uint32 public cooldown = uint32(30 seconds);

  Puppy[] puppies;

  mapping (address => uint256) ownershipTokenCount;

  mapping (uint256 => address) public puppyIndexToOwner;

  mapping (uint256 => address) public puppyIndexToApproved;

  mapping (uint256 => address) public sireAllowToAddress;

  function _transfer(address _from, address _to, uint256 PuppyId) internal {

    ownershipTokenCount[_to] ++;

    puppyIndexToOwner[PuppyId] = _to;

    if (_from != address(0)){
      ownershipTokenCount[_from] --;
      delete puppyIndexToApproved[PuppyId];
    }
  }

  function _createPuppy(
      uint256 _matronId,
      uint256 _sireId,
      uint256 _generation,
      uint256 _genes,
      address _owner
  )
      internal
      returns (uint)
  {
    require(_matronId <= 4294967295);
    require(_sireId <= 4294967295);
    require(_generation <= 65535);

    Puppy memory _puppy= Puppy({
      genes: _genes,
      birthtime: uint256(now),
      cooldownEndTime: 0,
      matronId: _matronId,
      sireId: _sireId,
      siringWithId: 0,
      generation: _generation
    });

    puppies.push(_puppy);

    uint256 newPuppyId = puppies.length -1;

    require(newPuppyId <= 4294967295);

    NewBrith(_owner, newPuppyId, _matronId, _sireId, _generation);

    _transfer(0, _owner, newPuppyId);

    return newPuppyId;

  }
}
