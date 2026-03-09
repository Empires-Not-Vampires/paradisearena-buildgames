// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ParadiseArenaEscrow {
    uint256 public constant ENTRY_FEE = 0.1 ether;
    uint256 public constant PLATFORM_FEE = 0.01 ether;
    uint256 public constant BAG_AMOUNT = 0.09 ether;

    address public operator;
    address public platformWallet;

    mapping(address => uint256) public playerBags;

    event PlayerEntered(address indexed player, uint256 bagAmount);
    event BagTransferred(address indexed from, address indexed to, uint256 amount);
    event PlayerExited(address indexed player, uint256 bagAmount);
    event PlayerEliminated(address indexed victim, address indexed killer, uint256 bagAmount);

    modifier onlyOperator() {
        require(msg.sender == operator, "Not operator");
        _;
    }

    constructor(address _operator, address _platformWallet) {
        operator = _operator;
        platformWallet = _platformWallet;
    }

    function enterArena(address player) external payable {
        require(msg.value == ENTRY_FEE, "Must send exactly 0.1 AVAX");
        require(player != address(0), "Invalid player address");

        playerBags[player] += BAG_AMOUNT;

        (bool sent, ) = platformWallet.call{value: PLATFORM_FEE}("");
        require(sent, "Platform fee transfer failed");

        emit PlayerEntered(player, BAG_AMOUNT);
    }

    function transferBag(address from, address to, uint256 amount) external onlyOperator {
        require(playerBags[from] >= amount, "Insufficient bag balance");
        require(from != address(0) && to != address(0), "Invalid address");

        playerBags[from] -= amount;
        playerBags[to] += amount;

        emit BagTransferred(from, to, amount);
        emit PlayerEliminated(from, to, amount);
    }

    function exitArena(address player, uint256 amount) external onlyOperator {
        require(playerBags[player] >= amount, "Insufficient bag balance");
        require(player != address(0), "Invalid player address");

        playerBags[player] -= amount;

        (bool sent, ) = player.call{value: amount}("");
        require(sent, "Exit transfer failed");

        emit PlayerExited(player, amount);
    }

    function getPlayerBag(address player) external view returns (uint256) {
        return playerBags[player];
    }

    receive() external payable {}
}
