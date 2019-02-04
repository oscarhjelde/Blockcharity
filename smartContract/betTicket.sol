pragma solidity ^0.5.1;
contract Lottery
{
 struct Ticket
   {
       address associatedUser;
       uint price;
       uint id;
   }
   uint nextTicketIdToAssign;
   Ticket[] tickets;
   mapping(address => bool) users;
   address payable winner;
   address[] usersAddresses;
   uint totalBalance;
   
   // those three variables are relative to the winner.
   uint notificationTime;
   uint timeToAnswer;
   uint winnerDeadline;
   
   // those three variables are relative to the lottery. 
   uint lotteryDuration;
   uint lotteryOpeningTime;
   uint lotteryClosingTime;
   
   modifier lotteryOpen() {
        require(now >= lotteryOpeningTime && now < lotteryClosingTime );
        _;
    }
    
    modifier sufficientAmount(uint n)
    {
        require(msg.value >n);
        _;
    }
    
    modifier winnerAnswer()
    {
        require(now >= notificationTime && now < winnerDeadline);
        _;
    }
    
    // create events : transaction ( general successfull , donor successfully gave money , tickets , winner)

   constructor() public
   {
       lotteryDuration = 1 weeks;
       timeToAnswer = 48 hours;
       winnerDeadline = notificationTime + timeToAnswer;
       lotteryClosingTime = lotteryOpeningTime + lotteryDuration;
       nextTicketIdToAssign = 0;
   }
   
   function getBalance() public view returns(uint)
   {
       return address(this).balance; // or totalBalance

   }
   
   function getNumberOfUsers() public view returns (uint)
   {
       return usersAddresses.length;
   }
 
   
 
  function bet(uint pricePerTicket) lotteryOpen sufficientAmount(pricePerTicket) public payable 
  {
      
      uint numberOfTickets = msg.value / pricePerTicket;
      if(!userInLottery(msg.sender)) usersAddresses.push(msg.sender);
      for(uint i=1; i<=numberOfTickets; i++)
      {
          Ticket memory t = Ticket(msg.sender,pricePerTicket,nextTicketIdToAssign++);
          tickets.push(t);
      }
      totalBalance+=msg.value;
  }
  
  function userInLottery(address u) public view returns (bool)
  {
      return users[u];
  }
 
  // function to distribute money to charity => transferMoney with appropriate address and amount. 
  
   function transferMoney(address payable a, uint amount) payable public
   {
       a.transfer(amount);
   }
   
   function dealWithWinner() public 
   {
       
   }
  
   function giveMoneyToWinner(uint amount)  public 
   {
       transferMoney(winner,amount);
   }
   
   function getDeadline() view public returns (uint)
   {
       return lotteryDuration;
   }
   
   
  
}
