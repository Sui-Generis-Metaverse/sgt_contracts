// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/release-v4.3/contracts/token/ERC20/IERC20.sol";
import "./ISGT.sol";

interface ISGTController {
    /**
     * @dev mints `amount` tokens to account `to`
     *
     * Emits a {Transfer} event.
     */
    function mint(address to, uint256 amount) external;
    
    /**
     * @dev burns `amount` tokens from account `from`
     *
     * Emits a {Transfer} event.
     */
    function burn(address from, uint256 amount) external;
    
    function linkTGE (address tge, uint256 tgeMintAmount) external;

    function deactivateController(address newOwner) external;
    
    function rescueTokens(IERC20 token, uint256 value) external;
    
    function token() external returns (ISGT);
    
    event TokensRescued(address indexed sender, address indexed token, uint256 value);
    
    event TgeLinked(address tgeAddress);
    
    event SupplyBootstrap(address tgeAddress, uint256 amount);
}