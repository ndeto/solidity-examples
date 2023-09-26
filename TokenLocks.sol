// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

contract TokenLocks{
  struct TokenLock {
    address user;
    uint256 amount;
    uint256 duration;
    uint256 releaseTime;
    bool released;
  }

  event TokensLocked(address indexed user, uint256 amount, uint256 duration, uint256 releaseTime);
  event TokensReleased(address indexed user, uint256 amount);

  mapping(address => uint256) public balances;
  TokenLock[] public tokenLocks;

  function lockTokens(uint256 amount, uint256 duration) public {
    require(amount > 0, "Amount must be greater than 0");
    require(balances[msg.sender] >= amount, "Insufficient balance");

    uint256 releaseTime = block.timestamp + duration;

    TokenLock memory newLock = TokenLock({
      user: msg.sender,
      amount: amount,
      duration: duration,
      releaseTime: releaseTime,
      released: false
    });

    balances[msg.sender] -= amount;
    tokenLocks.push(newLock);

    emit TokensLocked(msg.sender, amount, duration, releaseTime);
  }

  function releaseTokens(uint256 lockIndex) public {
    require(lockIndex < tokenLocks.length, "Invalid lock index");
    TokenLock storage lock = tokenLocks[lockIndex];
    require(!lock.released, "Tokens already released");
    require(block.timestamp >= lock.releaseTime, "It's not yet the release time for these tokens!");

    balances[lock.user] += lock.amount;
    lock.released = true;

    emit TokensReleased(lock.user, lock.amount);
  }

  function mint(uint256 amount) public {
      balances[msg.sender] += amount;
  }
}