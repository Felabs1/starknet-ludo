// struct player
// struct game
// struct reward
use core::option::OptionTrait;
use core::array::ArrayTrait;
use starknet::get_caller_address;
use starknet::ContractAddress;

#[derive(Copy, Drop, Serde, starknet::Store)]
struct Player{
    id: ContractAddress,
    username: felt252,
    games_played: u256,
    rewards_count: u256,
}

#[derive(Copy, Drop, Serde, starknet::Store)]
struct Game {
    id: u256,
    player1: Option<ContractAddress>,
    player2: Option<ContractAddress>,
    player3: Option<ContractAddress>,
    player4: Option<ContractAddress>,
    owner: ContractAddress,
    has_started: bool,
    reward_amt: u256,
    has_ended: bool,
}

#[derive(Copy, Drop, Serde, starknet::Store)]
struct Reward {
    winner: ContractAddress,
    amount: u256,
    game: u256,
}

#[derive(Copy, Drop, Serde, starknet::Store)]
struct GameReward {
    reward: Reward,
    game: Game
}


#[starknet::interface]
trait IStarkDice<TContractState> {
    fn register_player(ref self:TContractState, username: felt252);
    fn create_game(ref self: TContractState, reward_amt: u256);
    fn join_game(ref self: TContractState, game_id: u256);
    fn lock_reward(ref self: TContractState, game_id: u256);
    fn start_game(ref self: TContractState, game_id: u256);
    fn finish_game(ref self: TContractState, game_id: u256, winner: ContractAddress);
    fn get_game_player(self: @TContractState, game_id: u256, me: ContractAddress)->u32;
    fn is_there_a_player(self: @TContractState, player: Option<ContractAddress>) -> bool;
}


#[starknet::interface]
trait IHelperDice<TContractState>{
    fn get_games(self: @TContractState)->Array<Game>;
    fn get_game(self: @TContractState, game_id: u256) -> Game;
    fn get_player_rewards(self: @TContractState, player_id: ContractAddress)->Array<GameReward>;
    fn get_player_games(self: @TContractState, player_id: ContractAddress)->Array<Game>;
}
#[starknet::contract]
mod StarkDice {
// use starknet::ContractAddress;
// use core::Option::;
// use core::Array::*;
// use starknet::get_caller_address;
// use starknet::ContractAddress;

use super::{OptionTrait, ArrayTrait, Player, Game, Reward, GameReward, get_caller_address, ContractAddress};
    #[storage]
    struct Storage {
        players_count: u256,
        games_count: u256,
        games: LegacyMap<u256, Game>,
        players: LegacyMap<u256, Player>,
        rewards: LegacyMap<u256, Reward>,
        players_games: LegacyMap<(ContractAddress, u256), u256>,
        players_rewards: LegacyMap<(ContractAddress, u256), u256>,
        locked_amounts: LegacyMap<(u256, u32), u256>,
    }



    // #[derive(Copy, Drop, Serde, Hash]
    // struct player {
    //     playerId: ContractAddress;
    //     name: felt252;
    //     amount: u256;
    // }

    // 0x2964055388b946b47b1b6c16c5abbecee9d6e661bb61b3377c005321baced55

    #[external(v0)]
    impl IStarkDiceImpl of super::IStarkDice<ContractState> {
        fn register_player(ref self: ContractState, username: felt252){
            let player_id: ContractAddress = get_caller_address();
            let player: Player = Player {
                id: player_id,
                username: username,
                games_played: 0,
                rewards_count: 0,
            };
            self.players_count.write(self.players_count.read() + 1);
            self.players.write(self.players_count.read(), player);
        }

        fn create_game(ref self: ContractState, reward_amt: u256){
            let game_id = self.games_count.read() + 1;
            let owner = get_caller_address();
            let game = Game {
                id: game_id,
                player1:Option::Some(owner),
                player2:Option::None,
                player3:Option::None,
                player4:Option::None,
                owner,
                has_started: false,
                reward_amt,
                has_ended: false
            };
            self.games.write(game_id, game);
            self.games_count.write(game_id);
        }

         fn is_there_a_player(self: @ContractState, player: Option<ContractAddress>) -> bool{
            match player {
                Option::Some(x) => true, 
                Option::None => false
            }
         }

        fn join_game(ref self: ContractState, game_id: u256){
            let player = get_caller_address();
            let mut game = self.games.read(game_id);
            if self.is_there_a_player(game.player2){
                game.player2 = Option::Some(player);
            }else if self.is_there_a_player(game.player3){
                game.player3 = Option::Some(player);
            }else if self.is_there_a_player(game.player4){
                game.player4 = Option::Some(player);
            }

            self.games.write(game_id, game);
        }



        fn get_game_player(self: @ContractState, game_id: u256, me: ContractAddress) -> u32 {
            let game = self.games.read(game_id);
            if Option::Some(game.player1) == me {
                player_number = 1;
            }else if Option::Some(game.player2) == me {
                player_number = 2;
            }
            }else if Option::Some(game.player3)  == me {
                player_number = 3;
            }else if Option::Some(game.player4)  == me {
                player_number = 4;
            }

            player_number
        }

        fn lock_reward(ref self: ContractState, game_id: u256){
            let mut game = self.games.read(game_id);
            let me = get_caller_address();

            let player_number = self.get_game_player(game_id,me);
            if player_number != 0 {
                self.locked_amounts.write((game_id, player_number), game.reward_amt);
            }

        }

        fn start_game(ref self: ContractState, game_id: u256){
            let mut game = self.games.read(game_id);
            game.has_started = true;
            self.games.write(game_id, game);
        }


        fn finish_game(ref self: ContractState, game_id: u256, winner: ContractAddress){
        let mut game = self.games.read(game_id);
            game.has_ended = true;

            // to do: send the winner some amount

            self.games.write(game_id, game);
        }

       
    }
}
