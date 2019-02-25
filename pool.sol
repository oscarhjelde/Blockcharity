pragma solidity ^0.5.1;


contract lotteryContract{
    
    uint totalMoneyDonated;
    uint target;
    uint duration;
    uint beginning;
    uint end;
    address payable projectOwner; // person that is fundraising for the project.
    
    struct Investment{
        uint amountDonated;
        address investor;
    }
    
    
    constructor (uint _duration) public{
        duration = _duration;
        end = beginning + duration;
    }
    
    Investment[] investments;
    
    modifier overLimit{
        require(totalMoneyDonated+msg.value <= target);
        _;
    }
    
    modifier overDeadline
    {
        require(now < end && now >= beginning);
        _;
    }
    
    function moneyTracker() public payable overLimit overDeadline{
        Investment memory i = Investment(msg.value,msg.sender);
        investments.push(i);
        totalMoneyDonated += msg.value;
    }
    
    
    function transfer(uint amount, address payable a)  public 
    {
        a.transfer(amount);
    }
    
    function checkConditionMet() public view returns (bool)
    {
        return now < end && totalMoneyDonated==target;
    }
    
    function stopLottery() public
    {
        if(checkConditionMet()) transfer(totalMoneyDonated, projectOwner);
        else refundBackInvestors();
    }
    
    function refundBackInvestors() public
    {
        for(uint i =0; i<investments.length; i++)
        {
            Investment memory inv = investments[i];
            address payable donor = address(uint160(inv.investor));
            transfer(inv.amountDonated,donor);
        }
    }
}
    
