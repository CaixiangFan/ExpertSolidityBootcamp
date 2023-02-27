// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

// import "./Ownable.sol";

// contract Constants {
//     uint256 public constant tradeFlag = 1;
//     uint256 public constant basicFlag = 0;
//     uint256 public constant dividendFlag = 1;
// }

contract GasContract {
    // uint8 constant tradeFlag = 1;
    // uint8 constant basicFlag = 0;
    // uint8 constant dividendFlag = 1;
    // uint256 constant tradePercent = 12;
    uint256 wasLastOdd = 1;
    uint256 public totalSupply = 0; // cannot be updated
    uint256 paymentCounter = 0;
    // uint256 tradeMode = 0;

    // bool isReady = false;
    address contractOwner;
    mapping(address => uint256) balances;
    mapping(address => Payment[]) payments;
    mapping(address => uint256) public whitelist;
    // mapping(address => uint256) isOddWhitelistUser;
    // mapping(address => ImportantStruct) whiteListStruct;
    address[5] public administrators;
    // History[] paymentHistory; // when a payment was updated

    // enum PaymentType {
    //     Unknown,
    //     BasicPayment,
    //     Refund,
    //     Dividend,
    //     GroupPayment
    // }
    uint8 paymentType = 1;
    // PaymentType constant defaultPayment = PaymentType.Unknown;
    struct Payment {
        uint8 paymentType;
        uint256 paymentID;
        // bool adminUpdated;
        // bytes recipientName; // max 8 characters
        address recipient;
        // address admin; // administrators address
        uint256 amount;
    }

    // struct History {
    //     uint256 lastUpdate;
    //     address updatedBy;
    //     uint256 blockNumber;
    // }
    struct ImportantStruct {
        uint256 valueA; // max 3 digits
        uint256 bigValue;
        uint256 valueB; // max 3 digits
    }

    modifier onlyAdminOrOwner() {
        // address senderOfTx = msg.sender;
        // if (checkForAdmin(senderOfTx)) {
        //     require(
        //         checkForAdmin(senderOfTx),
        //         "Gas Contract Only Admin Check-  Caller not admin"
        //     );
        //     _;
        // } else if (senderOfTx == contractOwner) {
        //     _;
        // } else {
        //     revert(
        //         "Error in Gas contract - onlyAdminOrOwner modifier : revert happened because the originator of the transaction was not the admin, and furthermore he wasn't the owner of the contract, so he cannot run this function"
        //     );
        // }
        require(checkForAdmin(msg.sender) || (msg.sender == contractOwner));
        _;
    }

    // event AddedToWhitelist(address userAddress, uint256 tier);
    // event supplyChanged(address indexed, uint256 indexed);
    event Transfer(address recipient, uint256 amount);

    // event PaymentUpdated(
    //     address admin,
    //     uint256 ID,
    //     uint256 amount
    //     // bytes recipient
    // );
    // event WhiteListTransfer(address indexed);

    constructor(address[] memory _admins, uint256 _totalSupply) {
        contractOwner = msg.sender;
        totalSupply = _totalSupply;
        for (uint256 ii = 0; ii < administrators.length; ii++) {
            if (_admins[ii] != address(0)) {
                administrators[ii] = _admins[ii];
                if (_admins[ii] == contractOwner) {
                    balances[contractOwner] = totalSupply;
                    // } else {
                    //     balances[_admins[ii]] = 0;
                    // }
                    // if (_admins[ii] == contractOwner) {
                    // emit supplyChanged(_admins[ii], totalSupply);
                } //else {
                //     emit supplyChanged(_admins[ii], 0);
                // }
            }
        }
    }

    // function getPaymentHistory()
    //     public
    //     payable
    //     returns (History[] memory paymentHistory_)
    // {
    //     return paymentHistory;
    // }

    function checkForAdmin(address _user) public view returns (bool admin_) {
        // bool admin = false;
        for (uint256 ii = 0; ii < administrators.length; ii++) {
            if (administrators[ii] == _user) {
                admin_ = true;
            }
        }
        // return admin;
    }

    function balanceOf(address _user) public view returns (uint256 balance_) {
        balance_ = balances[_user];
        // return balance;
    }

    function getTradingMode() public pure returns (bool mode_) {
        // bool mode = true;
        // if (tradeFlag == 1 || dividendFlag == 1) {
        //     mode = true;
        // } else {
        //     mode = false;
        // }
        mode_ = true;
    }

    // function addHistory(address _updateAddress)
    //     internal
    //     returns (bool status_)
    // {
    //     History memory history;
    //     history.blockNumber = block.number;
    //     history.lastUpdate = block.timestamp;
    //     history.updatedBy = _updateAddress;
    //     paymentHistory.push(history);
    //     // bool[] memory status = new bool[](tradePercent);
    //     // for (uint256 i = 0; i < tradePercent; i++) {
    //     //     status[i] = true;
    //     // }
    //     // return ((status[0] == true), _tradeMode);
    //     status_ = true;
    // }

    function getPayments(address _user)
        public
        view
        returns (Payment[] memory payments_)
    {
        // require(
        //     _user != address(0),
        //     "User must have a valid non zero address"
        // );
        payments_ = payments[_user];
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string memory _name
    ) public returns (bool status_) {
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(_recipient, _amount);
        payments[msg.sender].push(
            Payment(2, ++paymentCounter, _recipient, _amount)
        );
        // bool[] memory status = new bool[](tradePercent);
        // for (uint256 i = 0; i < tradePercent; i++) {
        //     status[i] = true;
        // }
        // return (status[0] == true);
        return true;
    }

    function updatePayment(
        address _user,
        uint256 _ID,
        uint256 _amount,
        uint8 _type
    ) public onlyAdminOrOwner {
        // address senderOfTx = msg.sender;
        for (uint256 ii = 0; ii < payments[_user].length; ii++) {
            if (payments[_user][ii].paymentID == _ID) {
                // payments[_user][ii].adminUpdated = true;
                // payments[_user][ii].admin = _user;
                payments[_user][ii].paymentType = _type;
                payments[_user][ii].amount = _amount;
                // bool tradingMode = getTradingMode();
                // addHistory(_user, tradingMode);
                // addHistory(_user);
                // emit PaymentUpdated(
                //     senderOfTx,
                //     _ID,
                //     _amount
                //     // payments[_user][ii].recipientName
                // );
                break;
            }
        }
    }

    function addToWhitelist(address _userAddrs, uint8 _tier)
        public
        onlyAdminOrOwner
    {
        // require(
        //     _tier < 255,
        //     "Tier level should not be greater than 255"
        // );
        // whitelist[_userAddrs] = _tier;
        if (_tier > 3) {
            // whitelist[_userAddrs] -= _tier;
            whitelist[_userAddrs] = 3;
            // } else if (_tier == 1) {
            // whitelist[_userAddrs] -= _tier;
            // whitelist[_userAddrs] = 1;
            // } else if (_tier > 0 && _tier < 3) {
            // whitelist[_userAddrs] -= _tier;
            // whitelist[_userAddrs] = 2;
        } else {
            whitelist[_userAddrs] = _tier;
        }
        // uint256 wasLastAddedOdd = wasLastOdd;
        // if (wasLastOdd == 1) {
        //     wasLastOdd = 0;
        // }
        // isOddWhitelistUser[_userAddrs] = wasLastAddedOdd;
        // } else if (wasLastAddedOdd == 0) {
        //     wasLastOdd = 1;
        //     // isOddWhitelistUser[_userAddrs] = wasLastAddedOdd;
        // } else {
        //     revert("call help");
        // }
        // isOddWhitelistUser[_userAddrs] = wasLastOdd;
        // emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount,
        ImportantStruct memory _struct
    ) public {
        address senderOfTx = msg.sender;
        // require(
        //     balances[senderOfTx] >= _amount,
        //     "Sender has insufficient Balance"
        // );
        // require(
        //     _amount > 3,
        //     "amount to send have to be bigger than 3"
        // );
        // balances[senderOfTx] -= _amount;
        // balances[_recipient] += _amount;
        // balances[senderOfTx] += whitelist[senderOfTx];
        // balances[_recipient] -= whitelist[senderOfTx];
        balances[senderOfTx] -= (_amount - whitelist[senderOfTx]);
        balances[_recipient] += (_amount - whitelist[senderOfTx]);

        // whiteListStruct[senderOfTx] = ImportantStruct(0, 0, 0);
        // ImportantStruct storage newImportantStruct = whiteListStruct[
        //     senderOfTx
        // ];
        // newImportantStruct.valueA = _struct.valueA;
        // newImportantStruct.bigValue = _struct.bigValue;
        // newImportantStruct.valueB = _struct.valueB;
        // emit WhiteListTransfer(_recipient);
    }
}
