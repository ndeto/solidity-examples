// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

contract Vote {
    event Voted(address indexed voter, uint256 candidateIndex);
    event WinnerDeclared(string winnerName, uint256 winningVoteCount);

    struct Candidate {
    string name;
    uint256 voteCount;
    }

    mapping(address => bool) public voters;

    Candidate[] public candidates;

    constructor(string[] memory candidateNames) {
    for (uint256 i = 0; i < candidateNames.length; i++) {
        candidates.push(Candidate({
        name: candidateNames[i],
        voteCount: 0
        }));
    }
    }

    function vote(uint256 candidateIndex) public {
    require(candidateIndex < candidates.length, "Invalid candidate Index");
    require(!voters[msg.sender], "You have already voted!");

    voters[msg.sender] = true;
    candidates[candidateIndex].voteCount++;

    emit Voted(msg.sender, candidateIndex);
    }

    function getWinner() public returns (string memory winnerName, uint256 winningVoteCount) {
    uint256 maxVotes = 0;
    uint256 winningCandidateIndex = 0;

    for (uint256 i = 0; i < candidates.length; i++){
        if(candidates[i].voteCount > maxVotes){
            maxVotes = candidates[i].voteCount;
            winningCandidateIndex = i;
        }
    }
    
    emit WinnerDeclared(candidates[winningCandidateIndex].name, maxVotes);
    return (candidates[winningCandidateIndex].name, maxVotes);
    }
}