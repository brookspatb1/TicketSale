// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7; 
 
contract TicketSale { 
 
 
    // </contract_variables> 
    uint numTickets;
    uint price;
    address public manager;
    uint ticketTotal;

    mapping (address => uint) public ticketOwners;
    mapping (uint => address) public idOwner;
    //nested mapping
    mapping (address => mapping (address => bool)) public swapApproval;

    //Mappings can be seen as hash tables which are virtually initialized such that every possible key 
    //exists and is mapped to a value whose byte-representation is all zeros: a type’s default value.
    //This is from the solidity documentation. Because of this I didn't assume that I needed to "push" to mappings

    //I made the decision to not use a struct as I was already using a decent amount of mappings and didn't want to increase
    //gas price more.

    constructor(uint numT, uint p) { 
        numTickets = numT;
        price = p;
        manager = msg.sender;
        ticketTotal = numT;
    }
    
 
    function buyTicket (uint ticketId) public payable {
        //requires tickets > 1, sufficient funds, checks if owner already has ticket
        //calls createTicket function which is internal and not accessible outside of iterations of the contract.
        
        require(numTickets>=1);
        require(msg.sender.balance > price);
        require(noTicket(msg.sender)==false);
        require(idOwner[ticketId]==address(0x0));

        payable(manager).transfer(price);
        createTicket(msg.sender,ticketId);
    } 
    
       function createTicket(address own, uint ticketId) internal{

        //internal keyword was just something I was trying. If I used a private keyword in solidity it would 
        //only be accessible by the original contract. The internal keyword allows all contract instances derived from contract 
        //to access the function.
        require(numTickets>=1);

        if(idOwner[ticketId]==address(0x0) && ticketId <= ticketTotal){
            ticketOwners[own] = ticketId;
            idOwner[ticketId] = own;
            numTickets--;
        }
    }

    function noTicket(address user) view public returns (bool){
        //view was used because it simply just checks state.
        if (ticketOwners[user]>0){
            return true;
        } else {
            return false;
        }
    }
 
    function getTicketOf(address person) public view returns (uint) { 
        //checks mapping for address
        return ticketOwners[person];
    } 
 
    function offerSwap(address partner) public bothHaveTickets(partner){ 
        // sets nested mapping to true
        //uses "bothHaveTickets" mehtod to check for tickets
        swapApproval[partner][msg.sender] = true;

    } 
 
    function acceptSwap(address partner) public bothHaveTickets(partner){ 
        //checks if bool in nested mapping is true
        //temp placeholders were created to 
        if(swapApproval[msg.sender][partner]==true){
            uint tempMsgSender = ticketOwners[msg.sender];
            uint tempPartner = ticketOwners[partner];

            ticketOwners[msg.sender] = tempPartner;
            ticketOwners[partner] = tempMsgSender;
            idOwner[tempMsgSender] = partner;
            idOwner[tempPartner] = msg.sender;


            delete swapApproval[partner][msg.sender];
            delete swapApproval[msg.sender][partner];
        }
        
    } 

    modifier bothHaveTickets(address partner){
        require(ticketOwners[msg.sender]>0);
        require(ticketOwners[partner]>0);
        _;
    }

}