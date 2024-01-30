// const HelloWorld = artifacts.require("./HelloWorld");

// module.exports = function(deployer) {
//     deployer.deploy(HelloWorld);
// };

const Color = artifacts.require("Ownership");

module.exports = function(deployer) {
    deployer.deploy(Color);
};