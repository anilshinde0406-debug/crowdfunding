// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title SimpleCrowdfunding
 * @dev A minimal crowdfunding smart contract with only essential functions.
 */
contract SimpleCrowdfunding {
    address public owner;
    uint256 public fundingGoal;
    uint256 public totalFunds;

    mapping(address => uint256) public contributions;

    constructor(uint256 _fundingGoal) {
        owner = msg.sender;
        fundingGoal = _fundingGoal;
    }

    // Function to accept contributions
    function contribute() external payable {
        require(msg.value > 0, "Contribution must be greater than zero");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;
    }

    // Function for the owner to withdraw funds once the goal is met
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(totalFunds >= fundingGoal, "Funding goal not reached yet");

        uint256 amount = totalFunds;
        totalFunds = 0;
        payable(owner).transfer(amount);
    }
}
