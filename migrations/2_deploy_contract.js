var CoToken = artifacts.require("./CoToken.sol");

module.exports = function (deployer) {
    // Deploy the CoToken contract
    deployer.deploy(CoToken);
};