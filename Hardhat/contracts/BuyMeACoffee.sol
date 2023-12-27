// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract BuyMeACoffee {
    ///////////////////////
    // Type declarations //
    ///////////////////////
    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }

    
    /////////////////////////
    // State variables //////
    /////////////////////////
    address payable immutable i_owner;
    Memo[] memos; // list of all memos received from friends

    /////////////////
    //  Events //////
    /////////////////
    event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );

    /////////////////
    //  Errors //////
    /////////////////
    error EthSentCannotBeZero();

    /////////////////
    //  Functions ///
    /////////////////
    constructor() {
        i_owner = payable(msg.sender);
    }

    /**
     * @dev buy contract owner a coffee 
     * @param name name of the coffee buyer
     * @param message a nice message from the coffee buyer to the contract owner
     */
    function buyCoffee(string memory name, string memory message) external payable {
        if (msg.value == 0) revert EthSentCannotBeZero();

        // Add the memo to storage
        memos.push(Memo(msg.sender, block.timestamp, name, message));

        // Emit an event when a new memo is created
        emit NewMemo(msg.sender, block.timestamp, name, message);
    }
    
    /**
     * @dev retrieve all the memos received and stored on the blockchain
     */
    function getMemos() external view returns (Memo[] memory) {
        return memos;
    }

    /**
     * @dev send the entire balance stored in this contract to the owner
     */
    function withdrawTips() external {
        require(i_owner.send(address(this).balance));
    }
}
