// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/ElectionOracle.sol";

contract ElectionOracleTest is Test {
    ElectionOracle public electionOracle;
    address admin = address(0x1234);

    function setUp() public {
        electionOracle = new ElectionOracle(admin);
    }

    function testProposeAndFinalizeElectionAsAdmin() public {
        vm.startPrank(admin);
        electionOracle.proposeElectionResult(
            ElectionOracle.ElectionResult.Harris
        );
        assertEq(
            uint(electionOracle.result()),
            uint(ElectionOracle.ElectionResult.Harris)
        );
        assertEq(electionOracle.resultProposalTimestamp(), block.timestamp);
        emit log_named_uint(
            "Proposal timestamp",
            electionOracle.resultProposalTimestamp()
        );

        electionOracle.finalizeElectionResult();
        assertTrue(electionOracle.isResultFinalized());
        assertEq(
            electionOracle.getElectionResult(),
            ElectionOracle.ElectionResult.Harris
        );
        assertEq(electionOracle.resultFinalizationTimestamp(), block.timestamp);
        emit log_named_uint(
            "Finalization timestamp",
            electionOracle.resultFinalizationTimestamp()
        );
        vm.stopPrank();
    }

    function testOnlyAdminCanProposeAndFinalize() public {
        // Try to propose a result without being the admin
        vm.expectRevert();
        electionOracle.proposeElectionResult(
            ElectionOracle.ElectionResult.Trump
        );

        // Try to finalize a result without being the admin
        vm.expectRevert();
        electionOracle.finalizeElectionResult();
    }

    function testOwnershipTransfer() public {
        address newOwner = address(0x5678);
        // Transfer ownership
        electionOracle.transferOwnership(newOwner);
        assertEq(electionOracle.owner(), newOwner);

        vm.prank(newOwner);
        // Verify the new owner can still operate normally.
        electionOracle.transferOwnership(admin);
        assertEq(electionOracle.owner(), admin);
    }
}
