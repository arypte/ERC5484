// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./ERC5484.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract test5484 is ERC5484 , Ownable {

    address private _issuer;

    constructor( string memory name, string memory symbol , address owner_ ) ERC721( name, symbol ) Ownable( owner_ ) {
        _transferOwnership( owner_ );
    }

    function issuer() public view returns( address ) {
        return _issuer;
    }

    function setIssuser( address issuser_ ) public onlyOwner() {
        _issuer = issuser_;
    }

    function testMint( address to , uint tokenId ) public {
        _mintSbt( to, tokenId );
    }

    function testBurn( uint tokenId ) public {
        _burnSbt( tokenId );
    }

}