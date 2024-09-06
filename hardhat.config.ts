import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-foundry";
import "hardhat-diamond-abi";

const config: HardhatUserConfig = {
  solidity: "0.8.25",
  diamondAbi: {
    // (required) The name of your Diamond ABI
    name: "ColabX-dApp",
    // (optional) An array of strings, matched against fully qualified contract names, to
    // determine which contracts are included in your Diamond ABI.
    include: ["Facet"],
    // (optional) An array of strings, matched against fully qualified contract names, to
    // determine which contracts are excluded from your Diamond ABI.
    exclude: ["vendor"],
    // (optional) A function that is called with the ABI element, index, entire ABI,
    // and fully qualified contract name for each item in the combined ABIs.
    // If the function returns `false`, the function is not included in your Diamond ABI.
    // filter: function (abiElement, index, fullAbi, fullyQualifiedName) {
    //   return abiElement.name !== "superSecret";
    // },
    // Whether exact duplicate sighashes should cause an error to be thrown,
    // defaults to true.
    strict: false,
  },
};

export default config;
