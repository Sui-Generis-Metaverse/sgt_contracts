//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/release-v4.3/contracts/access/Ownable.sol";
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/release-v4.3/contracts/token/ERC20/ERC20.sol";
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/release-v4.3/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/release-v4.3/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "./interfaces/ISGT.sol";

contract Token is Ownable, ERC20, ERC20Permit, ERC20Votes, ISGT {
    constructor() ERC20("MyToken", "MTK") ERC20Permit("MyToken") {}

    function mint(address to, uint256 amount) public override onlyOwner {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public override onlyOwner {
        _burn(from, amount);
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Votes) {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }

    function renounceTokenOwnership() external override onlyOwner {
        renounceOwnership();
    }

    function transferTokenOwnership(address newOwner)
        external
        override
        onlyOwner
    {
        transferOwnership(newOwner);
    }

    function rescueTokens(IERC20 token, uint256 value)
        external
        override
        onlyOwner
    {
        token.transfer(_msgSender(), value);

        emit TokensRescued(_msgSender(), address(token), value);
    }
}
