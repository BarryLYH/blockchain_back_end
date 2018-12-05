pragma solidity ^0.4.18;

import "./BuySellTokens.sol";

contract Transmission is BuySellTokens {
   uint256 serviceFee = 1;

   function changeServiceFee(uint256 newFee) public onlyCompany {
     serviceFee = newFee;
   }

   struct Document {
     address Sender;
     address Recevicer;
     string  Content;
   }

   Document [] documents;

   mapping (address => uint256 []) receviced;

   function sendDocument(address _to, string _content) public whenNotPaused returns (bool success) {
     require(_checkBalance(msg.sender, serviceFee));
     require(_to != address(0));
     Document memory _docu = Document ({
       Sender: msg.sender,
       Recevicer: _to,
       Content: _content
     });

     documents.push(_docu);
     receviced[_to].push(documents.length-1);
     _transfer(msg.sender, company, serviceFee);
     return true;
   }

   function MyDocuments() public constant returns (uint256 []){
     return receviced[msg.sender];
   }

   function _haveAccess(address _add, uint _num) internal view returns (bool) {
     for (uint256 i = 0; i < receviced[_add].length; i++) {
             if (receviced[_add][i] == _num) {
                 return true;
             }
         }
     return false;
   }

   function checkMyDocument(uint256 Number) public view returns (string) {
     require(_haveAccess(msg.sender, Number));
     return documents[Number].Content;
   }
}
