//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "./Token.sol";

contract DeFi1 {
    uint256 public initialAmount = 0;
    address[] public investors;
    uint256 blockReward = 0;
    Token public token;

    constructor(uint256 _initialAmount, uint256 _blockReward) {
        initialAmount = initialAmount;
        token = new Token(_initialAmount);
        blockReward = _blockReward;
    }

    /*
      This function should be restricted only to the administrator (contract deployer)
    */
    function addInvestor(address _investor) public {
        investors.push(_investor);
    }

    function claimTokens() public {
        bool found = false;
        uint256 payout = 0;

        for (uint256 ii = 0; ii < investors.length; ii++) {
            if (investors[ii] == msg.sender) {
                found = true;
            } else {
                found = false;
            }
        }
        if (found == true) {
            // should update the payout value
            // payhout = calculatePayout();
            calculatePayout();
        }

        token.transfer(msg.sender, payout);
    }

    /*
      Function state mutability can be restricted to view.
    */
    function calculatePayout() public returns (uint256) {
        uint256 payout = 0;
        // This declaration shadows an existing declaration.
        uint256 blockReward = blockReward;
        blockReward = block.number % 1000;
        payout = initialAmount / investors.length;
        payout = payout * blockReward;
        blockReward--;
        return payout;
    }
}
