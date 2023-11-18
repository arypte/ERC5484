// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./IERC5484.sol" ;

// OwnerOnly : 회원권? 권리가 Owner 있는것 가정.

abstract contract ERC5484 is ERC721 , IERC5484 {

    mapping( uint => BurnAuth ) private burnAuthState;

    function _setBurnState( uint tokenId, BurnAuth burnAuthType ) internal {
        burnAuthState[ tokenId ] = burnAuthType;
    }

    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory data) internal override  {
           revert( "Transfer is not allowed" );
    }

    function _checkBurnAuth( uint tokenId , address spender ) internal view virtual returns( bool ) {
        require( burnAuthState[ tokenId ] != BurnAuth.Neither , "Invaild burn state" );
        return spender == _ownerOf( tokenId );
    }

    function _mintSbt( address to, uint tokenId ) internal virtual  {
        _safeMint( to, tokenId );
        _setBurnState( tokenId, BurnAuth.OwnerOnly );
        emit Issued( msg.sender, to, tokenId, BurnAuth.OwnerOnly );
    }

    function _burnSbt( uint tokenId ) internal virtual {
        _requireOwned( tokenId );
        _checkBurnAuth( tokenId , _msgSender() ) ;
        _setBurnState( tokenId, BurnAuth.Neither ); // 재발행이 불가능
        _burn( tokenId ) ;
    }

    function supportsInterface( bytes4 interfaceId ) public view virtual override( ERC721 ) returns ( bool ) {
        return interfaceId == type( IERC5484 ).interfaceId ||
            super.supportsInterface( interfaceId );
    }

    function burnAuth( uint tokenId ) public view override returns ( BurnAuth ) {
        return burnAuthState[ tokenId ];
    }

    function transferFrom( address from , address to , uint256 tokenId ) public override  {
        revert(" Transfer is not allowed" );
    }

}