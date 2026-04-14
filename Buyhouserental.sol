// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BayHouseRental {
    address payable public owner;
    bool public available;
    uint256 public ratePerDay;

    event Log(address indexed sender, string message);

    constructor() {
        owner = payable(msg.sender);
        available = true;
        ratePerDay = 2 ether;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can use this function.");
        _;
    }

    modifier onlyWhenAvailable() {
        require(available == true, "Bay House is not available");
        _;
    }

    function bookBayHouse(uint256 numDay) public payable onlyWhenAvailable {
        uint256 minOffer = ratePerDay * numDay;
        require(msg.value >= minOffer, "Insufficient payment");

        available = false;

        emit Log(msg.sender, "Bay House booked successfully.");
        emit Log(owner, "Bay House has been booked.");
    }

    function makeBayHouseAvailable() public onlyOwner {
        available = true;
    }

    function transferOwnership(address payable newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
    }

    function updateRate(uint256 newRate) public onlyOwner {
        ratePerDay = newRate;
        emit Log(msg.sender, "Bay House rate updated.");
    }

    function withdraw() public onlyOwner {
        (bool sent, ) = owner.call{value: address(this).balance}("");
        require(sent, "Failed to withdraw");
    }
}