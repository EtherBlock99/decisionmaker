// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract DecisionMain is ERC20, Ownable, ReentrancyGuard {

    uint256 public usersCount; // Declare the usersCount variable
    address[] public registeredUserAddresses; // Declare the array to store registered user addresses

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

    //function to check the current supply of DMT tokens
    function getContractBalance() external view returns(uint256){
        return balanceOf(address (this));
    }


    struct User {
    address userAddress;
    string username;
    }

    mapping(address => User) public users;
    mapping(string => address) public usernameToAddress;

    function registerUser(string memory _username) external {
    require(users[msg.sender].userAddress == address(0), "User already registered");
    
    User storage newUser = users[msg.sender];
    newUser.userAddress = msg.sender;
    newUser.username = _username;

     registeredUserAddresses.push(msg.sender); // Add the user's address to the array
     usersCount++; // Increment the user count
    
    }

    //Get single user wallet address by user name only the owner
    function getUserInfo(address _userAddress) external view returns (User memory) {
    require(msg.sender == owner(), "Only the owner can retrieve user details");
    return users[_userAddress];
    } 

    //Get all users names and wallet address for owner
    function getAllUserDetails() external view onlyOwner returns (User[] memory) {
    User[] memory userDetails = new User[](usersCount); 
    
    for (uint256 i = 0; i < usersCount; i++) {
        userDetails[i] = users[registeredUserAddresses[i]];
    }
    
    return userDetails;
    }


    //removing registered user by only owner 
    function removeUserByUsername(string memory _username) external onlyOwner {
    address userAddress = usernameToAddress[_username];
    require(userAddress != address(0), "User not found");
    
    // Find the index of the user's address in the array
    uint256 userIndex = getUserIndex(userAddress);

    // Swap the user's address with the last address in the array
    uint256 lastIndex = registeredUserAddresses.length - 1;
    address lastAddress = registeredUserAddresses[lastIndex];
    registeredUserAddresses[userIndex] = lastAddress;
    registeredUserAddresses.pop();

    // Decrement the user count
    usersCount--;

    // Remove user data from the mappings
    delete users[userAddress];
    delete usernameToAddress[_username];
    }

    // Helper function to get the index of a user's address in the array
    function getUserIndex(address userAddress) internal view returns (uint256) {
    for (uint256 i = 0; i < registeredUserAddresses.length; i++) {
        if (registeredUserAddresses[i] == userAddress) {
            return i;
        }
    }
    revert("User not found in the array");
    }


}

