pragma solidity ^0.4.18;

import "./ERC20.sol";
import "./Base.sol";

contract Tokens is ERC20, Base {

  uint256 _totalSupply = 1000000;

  mapping(address => mapping (address => uint256)) allowed;

  event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);

  function _checkBalance(address _add, uint256 _tokens) internal view returns (bool) {
    return accountBalance[_add] >= _tokens;
  }

	function totalSupply() constant public returns (uint256 supply){
    return _totalSupply - accountBalance[this];
  }

	function balanceOf(address _owner) constant public returns (uint256 balance) {
    return accountBalance[_owner];
  }

  function _transfer(address _from, address _to, uint256 _value) internal {
    accountBalance[_from] -= _value;
    accountBalance[_to] += _value;
  }

	function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
    require(_to != address(0));
    require(_checkBalance(msg.sender, _value));
    _transfer(msg.sender, _to, _value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  function approve(address _spender, uint256 _value) public returns (bool success){
    require(_spender != address(0));
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  function allowance(address _owner, address _spender) constant public returns (uint256 remaining){
    return allowed[_owner][_spender];
  }

  function _approval(address _owner, address _spender, uint256 _value) internal view returns(bool) {
    return allowed[_owner][_spender] >= _value;
  }

	function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
    require(_checkBalance(_from, _value));
    require(_approval(_from, msg.sender, _value));
    _transfer(_from, _to, _value);
    Transfer(_from, _to, _value);
    return true;
  }
}
