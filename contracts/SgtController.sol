//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/release-v4.3/contracts/access/AccessControl.sol";
import "./interfaces/ISGT.sol";
import "./interfaces/ISGTController.sol";
import "./interfaces/ITGE.sol";

contract TokenController is AccessControl, ISGTController {
    ISGT public override token;

    address public tgeAddress;
    bool public tgeLinked;
    bool public supplyBootstrapped;
    bool public controllerIsActive;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant LINKER_ROLE = keccak256("LINKER_ROLE");

    modifier controllerActive() {
        require(controllerIsActive, "controller not active");
        _;
    }

    constructor(ISGT tokenAddress) {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        token = tokenAddress;
        controllerIsActive = true;
    }

    function linkTGE(address tge, uint256 tgeMintAmount)
        external
        override
        onlyRole(LINKER_ROLE)
    {
        grantRole(MINTER_ROLE, tgeAddress);
        tgeAddress = tge;
        _bootstrapSupply(tgeMintAmount);
        ITGE(tge).setSupplyBootstrapped(tgeMintAmount);
        emit TgeLinked(tgeAddress);
    }

    function _bootstrapSupply(uint256 amount) internal {
        require(!supplyBootstrapped, "tokenController: supply already bootstrapped");

        supplyBootstrapped = true;
        token.mint(tgeAddress, amount);

        emit SupplyBootstrap(tgeAddress, amount);
    }

    function mint(address toAddress, uint256 amount)
        public
        override
        onlyRole(MINTER_ROLE)
    {
        token.mint(toAddress, amount);
    }

    function burn(address fromAddress, uint256 amount)
        public
        override
        onlyRole(BURNER_ROLE)
    {
        token.burn(fromAddress, amount);
    }

    function deactivateController(address newController)
        external
        override
        onlyRole(LINKER_ROLE)
    {
        controllerIsActive = false;
        token.transferTokenOwnership(newController);
    }

    function rescueTokens(IERC20 foreignToken, uint256 value)
        external
        override
        onlyRole(LINKER_ROLE)
    {
        foreignToken.transfer(_msgSender(), value);

        emit TokensRescued(_msgSender(), address(token), value);
    }
}
