import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-foundry";
import "hardhat-diamond-abi";

const config: HardhatUserConfig = {
  solidity: "0.8.25",
  diamondAbi: {
    // (required) The name of your Diamond ABI
    name: "ColabX-dApp",
    // filter: function (abiElement, index, fullAbi, fullyQualifiedName) {
    //   return abiElement.name !== "superSecret";
    // },
    // Whether exact duplicate sighashes should cause an error to be thrown,
    // defaults to true.
    strict: false,
  },
};

export default config;
