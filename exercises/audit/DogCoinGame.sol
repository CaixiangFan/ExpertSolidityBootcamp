// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; //@audit unused import

contract DogCoinGame is ERC20 {
    uint256 public currentPrize; //@audit unused variable
    uint256 public numberPlayers; //@audit should be private
    address payable[] public players; //@audit dangerous visibility as everyone can see the player list
    address payable[] public winners; //@audit dangerous visibility as everyone can see the winer list

    event startPayout();// @audit event doesn't emit the current num of players 

    constructor() ERC20("DogCoin", "DOG") {}//@audit ERC20 token is not used

    function addPlayer(address payable _player) public payable {// @audit should have access control
        if (msg.value == 1) { //@audit value is in wei rather than ether; should have == 1 ether
            players.push(_player);
        }
        numberPlayers++;
        if (numberPlayers > 200) {//@audit it should revert; otherwise it keeps paying out
            emit startPayout();// @audit should emit current num of players to notify UI
        }
    }

    function addWinner(address payable _winner) public {//@audit should set access control otherwise anyone can add himself as a winner
        //@audit lack rules to select 100 winners from 200 players
        winners.push(_winner);// @audit lack event to emit which player is selected as winner
    }

    function payout() public {//@audit access control onlyowner
        if (address(this).balance == 100) {//@audit wrong condition makes it never pass as balace == 200
            uint256 amountToPay = winners.length / 100; //@audit unnecessary calculation as length is fix to 100 
            payWinners(amountToPay);
        }
    }

    function payWinners(uint256 _amount) public {//@audit visibility should be internal; payable
        for (uint256 i = 0; i <= winners.length; i++) { //@audit ++i to save gas
            winners[i].send(_amount);//@audit check success of sending: require(sent, "Failed to send Ether");
        }
    }
}