### `ElectionOracle` Contract - README

---

**Version:** Solidity ^0.8.25  
**Ownership:** `AccessControl` and `Ownable` implementation using OpenZeppelin libraries.

---

## Overview

The `ElectionOracle` smart contract is designed to store and finalize the results of an election. An `ORACLE_ROLE` is responsible for finalizing the results once the election period has ended. The contract owner can manage these roles and transfer ownership as needed. After finalization, election results can be accessed by other contracts or external parties.

---

## Contract Roles

### `DEFAULT_ADMIN_ROLE` and `ORACLE_ROLE`

- **`DEFAULT_ADMIN_ROLE`**: This role is typically assigned to the contract's owner. It allows managing the contract's roles, including granting and revoking the `ORACLE_ROLE`.
- **`ORACLE_ROLE`**: This role is responsible for finalizing the election results. Only the addresses assigned this role can finalize the election results after the election period ends.

### Contract Owner Responsibilities

- Can **transfer ownership** to a new address using the `transferOwnership` function.
- Can **grant and revoke** the `ORACLE_ROLE`.

---

## Key Functions

### `finalizeElectionResult()`

```solidity
function finalizeElectionResult(ElectionResult _finalResult) external onlyRole(ORACLE_ROLE)
```

This function allows an address with the `ORACLE_ROLE` to finalize the election result. It can only be called after `minEndOfElectionTimestamp`, which indicates when the election period has ended. The function also ensures that the result has not already been finalized.

### `getElectionResult()`

```solidity
function getElectionResult() external view returns (ElectionResult)
```

This function returns the finalized election result. It can only be called after the result has been finalized.

### `isElectionFinalized()`

```solidity
function isElectionFinalized() external view returns (bool)
```

Checks if the election has been finalized and returns `true` if it has, otherwise `false`.

### Other Functions

- **`transferOwnership(address newOwner)`**: Transfers the ownership and updates the `DEFAULT_ADMIN_ROLE`.
- **`grantOracleRole(address account)`**: Grants the `ORACLE_ROLE` to the specified address; only the owner can call this.
- **`revokeOracleRole(address account)`**: Revokes the `ORACLE_ROLE` from the specified address; only the owner can call this.

---

## Deploying the Contract

```json
{
  "oracle": "0x123456789abcdef0123456789abcdef012345678",
  "_minEndOfElectionTimestamp": "1730965200"
}
```

Use the constructor to deploy the contract where:

- `oracle`: The address to be assigned the `ORACLE_ROLE`.
- `_minEndOfElectionTimestamp`: The Unix timestamp representing when the election period ends (e.g., November 7, 2024, 00:00:00 EST).

Example constructor call:

```solidity
address oracle = 0x123456789abcdef0123456789abcdef012345678;
uint256 minTimestamp = 1730965200; // November 7, 2024, 00:00:00 EST
ElectionOracle oracleContract = new ElectionOracle(oracle, minTimestamp);
```

---

## ABI & Interface for Consumption

### ABI

Here’s the simplified ABI for the key functions in the `ElectionOracle` contract:

```json
[
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "oracle",
        "type": "address"
      },
      {
        "internalType": "uint256",
        "name": "_minEndOfElectionTimestamp",
        "type": "uint256"
      }
    ],
    "name": "ElectionOracle",
    "stateMutability": "nonpayable",
    "type": "constructor"
  },
  {
    "inputs": [],
    "name": "getElectionResult",
    "outputs": [
      {
        "internalType": "uint8",
        "name": "",
        "type": "uint8"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "isElectionFinalized",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint8",
        "name": "_finalResult",
        "type": "uint8"
      }
    ],
    "name": "finalizeElectionResult",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "newOwner",
        "type": "address"
      }
    ],
    "name": "transferOwnership",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "account",
        "type": "address"
      }
    ],
    "name": "grantOracleRole",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "account",
        "type": "address"
      }
    ],
    "name": "revokeOracleRole",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }
]
```

### Interface

```solidity
interface IElectionOracle {
    enum ElectionResult {
        NotSet,  // Initial/default value when the election result has not been set yet
        Trump,   // Election result for candidate Trump
        Harris,  // Election result for candidate Harris
        Other    // Election result for any other candidate
    }

    // Function to retrieve the finalized election result.
    function getElectionResult() external view returns (ElectionResult);

    // Function to check if the election has been finalized.
    function isElectionFinalized() external view returns (bool);
}
```

---

## Retrieving the Election Result from Another Contract

To retrieve and consume the election result in another smart contract, you'll need to interact with the `ElectionOracle` contract using the provided interface. Here’s how you can do that:

### Example Consumption Contract

```solidity

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

interface IElectionOracle {
    enum ElectionResult {
        NotSet,  // Initial/default value when the election result has not been set yet
        Trump,   // Election result for candidate Trump
        Harris,  // Election result for candidate Harris
        Other    // Election result for any other candidate
    }

    function getElectionResult() external view returns (ElectionResult);
    function isElectionFinalized() external view returns (bool);
}

contract ElectionConsumer {

    IElectionOracle public oracle;

    constructor(address _oracleAddress) {
        oracle = IElectionOracle(_oracleAddress);
    }

    function retrieveFinalResult() external view returns (IElectionOracle.ElectionResult) {
        bool isFinalized = oracle.isElectionFinalized();
        require(isFinalized, "Election result has not been finalized yet.");

        return oracle.getElectionResult();
    }

    function getReadableResult() external view returns (string memory) {
        bool isFinalized = oracle.isElectionFinalized();
        require(isFinalized, "Election result has not been finalized yet.");

        IElectionOracle.ElectionResult result = oracle.getElectionResult();

        // Mapping result enum to a human-readable string
        if (result == IElectionOracle.ElectionResult.NotSet) return "Not Set";
        if (result == IElectionOracle.ElectionResult.Trump) return "Trump";
        if (result == IElectionOracle.ElectionResult.Harris) return "Harris";
        if (result == IElectionOracle.ElectionResult.Other) return "Other";
        return "Unknown";
    }
}
```

### Key Features of the Example Contract:

- **`retrieveFinalResult`**: Fetches the raw election result.
- **`getReadableResult`**: Maps the `ElectionResult` enum to a readable string (e.g., "Trump", "Harris").

### Deployment Instructions:

- Deploy `ElectionOracle` on your network with your chosen oracle and timestamp.
- Use the deployed `ElectionOracle` contract address in your consumer contract when deploying `ElectionConsumer`.

```solidity
ElectionConsumer consumer = new ElectionConsumer(oracleAddress);
```

---

## Conclusion

The `ElectionOracle` contract securely manages and finalizes election results, with strict access control using roles managed by the contract owner. The usage of the contract is transparent, with event emissions and role checks ensuring a robust mechanism for managing election results on the blockchain.

The provided example consumer contract demonstrates a straightforward way to interface with `ElectionOracle`, making it easy for other contracts to consume and interpret finalized election outcomes.

Explanation
Enum in the Interface:
The enum ElectionResult is now included in the IElectionOracle interface, which allows any contract implementing or interacting with this interface to understand the possible outcome values.
Usage of Enum:
Methods like retrieveFinalResult and getReadableResult in the ElectionConsumer contract use the ElectionResult enum to fetch and process the result.
Key Points for External Interaction
When you interact with the ElectionOracle contract from another contract (like ElectionConsumer), having the enum defined in the interface ensures that the contract knows about all possible election outcomes.
This approach also avoids any potential issues related to passing integers around without clearly defined meaning, enhancing both security and code clarity.
Deploying and Using the Contracts
Deploy the ElectionOracle contract with the constructor parameters (oracle address and \_minEndOfElectionTimestamp).
Deploy the ElectionConsumer contract using the address of the deployed ElectionOracle contract.
Interact with ElectionConsumer functions to retrieve the results based on the election outcome.
This method provides a clean, maintainable, and secure way to handle the election results, making your smart contracts modular and easy to interact with.
