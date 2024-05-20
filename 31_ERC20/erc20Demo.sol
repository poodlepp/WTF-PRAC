// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

/**
 * 31  ERC20
 * 余额
 * 转账
 * 授权转账
 * 总供给
 * name symbol
 */

abstract contract Erc20Demo {
    //error
    error Erc20Demo__MintIsOnlyAllowedByOwner();
    error Erc20Demo__generalError();
    //event 2
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    //state
    string private _name;
    string private _symbol;
    mapping(address account => uint256) private _balances;
    address public owner;
    mapping(address account => mapping(address spender => uint256)) _allowance;
    uint256 private _totalSupply;

    //function 6

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
        owner = msg.sender;
    }

    function mint(address to, uint256 amount) public returns (bool success) {
        if(msg.sender != owner){
            revert Erc20Demo__MintIsOnlyAllowedByOwner();
        }
        uint256 balance = balanceOf(to);
        _balances[to] = balance + amount;
        return true;
    }

    function transfer(address to, uint256 amount) public returns (bool success) {
        if(amount <= 0) {
            revert Erc20Demo__generalError();
        }
        if(balanceOf(msg.sender) < amount) {
            revert Erc20Demo__generalError();
        }
        _balances[msg.sender] -= amount;
        _balances[to] += amount;
        emit Transfer(msg.sender,to,amount);
        return true;
    }

    function approve(address to, uint256 amount) public returns (bool success) {
        if(amount <= 0) {
            revert Erc20Demo__generalError();
        }
        if(balanceOf(msg.sender) < amount) {
            revert Erc20Demo__generalError();
        }
        _allowance[msg.sender][to] = amount;
        emit Approval(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool success) {
        if(amount <= 0) {
            revert Erc20Demo__generalError();
        }
        if(from == msg.sender) {
            transfer(to,amount);
        }else {
            if(allowance[msg.sender][from] < amount) {
                revert Erc20Demo__generalError();
            }
            _allowance[msg.sender][from] -= amount;
            _balances[from] -= amount;
            _balances[to] += amount;
            emit Transfer(from, to, amount);
        }
        return true;
    }

    function mint(uint256 amount) public {
        _balances[msg.sender] += amount;
        _totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint256 amount) public {
        _balances[msg.sender] -= amount;
        _totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    function balanceOf(address addr) public view virtual returns (uint256 amount) {
        amount = _balances[addr];
    }

    function decimals() public view virtual returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }

    /**
     * abstract ERC20
     * 
     * constructor
     * name
     * symbol
     * decimals
     * totalSupply
     * balanceOf
     * 
     * 
     * transfer
     * allownance
     * approve
     * transferFrom
     * _transfer
     * _update
     * _mint
     * _burn
     * _approve * 2
     * _spendAllowance
     * 
     */



}