pragma solidity ^0.4.18;

import "./PuppyBase.sol";
import "./ERC721Draft.sol";

contract PuppyOwnership is PuppyBase, ERC721 {

  string public name = "CryptoPuppies";
  string public symbol = "CP";

  function _own(address _claimant, uint256 _tokenId) internal view returns (bool) {
    return puppyIndexToOwner[_tokenId] == _claimant;
  }

  function implementsERC721() public pure returns (bool){
    return true;
  }

  function totalSupply() public view returns (uint256 total){
    return puppies.length - 1;
  }

  function balanceOf(address _owner) public view returns (uint256) {
    return ownershipTokenCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns (address owner){
    owner = puppyIndexToOwner[_tokenId];
    require(owner != address(0));
  }

  function approve(address _to, uint256 _tokenId) public whenNotPaused{
    require(_own(msg.sender, _tokenId));
    puppyIndexToApproved[_tokenId] = _to;
    Approval(msg.sender, _to, _tokenId);
  }

  function transfer(address _to, uint256 _tokenId) public whenNotPaused{
    require(_to != address(0));
    require(_own(msg.sender, _tokenId));
    _transfer(msg.sender, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused{
    require(puppyIndexToApproved[_tokenId] == msg.sender);
    require(_own(_from, _tokenId));
    require(_to != address(0));
    _transfer(_from, _to, _tokenId);
  }
}
