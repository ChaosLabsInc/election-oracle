// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract ElectionOracle is AccessControl {
    // Enum for the possible election outcomes
    enum ElectionResult {
        NotSet,
        Trump,
        Harris,
        Other
    }

    // State variables
    ElectionResult public result; // Election result
    bool public isResultFinalized; // Whether the election result is finalized
    address public owner; // Owner of the contract
    uint256 public resultProposalTimestamp; // Timestamp when the result was proposed
    uint256 public resultFinalizationTimestamp; // Timestamp when the result was finalized

    // Role definition for ADMIN
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    // Events
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event ElectionProposed(ElectionResult proposedResult, uint256 timestamp);
    event ElectionFinalized(ElectionResult finalResult, uint256 timestamp);

    constructor(address admin) {
        // Assign deployer as the initial owner
        owner = msg.sender;
        // Grant admin role to the deployer
        _setupRole(ADMIN_ROLE, admin);
        // Set the role admin as ADMIN_ROLE
        _setRoleAdmin(ADMIN_ROLE, ADMIN_ROLE);
        // Initialize state variables
        result = ElectionResult.NotSet;
        isResultFinalized = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // Function to transfer ownership
    function transferOwnership(address newOwner) external onlyOwner {
        require(
            newOwner != address(0),
            "New owner address cannot be the zero address"
        );
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    // Function to propose the election result (can be called multiple times before finalization)
    function proposeElectionResult(
        ElectionResult _proposedResult
    ) external onlyRole(ADMIN_ROLE) {
        require(!isResultFinalized, "Election result is already finalized");
        result = _proposedResult;
        resultProposalTimestamp = block.timestamp;
        emit ElectionProposed(_proposedResult, block.timestamp);
    }

    // Function to finalize the election result
    function finalizeElectionResult() external onlyRole(ADMIN_ROLE) {
        require(
            result != ElectionResult.NotSet,
            "Result has not been proposed yet"
        );
        require(!isResultFinalized, "Election result is already finalized");
        isResultFinalized = true;
        resultFinalizationTimestamp = block.timestamp;
        emit ElectionFinalized(result, block.timestamp);
    }

    // Function to retrieve election result (for external contracts)
    function getElectionResult() external view returns (ElectionResult) {
        require(isResultFinalized, "Election has not been finalized yet");
        return result;
    }

    // Function to check if the election has been finalized
    function isElectionFinalized() external view returns (bool) {
        return isResultFinalized;
    }
}
