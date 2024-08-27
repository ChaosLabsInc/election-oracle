// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "../lib/openzeppelin-contracts/contracts/access/AccessControl.sol";

contract ElectionOracle is AccessControl {
    // Enum representing the possible election outcomes
    enum ElectionResult {
        NotSet, // Initial/default value when the election result has not been set yet
        Trump, // Election result for candidate Trump
        Harris, // Election result for candidate Harris
        Other // Election result for any other candidate
    }

    // State variables
    ElectionResult public result; // Holds the finalized election result
    bool public isResultFinalized; // Indicates whether the election result has been finalized
    address public owner; // Owner of the contract with special privileges
    uint256 public minEndOfElectionTimestamp; // Timestamp marking the earliest time the election can be finalized
    uint256 public resultFinalizationTimestamp; // Timestamp when the election result was finalized

    // Role identifiers
    bytes32 public constant ORACLE_ROLE = keccak256("ORACLE_ROLE"); // Role identifier for the Oracle responsible for finalizing results

    // Events emitted by the contract
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    event ElectionFinalized(
        ElectionResult indexed finalResult,
        uint256 indexed timestamp
    );

    /**
     * @dev Constructor to initialize the contract.
     * @param oracle The address being assigned the ORACLE_ROLE to finalize the election result.
     * @param _minEndOfElectionTimestamp The minimum timestamp marking the end of the election period before it can be finalized.
     */
    constructor(address oracle, uint256 _minEndOfElectionTimestamp) {
        owner = msg.sender; // Sets the owner to the address deploying the contract (msg.sender)

        // Grant DEFAULT_ADMIN_ROLE to the contract deployer (msg.sender)
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

        // Grant the ORACLE_ROLE to the specified oracle address
        _grantRole(ORACLE_ROLE, oracle);

        // Ensure the provided minEndOfElectionTimestamp is in the future
        require(
            _minEndOfElectionTimestamp > block.timestamp,
            "minEndOfElectionTimestamp must be in the future."
        );
        minEndOfElectionTimestamp = _minEndOfElectionTimestamp;

        // Initialize result-related state variables
        result = ElectionResult.NotSet;
        isResultFinalized = false;
    }

    /**
     * @dev Modifier to restrict access to the owner of the contract.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    /**
     * @dev Function to finalize the election result.
     * Can only be called by an address with the ORACLE_ROLE after the election period ends.
     * @param _finalResult The final result of the election.
     */
    function finalizeElectionResult(
        ElectionResult _finalResult
    ) external onlyRole(ORACLE_ROLE) {
        // Ensure finalization is only possible after the election period ends
        require(
            block.timestamp >= minEndOfElectionTimestamp,
            "Cannot finalize before the end of the election period."
        );
        // Ensure the result has not been finalized previously
        require(
            result == ElectionResult.NotSet,
            "Election result is already finalized."
        );

        // Set the final result and mark it as finalized
        result = _finalResult;
        isResultFinalized = true;
        resultFinalizationTimestamp = block.timestamp;

        // Emit an event documenting the finalization
        emit ElectionFinalized(_finalResult, block.timestamp);
    }

    /**
     * @dev Function to retrieve the finalized election result.
     * Can only be called after the election has been finalized.
     * @return The finalized election result.
     */
    function getElectionResult() external view returns (ElectionResult) {
        // Ensure the result has been finalized before returning it
        require(isResultFinalized, "Election has not been finalized yet");
        return result;
    }

    /**
     * @dev Function to check if the election has been finalized.
     * @return Boolean indicating if the election has been finalized.
     */
    function isElectionFinalized() external view returns (bool) {
        return isResultFinalized;
    }

    /**
     * @dev Function to transfer contract ownership to a new owner.
     * Ensures the newOwner is not the zero address.
     * Updates the DEFAULT_ADMIN_ROLE to the new owner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) external onlyOwner {
        require(
            newOwner != address(0),
            "New owner address cannot be the zero address"
        );

        // Grant the new owner the admin role and revoke it from the current owner
        grantRole(DEFAULT_ADMIN_ROLE, newOwner);
        revokeRole(DEFAULT_ADMIN_ROLE, owner);

        emit OwnershipTransferred(owner, newOwner); // Emit the ownership transfer event
        owner = newOwner; // Update the owner
    }

    /**
     * @dev Function to grant the Oracle role to a specified account.
     * Can only be called by the contract owner.
     * @param account The address to grant the ORACLE_ROLE to.
     */
    function grantOracleRole(address account) external onlyOwner {
        grantRole(ORACLE_ROLE, account);
    }

    /**
     * @dev Function to revoke the Oracle role from a specified account.
     * Can only be called by the contract owner.
     * @param account The address to revoke the ORACLE_ROLE from.
     */
    function revokeOracleRole(address account) external onlyOwner {
        revokeRole(ORACLE_ROLE, account);
    }
}
