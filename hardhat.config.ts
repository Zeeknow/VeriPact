import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-mocha-ethers";

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.30", // REQUIRED by Redbelly
    settings: {
      evmVersion: "prague", // REQUIRED by Redbelly
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    redbellyTestnet: {
      type: "http",
      url: "https://governors.testnet.redbelly.network",
      chainId: 153,
      gasPrice: "auto",
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
    },
  },
};

export default config;