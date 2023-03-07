// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

contract GasContract {
    uint256 wasLastOdd = 1;
    uint256 public totalSupply = 10000; // cannot be updated
    uint256 paymentCounter = 0;

    address contractOwner;
    mapping(address => uint256) balances;
    mapping(address => Payment[]) payments;
    mapping(address => uint256) public whitelist;
    address[5] public administrators;
    uint8 paymentType = 1;
    struct Payment {
        uint8 paymentType;
        uint256 paymentID;
        address recipient;
        uint256 amount;
    }
    struct ImportantStruct {
        uint256 valueA; // max 3 digits
        uint256 bigValue;
        uint256 valueB; // max 3 digits
    }

    event Transfer(address recipient, uint256 amount);

    constructor(address[5] memory _admins, uint256) {
        contractOwner = msg.sender;
        administrators = _admins;
        balances[msg.sender] = 10000;
    }

    function balanceOf(address _user) public view returns (uint256 balance_) {
        balance_ = balances[_user];
    }

    function getTradingMode() public pure returns (bool mode_) {
        mode_ = true;
    }

    function getPayments(address _user)
        public
        view
        returns (Payment[] memory payments_)
    {
        payments_ = payments[_user];
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string memory
    ) public returns (bool status_) {
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(_recipient, _amount);
        payments[msg.sender].push(
            Payment(2, ++paymentCounter, _recipient, _amount)
        );
        return true;
    }

    function updatePayment(
        address _user,
        uint256 _ID,
        uint256 _amount,
        uint8 _type
    ) public {
        require(msg.sender == administrators[4]);
        for (uint256 ii = 0; ii < payments[_user].length; ii++) {
            if (payments[_user][ii].paymentID == _ID) {
                payments[_user][ii].paymentType = _type;
                payments[_user][ii].amount = _amount;
                break;
            }
        }
    }

    function addToWhitelist(address _userAddrs, uint8 _tier) public {
        if (_tier > 3) {
            whitelist[_userAddrs] = 3;
        } else {
            whitelist[_userAddrs] = _tier;
        }
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount,
        ImportantStruct memory
    ) public {
        address senderOfTx = msg.sender;
        balances[senderOfTx] -= (_amount - whitelist[senderOfTx]);
        balances[_recipient] += (_amount - whitelist[senderOfTx]);
    }
}
