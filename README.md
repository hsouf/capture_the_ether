# capture_the_ether_challenges

* [ Capture the Ether](#part1)
    * [Call my name](#callmyname)
    * [Donation overflow](#donation)
    * [Mapping: or how the wrong mapping can make you mop the floors forever](#mapping)
    * [Finding the private key](#privateKey)
    * [Blockhash Prediction](#blockhash)
    * [Finding the public key](#publicKey)
    * [Fifty years: unsolved](#fiftyYears)
    * [Token sale : or why you should never trust user input](#tokenSale)
    
    
    
    <h2 name="part1">

</h2>

I've never heard of ```capturetheether.com``` before, but I was familiar with https://ethernaut.openzeppelin.com/ developed by openzeppelin, which allows you to use the browser console to interact directly with the contracts ABI.  So some of the challenges looked familiar that's why I was able to pull off most of them, although some of them were challenging and went unsolved. I'm going to list below some of the challenges and how I used some magic to solve them. 
- My address used on Ropsten to solve the challenges : ```0xc119f52428aCd711D9fBb71B921f7736504e2864```
- My finale sore : ```9100``` 
- Nickname : ```soufiane```
- Ethereum IDE: ```Remix```

Find the complete list of challenges here: 
https://capturetheether.com/challenges/
<h3 name="callmyname"/>
Call my name:
</h3>

The first challenge seemed very easy but I had to play with some inline assembly to get the right input for the nickname by converting it from string to bytes32:








 ```Solidity 
 function stringToBytes32(string memory nickName) public pure returns(bytes32 name){
   assembly {
             name := mload(add(nickName,32))
    }
}
 
 ```


<h3 name="donation"/>
Donation
</h3>

It was quite a funny ride, since it was a good reminder of the importance of always deciding on the data location for arrays, structs and mapping. And also of why using memory to store temporary data is a must.  
 

<h3 name="privateKey"/>
Account Takeover
</h3>

DeFi wouldn't exist if private keys were simple to guess. 
Account Takeover challenge made me lose sleep.  So I first started with Etherscan looking for the transactions history of the address hoping that I’ll find a hidden message in a transaction or a any hint about it. And that’s when I found a long list of recent transactions coming from the mentioned address, I knew people solved this challenge so I had to figure it out on my own.  I went immediately to the first and then second transactions to ever be signed by the given address. I've run some scripts using  ```ethereumjs-tx``` for  more details about how the very first transactions were signed. Something must be wrong with the way signatures were generated, the ```r``` value used by ECDSA   was repeated in some transactions. The equation used by ECDSA to sign transaction  ```signature=k^{-1} ∗(h+r∗privKey)(modn)``` and Bingo, all you have to do is solve the system of é linear equations... 

<h3 name="mapping"/>
Mapping overflow
</h3>

The mapping challenge was quite a ride because now I feel the importance of defining the size of your arrays in Solidity before using them.
I figured out the address of the first slot occupied by ```isComplete```, used some inline assembly to get the slot address of isComplete and mapped the first element with the value of  ```bytes32(2**256-0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6)``` to make it overflow and magic happens: ```isComplete``` which is defaulted to false turned to true.


```Solidity
bool public isComplete;
uint256[] map;

```
To get the slot address I played with some inline assembly : 
```Solidity
function getIsCompleteStorageAddress() public view returns(bytes32 slot){
        assembly{
            slot := sload(isComplete_slot)
        }
    }
````
Used ```isComplete_slot``` since I was dealing dealing with the soldity version of  ^0.4.21 otherwise I could have  used  ```isComplete.slot```

<h3 name="blockhash"/>
The next block hash prediction and delegate call
</h3>

The only challenge here was  to call a function knowing exactly what would the block.number in which your transaction will be included, so all I had to do is write a new smart contract to call the target function.

<h3 name="publicKey"/>
Finding the public key
</h3>

To find the public key of a given address, all I had to do is get a previously signed transaction by the address from Etherscan and run the following script: 

```Javascript

const EthUtil = require("ethereumjs-util");
const EthTx = require("ethereumjs-tx").Transaction;

const signedTx =
  "0xf87080843b9aca0083015f90946b477781b0e68031109f21887e6b5afeaaeb002b808c5468616e6b732c206d616e2129a0a5522718c0f95dde27f0827f55de836342ceda594d20458523dd71a539d52ad7a05710e64311d481764b5ae8ca691b05d14054782c7d489f3511a7abf2f5078962"; 
  //got a random tx hash (signed by the given address) from etherscan

const tx = new EthTx(signedTx, { chain: "ropsten", hardfork: "petersburg" });
const publicKey = EthUtil.bufferToHex(tx.getSenderPublicKey());


console.log(publicKey);
```  
<h3 name="fiftyYears">
   Fifty years : unsolved
   
   </h3>
I must be honest that the Fifty years challenge was unsolved, but I smell something fishy with the way contribution amount and timestamp are written in the  upsert()  function, this exploit does remind me of the donation smart contract discussed below.


```Solidity

Contribution[] queue; //first slot
uint256 head; //second slot
    ...
  function upsert(uint256 index, uint256 timestamp) public payable {
    ...
    ...
 contribution.amount = msg.value; // we are writing to storage slot of 0  !!!!!
 contribution.unlockTimestamp = timestamp; // we are writing to storage slot of 1 !!!!!!
 queue.push(contribution);
 }

```
I hope it won't take me 50 years to finish up this one ^^
<h3 name="tokenSale">
   Token sale : or why you should never trust user input
   </h3>
   
   All I had to do is overflow the numToken with the value of 2^256-1 and send a transaction with the value of ```415992086870360064``` (the value numToken will have after the overflow)
  but again it was a great lesson on why you should ```never trust the user input```, and avoid it as much as possible in your smart contracts. 
