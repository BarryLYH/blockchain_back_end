pragma solidity ^0.4.18;

import "./PuppyBreeding.sol";

contract PuppyAuction is PuppyBreeding {

  struct AuctionPuppy {
    uint256 auctionPuppyId;
    address auctionPuppyOwner;
    uint256 auctionPuppyPrice;
    uint256 auctionPuppyStartTime;
    uint256 auctionPuppyBirthTime;
    uint256 auctionPuppyGeneration;
    uint256 auctionPuppyGenes;
    uint256 auctionPuppyMatron;
    uint256 auctionPuppySire;
  }

  AuctionPuppy[] auctionPuppies;

  mapping (address => uint256) public auctionBalances;

  function _isReadyForAuction(Puppy _puppy) internal view returns (bool) {
    return (_puppy.siringWithId == 0) && (_puppy.cooldownEndTime <= now);
  }

  function isReadyForAuction(uint256 _puppyId) public view returns (bool) {
    require(_puppyId > 0);
    Puppy storage pup = puppies[_puppyId];
    return _isReadyForAuction(pup);
  }

  function _createAuction(uint256 _puppyId, address _ownership, uint256 _price, uint256 _time) internal{
    AuctionPuppy memory _auctionpuppy= AuctionPuppy ({
      auctionPuppyId: _puppyId,
      auctionPuppyOwner: _ownership,
      auctionPuppyPrice: _price,
      auctionPuppyStartTime: _time,
      auctionPuppyBirthTime: puppies[_puppyId].birthtime,
      auctionPuppyGeneration: puppies[_puppyId].generation,
      auctionPuppyGenes: puppies[_puppyId].genes,
      auctionPuppyMatron: puppies[_puppyId].matronId,
      auctionPuppySire: puppies[_puppyId].sireId
    });

    auctionPuppies.push(_auctionpuppy);
  }

  function createAuction(uint256 _puppyId, uint256 _price) public whenNotPaused {
    Puppy storage _puppy = puppies[_puppyId];
    require(_own(msg.sender, _puppyId));
    require(_isReadyForAuction(_puppy));

    _createAuction(_puppyId, msg.sender, _price, uint256(now));
    _puppy.cooldownEndTime = uint256(now) + uint256(30 days);
  }

  function checkAuctionPuppies(uint256 _auctionId)
    public
    view
    whenNotPaused
    returns (
      uint256 PuppyId,
      address PuppyOwner,
      uint256 PuppyPrice,
      uint256 PuppyStartTime,
      uint256 PuppyBirthTime,
      uint256 PuppyGeneration,
      uint256 PuppyGenes,
      uint256 PuppyMatron,
      uint256 PuppySire
  ) {
      AuctionPuppy storage _auctionPuppy = auctionPuppies[_auctionId];
      PuppyId = _auctionPuppy.auctionPuppyId;
      PuppyOwner = _auctionPuppy.auctionPuppyOwner;
      PuppyPrice = _auctionPuppy.auctionPuppyPrice;
      PuppyStartTime = _auctionPuppy.auctionPuppyStartTime;
      PuppyBirthTime = _auctionPuppy.auctionPuppyBirthTime;
      PuppyGeneration = _auctionPuppy.auctionPuppyGeneration;
      PuppyGenes = _auctionPuppy.auctionPuppyGenes;
      PuppyMatron = _auctionPuppy.auctionPuppyMatron;
      PuppySire = _auctionPuppy.auctionPuppySire;
  }

  function bugAuctionPuppy(uint256 _auctionId) public payable whenNotPaused {
    require(_auctionId <= (auctionPuppies.length -1));

    AuctionPuppy storage _auctionPuppy = auctionPuppies[_auctionId];

    require(msg.value >= _auctionPuppy.auctionPuppyPrice);

    puppyIndexToApproved[_auctionPuppy.auctionPuppyId] = msg.sender;
    address previousOwner = _auctionPuppy.auctionPuppyOwner;
    uint256 sellPrice = _auctionPuppy.auctionPuppyPrice;

    Puppy storage _puppy = puppies[_auctionPuppy.auctionPuppyId];
    _puppy.cooldownEndTime = uint256(now);

    transferFrom(_auctionPuppy.auctionPuppyOwner, msg.sender, _auctionPuppy.auctionPuppyId);

    delete auctionPuppies[_auctionId];
    auctionBalances[previousOwner] = sellPrice;
    
  }

  function withdrawAuctionBalance() public whenNotPaused {
    require(msg.sender != address(0));
    require(_haveAuctionBalance(msg.sender));
    msg.sender.transfer(auctionBalances[msg.sender]);
    delete auctionBalances[msg.sender];
  }

  function _haveAuctionBalance(address _owner) internal view returns (bool) {
    return (auctionBalances[_owner]>0);
  }



}
