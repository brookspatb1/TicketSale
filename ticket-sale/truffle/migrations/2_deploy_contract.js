const TicketSale = artifacts.require("TicketSale");

module.exports = function (deployer) {
  deployer.deploy(TicketSale, 100, 1);
};
