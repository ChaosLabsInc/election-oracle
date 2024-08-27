// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/ElectionOracle.sol";

contract DeployElectionOracle is Script {
    function run() external {
        // Begin broadcasting transactions
        vm.startBroadcast();

        // Address for the oracle. This address will be responsible for finalizing the election result.
        address oracle = 0x1234567890123456789012345678901234567890; // replace with actual oracle address

        // Set the minimum end of election timestamp
        // 1730878800 corresponds to November 6, 2024, 00:00:00 EST (midnight EST).
        // This timestamp was chosen because the 2024 U.S. Presidential Election will be held on November 5, 2024.
        // We allow 24 hours (to account for potential delays in election processes such as counting votes, mail-in ballots, etc.)
        // before allowing the election result to be finalized on the blockchain.
        uint256 expectedEndOfElectionTimestamp = 1730878800; // November 6, 2024, 00:00:00 EST (midnight EST)
        uint256 minEndOfElectionTimestamp = expectedEndOfElectionTimestamp +
            24 hours;

        // Deploy the ElectionOracle contract
        ElectionOracle electionOracle = new ElectionOracle(
            oracle,
            minEndOfElectionTimestamp
        );

        // Print the address of the deployed contract
        console.log("ElectionOracle deployed at:", address(electionOracle));

        // End broadcasting transactions
        vm.stopBroadcast();
    }
}
