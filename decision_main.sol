// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract DecisionMain is ERC20, Ownable, ReentrancyGuard {
    constructor() ERC20("Vote", "DMT") {
        uint256 initialSupply = 100 * 10**decimals();
        _mint(address(this), initialSupply); // Mint tokens to the contract's address
    }

    // Function to allow the owner to generate additional tokens
    function generateTokens(uint256 amount) external onlyOwner {
        // Check that the caller is the owner
        require(msg.sender == owner(), "Only the owner can generate tokens");
        
        // Mint the requested amount of tokens to the contract's address
        _mint(address(this), amount);
    }


}
