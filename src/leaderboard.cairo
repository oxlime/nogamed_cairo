%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import (
    Uint256, uint256_add)
from starkware.cairo.common.alloc import alloc

from lib.IERC721 import IERC721
from lib.IOgame import IOgame

@view
func get_owner_at_token{syscall_ptr : felt*, range_check_ptr}(
    contract_address : felt, id : Uint256
        ) -> (res : felt):

    let (res) = IERC721.ownerOf(
        contract_address=contract_address, tokenId=id
            )
    return (res)
end

@view
func get_owners_array{syscall_ptr : felt*, range_check_ptr}(contract_address : felt) -> (myList_len : felt, myList : felt*):
    alloc_locals
    let (local myList: felt*) = alloc()
    let one : Uint256 = Uint256(1, 0) 
    get_owner{myList=myList}(0, contract_address, one)
    return (200, myList)
end

func get_owner{syscall_ptr : felt*, range_check_ptr, myList : felt*}(i, contract_address : felt, id : Uint256):
    if i == 200:
        return()
    end

    let (owner) = IERC721.ownerOf(
        contract_address=contract_address, tokenId=id
    )
    assert myList[i] = owner
    let one : Uint256 = Uint256(1, 0) 
    let (newId : Uint256, is_overflow) = uint256_add(id, one)
    #assert (is_overflow) = 0
    return get_owner(i + 1, contract_address, id=newId)
end

@view
func get_points_array{syscall_ptr : felt*, range_check_ptr}(contract_address : felt) -> (pointList_len : felt, pointList : felt*):
    alloc_locals
    let (local pointList: felt*) = alloc()
    let one : Uint256 = Uint256(1, 0) 
    get_points{pointList=pointList}(0, contract_address, one)
    return (200, pointList)
end

func get_points{syscall_ptr : felt*, range_check_ptr, pointList : felt*}(i, contract_address : felt, id : Uint256):
    if i == 200:
        return()
    end

    let (owner) = IERC721.ownerOf(
        contract_address=contract_address, tokenId=id
    )
    let (points) = IOgame.player_points(
    contract_address=1505365600088388820431824311940060394708617414836564324735086295425001052239, your_address=owner
    )
    assert pointList[i] = points
    let one : Uint256 = Uint256(1, 0) 
    let (newId : Uint256, is_overflow) = uint256_add(id, one)
    #assert (is_overflow) = 0
    return get_points(i + 1, contract_address, id=newId)
end

