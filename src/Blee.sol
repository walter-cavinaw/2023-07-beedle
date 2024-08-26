// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Ownable} from "./utils/Ownable.sol";
import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {ERC20Votes} from "openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Votes.sol";
import {Nonces} from "openzeppelin-contracts/contracts/utils/Nonces.sol";

contract Blee is Ownable, ERC20, ERC20Permit, ERC20Votes {

    constructor() ERC20("Blee", "BDL") ERC20Permit("Blee") Ownable(msg.sender) {
        _mint(msg.sender, 1_000_000_000 * 1e18);
    }
    
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Votes) {
        super._update(from, to, value);
    }

    function nonces(address owner) public view override(ERC20Permit, Nonces) returns (uint256) {
        return super.nonces(owner);
    }

}