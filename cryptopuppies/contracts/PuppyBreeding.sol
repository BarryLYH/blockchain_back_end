pragma solidity ^0.4.18;

import './PuppyOwnership.sol';

contract PuppyBreeding is PuppyOwnership {

  uint256 public autoBirthFee = 1000000 * 1000000000;

  event Pregnant(address owner, uint256 matronId, uint256 sireId);

  function _isReadyToBreed(Puppy _puppy) internal view returns (bool) {
    return (_puppy.siringWithId == 0) && (_puppy.cooldownEndTime <= now);
  }

  function _isSringPermitted(uint256 _matronId, uint256 _sireId) internal view returns (bool) {
    address matronOwner = puppyIndexToOwner[_matronId];
    address sireOwner = puppyIndexToOwner[_sireId];
    return (matronOwner == sireOwner || sireAllowToAddress[_sireId] == matronOwner);
  }

  function _triggleCooldown(Puppy storage _puppy) internal {
    _puppy.cooldownEndTime = uint256(now + cooldown);
  }

  function approveSiring(address _addr, uint256 _sireId) public whenNotPaused {
    require(_own(msg.sender, _sireId));
    sireAllowToAddress[_sireId] = _addr;
  }

  function _isReadyToGiveBirth(Puppy _matron) private view returns (bool) {
    return (_matron.siringWithId != 0) && (_matron.cooldownEndTime <= now);
  }

  function isReadyToBreed(uint256 _puppyId) public view returns (bool) {
    require(_puppyId > 0);
    Puppy storage pup = puppies[_puppyId];
    return _isReadyToBreed(pup);
  }

  function relationVoild(Puppy storage _matron,uint256 _matronId, Puppy storage _sire, uint256 _sireId) private view returns (bool){
    if   (_matronId == _sireId) {
      return false;
    }
    if (_matron.matronId == _sireId || _matron.sireId == _sireId) {
      return false;
    }
    if (_sire.matronId == _matronId || _sire.sireId == _matronId) {
      return false;
    }
    if (_sire.matronId == 0 || _matron.matronId == 0) {
      return true;
    }
    if (_sire.matronId == _matron.matronId || _sire.matronId == _matron.sireId) {
      return false;
    }
    if (_sire.sireId == _matron.matronId || _sire.sireId == _matron.sireId) {
      return false;
    }
    return true;
  }

  function breedWith(uint256 matronId, uint256 sireId) public whenNotPaused {
    require(_own(msg.sender, matronId));
    require(_isSringPermitted(matronId, sireId));

    Puppy storage matron = puppies[matronId];
    Puppy storage sire = puppies[sireId];

    require(_isReadyToBreed(matron));
    require(_isReadyToBreed(sire));

    require(relationVoild(matron, matronId, sire, sireId));

    _breedWith(matronId, sireId);
  }

  function _breedWith(uint256 _matronId, uint256 _sireId) internal {
    Puppy storage matron = puppies[_matronId];
    Puppy storage sire = puppies[_sireId];

    matron.siringWithId = _sireId;

    _triggleCooldown(matron);
    _triggleCooldown(sire);

    delete sireAllowToAddress[_matronId];
    delete sireAllowToAddress[_sireId];

    Pregnant(puppyIndexToOwner[_matronId], _matronId, _sireId);
  }

  function giveBrith(uint256 _matronId) public whenNotPaused returns (uint256){
    Puppy storage matron = puppies[_matronId];
    uint256 _sireId = matron.siringWithId;
    Puppy storage sire = puppies[_sireId];

    require(matron.birthtime != 0 );

    require(_isReadyToGiveBirth(matron));

    uint256 parentGen = matron.generation;
    if (sire.generation > matron.generation) {
      parentGen = sire.generation;
    }

    uint256 childGenes = (matron.genes + sire.genes) / 2;

    address own = puppyIndexToOwner[_matronId];

    uint256 puppyId = _createPuppy(_matronId, _sireId, parentGen + 1, childGenes, own);

    return puppyId;
  }


}
