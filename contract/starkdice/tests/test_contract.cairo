use starkdice::IHelperDiceDispatcherTrait;
use starkdice::IStarkDiceDispatcherTrait;
use core::array::ArrayTrait;
use core::traits::Into;
use core::debug::PrintTrait;
use core::option::OptionTrait;
use core::traits::TryInto;
use starkdice::{IHelperDiceDispatcher, IStarkDiceDispatcher};
// use cycle_stark::interfaces::{
//     ICycleStarkDispatcherTrait, ICycleStarkDispatcher, IHelperFunctionsDispatcher
// };
use snforge_std::{declare, ContractClassTrait, start_prank, stop_prank};
use starknet::testing::{set_caller_address};
use starknet::{contract_address_const, ContractAddress};
// use cycle_stark::erc20::{IERC20Dispatcher, IERC20DispatcherTrait};

fn deploy() -> (IStarkDiceDispatcher,IHelperDiceDispatcher, ContractAddress) {
    // Declare and deploy a contract
    let contract = declare('StarkDice');
    let contract_address = contract.deploy(@ArrayTrait::new()).unwrap();

    // Create a Dispatcher object for interaction with the deployed contract
    let main_dispatcher = IStarkDiceDispatcher { contract_address };
    let helper_dispatcher = IHelperDiceDispatcher { contract_address };

    (main_dispatcher,helper_dispatcher, contract_address)
}

#[test]
fn register_hero() {
    let (main_dispatcher,helper_dispatcher, contract_address) = deploy();
    main_dispatcher.register_player('felabs');
    assert(helper_dispatcher.get_players_count() == 1, 'some error occured');

}