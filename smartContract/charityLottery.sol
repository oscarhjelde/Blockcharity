pragma solidity ^0.5.1;
contract Lottery
{
     struct User
   {
       uint rank;
       uint totalBet;
   }
   address payable winner;
   address[] usersAddresses;
   uint totalNumberOfUsers;
   mapping(address => User) users;
   uint totalBalance;
   id = 0;
   
   // those three variables are relative to the winner.
   uint notificationTime;
   uint timeToAnswer;
   uint winnerDeadline;
   
   // those three variables are relative to the lottery. 
   uint lotteryDuration;
   uint lotteryOpeningTime;
   uint lotteryClosingTime;

   constructor() public
   {
       lotteryDuration = 1 weeks;
       timeToAnswer = 48 hours;
       winnerDeadline = notificationTime + timeToAnswer;
       lotteryClosingTime = lotteryOpeningTime + lotteryDuration;
   }
   
   function getBalance() public view returns(uint)
   {
       return address(this).balance; // or totalBalance
   }
 
 
  function bet(uint b) public payable 
  {
      require(b>0 && now > lotteryOpeningTime && now <  lotteryClosingTime ); //msg.value too ?
      // transferMoney(address(this),b)
     if(users[msg.sender].totalBet == 0)
     {
         users[msg.sender] = User(totalNumberOfUsers,b);
         usersAddresses.push(msg.sender);
     }
     totalBalance+=b;
     users[msg.sender].totalBet+=b;
  }
 
  // function to distribute money to charity => transferMoney with apporpriate address and amount. 
  
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
   
   struct Ticket
   {
       address associatedUser;
       uint price;
       uint id;
   }
   
   Ticket[] tickets;
   
   //bet(uint amount , uint pricePerTicket)
   // amount / pricePerTicket
   // for each of those tickets => create a new Ticket struct with msg.sender , pricePerTicket, auto increment id
   // add them to the list of tickets 
   // and if the user had never given before you add it to the list of users.
  
}
