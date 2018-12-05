pragma solidity ^0.4.18;

contract HomelessAccessControl {

    address public companyAddress;
    address public governmentAddress;
    address public organizerOneAddress;
    address public organizerTwoAddress;
    address [] public organizers = [organizerOneAddress, organizerTwoAddress];


    modifier onlyCompany() {
      require(msg.sender == companyAddress);
      _;
    }

    modifier onlyOrganizerOne() {
      require(msg.sender == organizerOneAddress);
      _;
    }

    modifier onlyOrganizerTwo() {
      require(msg.sender == organizerTwoAddress);
      _;
    }

    modifier onlyGovernment() {
      require(msg.sender == governmentAddress);
      _;
    }

    function changeCompanyAddress(address _newCompanyAddress) public onlyCompany {
      require(_newCompanyAddress != address(0));
      companyAddress = _newCompanyAddress;
    }

    function changeGovermentAddress(address _newGovermentAddress) public onlyGovernment {
      require(_newGovermentAddress != address(0));
      governmentAddress = _newGovermentAddress;
    }

    function changeOrganizerOneAddress(address _newAddress) public onlyGovernment {
      require(_newAddress != address(0));
      organizerOneAddress = _newAddress;
    }

    function changeOrganizerTwoAddress(address _newAddress) public onlyGovernment {
      require(_newAddress != address(0));
      organizerTwoAddress = _newAddress;
    }
    function withdrawBalance() external onlyGovernment {
          governmentAddress.transfer(this.balance);
    }
}

contract InitialSystem is HomelessAccessControl{
    address[]  addresses;
    mapping (address => uint256) accountBalance;
    mapping (uint256 => address) myHash;
    mapping (address => uint256) accountID;
    mapping (uint256 => address) idToAddress;

    function _addNewAddress(address _new) internal {
        addresses.push(_new);
    }

    function _dataStoring(uint256 _id, address _add) internal {
        accountID[_add] = _id;
        idToAddress[_id] = _add;
    }

    function _giveToken(address _add) internal {
        accountBalance[_add] = 20;
    }

    function addNewIdentification (address _newAccount) public onlyGovernment returns(uint256 newAccountId) {
        require(_newAccount != address(0));
        _addNewAddress(_newAccount);

        uint256 AccountId = addresses.length ;

        _dataStoring(AccountId, _newAccount);

        _giveToken(_newAccount);
        return AccountId;
    }

    function createNewHash(uint256 _id, address _hashString) public onlyGovernment {
        require(_hashString != address(0));
        myHash[_id] = _hashString;
    }
}

contract TokenSystem is InitialSystem {

    function checkMyAccount() public view returns (uint256) {
      return accountBalance[msg.sender];
    }

    function BadBehaviour(uint256 _id) public onlyOrganizerOne onlyGovernment {
      accountBalance[idToAddress[_id]] --;
    }

    function GoodToSociety (uint256 _id) public onlyOrganizerTwo onlyGovernment {
      accountBalance[idToAddress[_id]] ++;
    }

    function ReputationChecking (uint256 _id) public onlyOrganizerOne onlyGovernment onlyOrganizerTwo view returns(uint REP){
      return accountBalance[idToAddress[_id]];
    }

    function ReputationChecking (address _homeless) public onlyOrganizerOne onlyGovernment onlyOrganizerTwo view returns(uint REP){
      return accountBalance[_homeless];
    }


}

contract HomelessCore is TokenSystem {

    function HomelessCore() public {
        companyAddress = msg.sender;
        governmentAddress = msg.sender;
        organizerOneAddress = msg.sender;
        organizerTwoAddress = msg.sender;
    }

    function() external payable {}

    function getHash(address _homeless) public view  onlyGovernment returns (address) {
        require(_homeless != address(0));
        return myHash[accountID[_homeless]];
    }

    function HowManyAccout() public view onlyGovernment returns (uint256){
        uint256 AccountId = addresses.length ;
        return AccountId;
    }

    function checkAccountID(address _homeless) public view onlyGovernment returns (uint256) {
        return accountID[_homeless];
    }
}
