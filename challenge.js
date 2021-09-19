const ethers = require("ethers");
const guess = async function () {
  const wallet = new ethers.Wallet(
    "99a7133f819e097eb8a92f0b9aae55f87e83e8c4f7e9d2aa113a2f9273ce553d" //private key
  );

  let provider = new ethers.providers.JsonRpcProvider(
    "https://ropsten.infura.io/v3/" + YOUR_API_KEY
  );
  const account = wallet.connect(provider);

  const challenge = new ethers.Contract(
    "0xCf0105C3B01a4abB6d7072fe08cC47f33ba87EB6",
    [
      {
        constant: false,
        inputs: [
          {
            name: "_addr",
            type: "address",
          },
        ],
        name: "myguess",
        outputs: [],
        payable: true,
        stateMutability: "payable",
        type: "function",
      },
    ],
    account
  );

  const tx = await challenge.myguess(
    "0x514E3822BFC7B965B3445fF17a52Ba3C279FE545",
    {
      gasLimit: 3000000,
      value: ethers.utils.parseUnits("1", "ether"),

      gasPrice: ethers.utils.parseUnits("1.000000012", "gwei"),
    }
  );
  const receipt = await tx.wait();
};

guess();
