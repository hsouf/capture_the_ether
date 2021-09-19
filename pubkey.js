const EthUtil = require("ethereumjs-util");
const EthTx = require("ethereumjs-tx").Transaction;

const signedTx =
  "0x66e179dcdf16064bf308511bc98be56bb327f49419aa89e251982e4f32cc93f1";

const tx = new EthTx(signedTx, {
  networkId: 56,
  chainId: 56,
  hardfork: "petersburg",
});

const address = EthUtil.bufferToHex(tx.getSenderAddress());

const publicKey = EthUtil.bufferToHex(tx.getSenderPublicKey());
console.log(address);

console.log(publicKey);
