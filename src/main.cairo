%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import (
    Uint256, uint256_add, split_64)
from starkware.cairo.common.alloc import alloc

@contract_interface
namespace IERC721:
    func balanceOf(owner : felt) -> (balance : Uint256):
    end

    func ownerOf(tokenId : Uint256) -> (owner : felt):
    end

    func safeTransferFrom(
        from_ : felt, to : felt, tokenId : Uint256, data_len : felt, data : felt*
    ):
    end

    func transferFrom(from_ : felt, to : felt, tokenId : Uint256):
    end

    func approve(approved : felt, tokenId : Uint256):
    end

    func setApprovalForAll(operator : felt, approved : felt):
    end

    func getApproved(tokenId : Uint256) -> (approved : felt):
    end

    func isApprovedForAll(owner : felt, operator : felt) -> (isApproved : felt):
    end

    func mint(to : felt, token_id : Uint256):
    end

    func ownerToPlanet(owner : felt) -> (tokenId : Uint256):
    end
end

@view
func get_all_owners{syscall_ptr : felt*, range_check_ptr}(
    contract_address : felt, arr_len : felt, arr : felt*, size : Uint256 
) -> (res_len : felt, res : felt* ):
    if arr_len == 200:
        return (arr_len, arr)
    end

    let (own) = IERC721.ownerOf(
        contract_address=contract_address, tokenId=size
    )
    assert [arr] = own
    let one : Uint256 = Uint256(1, 0) 
    let (newSize : Uint256, is_overflow) = uint256_add(size, one)
    get_all_owners(contract_address=contract_address,arr_len=arr_len+1, arr=arr + 1, size=newSize)
    return (arr_len, arr)
end

@view
func get_owner_at_token{syscall_ptr : felt*, range_check_ptr}(
    contract_address : felt, id : Uint256
        ) -> (res : felt):

    let (res) = IERC721.ownerOf(
        contract_address=contract_address, tokenId=id
            )
    return (res)
end

# this works in cairo playground 
func main{output_ptr}():
    alloc_locals
    local stop = 10
    local coef = 10
    let (local myList: felt*) = alloc()
    let start = 0
    body{coef=coef, myList=myList, stop=stop}(start)
    return()
end

func body{coef, myList : felt*, stop}(i):
    if i == stop:
        return ()
    end

    let x = i * coef + 1
#    %{ print(ids.i) %}
    assert myList[i] = x
    return body(i + 1)
end

@view
func get_owners_array{syscall_ptr : felt*, range_check_ptr}(contract_address : felt, id : Uint256) -> (myList_len : felt, myList : felt*):
    alloc_locals
    let (local myList: felt*) = alloc()
    get_owner{myList=myList}(0, contract_address, id)
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
func test_add{syscall_ptr : felt*, range_check_ptr}(num : Uint256) -> (res : Uint256): 
    let one : Uint256 = Uint256(1, 0) 
    let (res : Uint256, is_overflow) = uint256_add(num, one)
    assert (is_overflow) = 0
    return (res) 
end
