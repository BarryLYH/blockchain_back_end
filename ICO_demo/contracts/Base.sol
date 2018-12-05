pragma solidity ^0.4.18;

import "./AccessControl.sol";

contract Base is AccessControl{

  mapping (address => uint256) accountBalance;

  struct University {
    address AddressOfEther;
    string  Name;
    uint256 JoinTime;
  }

  University [] universities;

  function addNewUniversity(address _address, string _name) public onlyCompany{
    University memory _university = University({
        AddressOfEther: _address,
        Name: _name,
        JoinTime: uint256(now)
      });
    universities.push(_university);
  }

  function setCompany(address _newAddress) public onlyCompany {
    require(_newAddress != address(0));
    company = _newAddress;
    accountBalance[_newAddress] = accountBalance[company];
    accountBalance[company] = 0;
  }

}
