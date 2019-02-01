pragma solidity ^0.5.1;


contract lotteryContract{
    
    uint start;
    uint runTime;
    uint ticketPrice;
    
    
    struct Ticket{
        uint ticketID;
        address participant;
    }
    
    Ticket[] tickets;
    
    modifier trigger{
        require(now <= start + runTime);
        _;
    }
    
    modifier betEnough{
        require(msg.value>=ticketPrice);
        _;
    }
    
   
    
    function bet() payable public trigger betEnough{
        uint ticketAmmount = msg.value / ticketPrice;
        for(uint i;i<ticketAmmount;i++){
            tickets.push(Ticket(tickets.length-1,msg.sender));
        }
    }
    
}
