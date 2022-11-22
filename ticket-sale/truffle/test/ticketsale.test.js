const { assert } = require("chai");

//Brings the contract into our test with parameters
var TicketSale = artifacts.require("TicketSale", 1000, 10);

//JS can not handle "big numbers"
const BN = web3.utils.BN;


//each time you use contract you get a new contract instance
contract ('TicketSale', accounts =>{

  
  it('Ticket sale deployed', async () => {
    //Important note: only migrations can actually deploy
    const instance = await TicketSale.deployed();
    //test log text
    console.log('\n\x1b[32m%s\x1b[0m', "    Contract that address is deployed to:            " + instance.address.toString()+"\n");
    //makes sure that the ticketsale contract deployment address is not equal to an empty string
    assert(instance.address !== '');

  })

  it('Buy a ticket', async () => {
    //creating instance to use
    const instance = await TicketSale.deployed();

    //If you copy this with a call statement, you can use it to emulate a return value
    await instance.buyTicket(2, {from: accounts[1], value: web3.utils.toWei('0.11', 'ether')});
    const checkForTx = await instance.idOwner.call(2);

    //console info for tests.
    console.log('\n\x1b[32m%s\x1b[0m', "    Address mapped to checkForTx:                    " + checkForTx);
    console.log('\x1b[32m%s\x1b[0m', "    Address for the account calling 'buyTicket()':   " + accounts[1]+ "\n");

    assert.equal(checkForTx.toString(), accounts[1]);

   
  })

  it('Get the ticket owner', async () => {
    //creating instance to use
    const instance = await TicketSale.deployed();

    //first I want to buy a ticket, then check to see if that address owns the ticket
    await instance.buyTicket(3, {from: accounts[3], value: web3.utils.toWei('0.11', 'ether')});
    const checkTx = await instance.getTicketOf((accounts[3]), {from: accounts[3]});

    assert.equal(checkTx, 3);
  })
  
  it('Offer a swap', async () => {
    //creating instance to use
    const instance = await TicketSale.deployed();

    await instance.offerSwap(accounts[1], {from: accounts[3]});
    const offerTx = await instance.swapApproval.call(accounts[1],accounts[3]);

    assert.equal(offerTx, true);
  })

  it('Finalize a swap', async () => {
    const instance = await TicketSale.deployed();
    await instance.offerSwap(accounts[3], {from: accounts[1]});
    //I have to send an offer from the other account first
    const acceptSwap = await instance.acceptSwap(accounts[1], {from: accounts[3]});
    const swapCompleteTx = await instance.getTicketOf(accounts[3]);
    
    assert.equal(swapCompleteTx.toString(), 2);
  })
});
