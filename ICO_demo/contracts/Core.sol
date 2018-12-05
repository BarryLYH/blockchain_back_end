pragma solidity ^0.4.18;

import "./Transmission.sol";

contract Core is Transmission {
  function Core() public {

    paused = true;

    company = msg.sender;

    accountBalance[company] = _totalSupply;

    University memory _univer= University({
      AddressOfEther: msg.sender,
      Name: "Company",
      JoinTime: uint256(now)
    });

    universities.push(_univer);

    Document memory _docu = Document ({
      Sender: msg.sender,
      Recevicer: msg.sender,
      Content: "Token crowdsale begins"
    });

    documents.push(_docu);
  }

  function() external payable {}

}
