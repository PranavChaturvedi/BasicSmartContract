// SPDX-License-Identifier: GPL-3.0

// ["0x666f6f0000000000000000000000000000000000000000000000000000000000","0x6261720000000000000000000000000000000000000000000000000000000000","0x676f6f0000000000000000000000000000000000000000000000000000000000","0x677f6f0000000000000000000000000000000000000000000000000000000000"]

pragma solidity >=0.7.0 <0.9.0;

contract Ballot {

    struct Voter {
        uint rights;
        bool voted;
        uint vote;
        uint wallet;
    }

    struct Proposal {
        bytes32 name;
        uint voteCount;
    }


    address public chairperson;
    mapping(address => Voter) public voters;
    Proposal[] public proposals;

    //Array of miners

    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].rights = 1;

        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    function giveRightToVote(address voter) public {
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].rights == 0);
        voters[voter].rights = 1;
    }

    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(sender.rights != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;
        sender.wallet = sender.wallet + 1;
        proposals[proposal].voteCount += sender.rights;
    }

    function winningProposal() public view
            returns (uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    function winnerName() public view
            returns (bytes32 winnerName_)
    {
        winnerName_ = proposals[winningProposal()].name;
    }
}
