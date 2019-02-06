pragma solidity ^0.5.1;
contract Lottery
{
 struct Ticket
   {
       address associatedUser;
       uint price;
       uint id;
   }
   
     struct Charity 
   {
       string name;
       string description;
       address charityAddress;
   }
   
   uint nextTicketIdToAssign;
   Ticket[] tickets;
   mapping(address => bool) users;
   address payable winner;
   
   address[] usersAddresses;
   Charity[] charities;
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
    
    // create events : transaction ( general successfull) , donor successfully gave money , tickets , winner 

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
  
  function  addCharity(string memory charityName, string memory charityDescription , address charityAddress) public {
      charities.push(Charity(charityName,charityDescription,charityAddress));
  }
  
  function  removeCharity(address charityToDelete) public {
     uint i = indexOfElement(charityToDelete);
     charities[i] = charities[charities.length-1];
     delete charities[charities.length-1];
     charities.length--;
  }
  
  function indexOfElement(address ca) public returns (uint)
  {
       for(uint index=0; index<charities.length; index++)
      {
          Charity memory c = charities[index];
          if(ca == c.charityAddress)
          {
            return index;
          }
      }
      return 0; // need to think about error value. 
   
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
