// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title SimpleCrowdfunding
 * @dev A crowdfunding contract that allows contributions, withdrawals, and refunds.
 */
contract SimpleCrowdfunding {
    address public owner;
    uint256 public fundingGoal;
    uint256 public totalFunds;
    bool public fundingClosed;

    mapping(address => uint256) public contributions;

    constructor(uint256 _fundingGoal) {
        owner = msg.sender;
        fundingGoal = _fundingGoal;
        fundingClosed = false;
    }

    // Function to accept contributions
    function contribute() external payable {
        require(msg.value > 0, "Contribution must be greater than zero");
        require(!fundingClosed, "Funding is closed");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;
    }

    // Function for the owner to withdraw funds once the goal is met
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(totalFunds >= fundingGoal, "Funding goal not reached yet");
        require(!fundingClosed, "Funding is closed");

        uint256 amount = totalFunds;
        totalFunds = 0;
        fundingClosed = true; // Close the funding after successful withdrawal
        payable(owner).transfer(amount);
    }

    // Function for contributors to withdraw their funds if the goal is not met
    function refund() external {
        require(fundingClosed, "Funding is still open");
        require(totalFunds < fundingGoal, "Funding goal reached, no refunds");

        uint256 contributedAmount = contributions[msg.sender];
        require(contributedAmount > 0, "No contribution to refund");

        contributions[msg.sender] = 0; // Prevent re-entrancy attacks
        payable(msg.sender).transfer(contributedAmount);
    }

    // Function to check if the funding goal has been reached
    function checkGoalStatus() external view returns (bool) {
        return totalFunds >= fundingGoal;
    }
}
