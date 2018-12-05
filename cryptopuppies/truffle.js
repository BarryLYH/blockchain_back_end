module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    rinkeby: {
      host: "localhost", // Connect to geth on the specified
      port: 8545,
      from: "0xef9E291DE90edb4259c68871c320D19CEb2Dba43", // default address to use for any transaction Truffle makes during migrations
      network_id: 4,
      gas: 4700000// Gas limit used for deploys
    }
  }
};
