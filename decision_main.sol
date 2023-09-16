// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract DecisionMain is ERC20, Ownable, ReentrancyGuard {
    constructor() ERC20("Vote", "DMT") {
        uint256 initialSupply = 100;   //* 10**decimals();
        _mint(address(this), initialSupply); // Mint tokens to the contract's address
    }

    // Function to allow the owner to generate additional tokens
    function generateTokens(uint256 amount) external onlyOwner {
        // Check that the caller is the owner
        require(msg.sender == owner(), "Only the owner can generate tokens");
        
        // Mint the requested amount of tokens to the contract's address
        _mint(address(this), amount);
    }

    // Function to get the current total supply of tokens
    function getTotalSupply() external view returns (uint256) {
    return totalSupply();
    }


    struct User {
    address userAddress;
    string username;
    }

    mapping(address => User) public users;

    function registerUser(string memory _username) external {
    require(users[msg.sender].userAddress == address(0), "User already registered");
    
    User storage newUser = users[msg.sender];
    newUser.userAddress = msg.sender;
    newUser.username = _username;
    
    }

    function getUserInfo(address _userAddress) external view returns (User memory) {
    return users[_userAddress];
    }



}
