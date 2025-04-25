# Discussion 12 - Friday, April 25th

## Reminders

- Quiz 4 is next week **Friday, May 2nd** at the start of discussion.
    - Study resources are on course website!
- Project 6 due **Monday, April 28th @ 11:59 PM**
- Pass out stickers (if that didn't happen last week)

## Ownership and Borrowing
- [Rust Book chapter](https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html)

Ownership is one way that Rust is able to clear data without use of a garbage collector. It describes how a variable "owns" a piece of data on the heap, and once the owner goes out of scope, the data is dropped. 

Ownership can be transferred.

```rust
let x = String::from("hello"); // x owns hello

let y = x; // y takes ownership, x is now invalid.
```

But this is not always what we want! For example: 

```rust
fn main() {
    let x = String::from("some_string");
    let l = custom_len(x);
    
    println!("{} is {} letters long", x, l); // causes an error   
}

fn custom_len(str: String) -> usize {
    return str.len();
}
```

Will not compile! Ownership is given to the length function, and the string then goes out of scope. 

We can remedy this with borrowing:

```rust
fn main() {
    let x = String::from("some_string");
    let l = custom_len(&x);
    
    println!("{} is {} letters long", x, l); // no longer an error  
}

fn custom_len(str: &String) -> usize {
    return str.len();
}
```

Now, the len function borrows x, then returns ownership once it has completed. 


## Exercises

### Ownership/Borrowing
- From Rust quiz last semester:
![image](https://hackmd.io/_uploads/BkDyw7NGkx.png)

<details>
<summary>Solutions</summary>
    
    - b 
    - b
    - None
    - s
</details>

### General Debugging

Each of the functions in [`debug.rs`](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=4e4c4ae42395098a2aefabbcae925c08) has an error. Find the errors and fix them.

Solutions are in [`debug_solutions.rs`](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=f1712758d23e982589c3c13cc4f06535)!

### Traits, Enums, & Structures

Let's try to implement a simplified game of Pokemon: [`pokemon.rs`](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=e9ca91e067b217a0179225b7cdb2670a)

Take a couple of minutes to read through the code and understand the different traits, enums, and structures being used.

#### Instantiate Pokemon

Let's start by creating some Pokemon to play with. Here are some examples:

```txt
Squirtle (Water):
- 50/50 HP, Level 5
- Moves:
  - Tackle (Normal),   does 10 damage
  - Water Gun (Water), does 15 damage

Charmander (Fire):
- 60/60 HP, Level 6
- Moves:
  - Scratch (Normal),  does 10 damage
  - Ember (Fire),      does 15 damage

Bulbasaur (Grass):
- 40/40 HP, Level 4
- Moves:
  - Tackle (Normal),   does 10 damage
  - Vine Whip (Grass), does 15 damage
```


<details>
  <summary>Rust code for creating all of the above:</summary>

  ```rust
  let mut charmander = PokemonCharacter {
      name: String::from("Charmander"),
      level: 6,
      hp: 60,
      max_hp: 60,
      pokemon_type: PokemonType::Fire,
      moves: vec![
          PokemonMove {
              name: String::from("Scratch"),
              move_type: PokemonType::Normal,
              damage: 10,
          },
          PokemonMove {
              name: String::from("Ember"),
              move_type: PokemonType::Fire,
              damage: 15,
          },
      ],
  };

  let mut squirtle = PokemonCharacter {
      name: String::from("Squirtle"),
      level: 5,
      hp: 50,
      max_hp: 50,
      pokemon_type: PokemonType::Water,
      moves: vec![
          PokemonMove {
              name: String::from("Tackle"),
              move_type: PokemonType::Normal,
              damage: 10,
          },
          PokemonMove {
              name: String::from("Water Gun"),
              move_type: PokemonType::Water,
              damage: 15,
          },
      ],
  };

  let mut bulbasaur = PokemonCharacter {
      name: String::from("Bulbasaur"),
      level: 4,
      hp: 40,
      max_hp: 40,
      pokemon_type: PokemonType::Grass,
      moves: vec![
          PokemonMove {
              name: String::from("Tackle"),
              move_type: PokemonType::Normal,
              damage: 10,
          },
          PokemonMove {
              name: String::from("Vine Whip"),
              move_type: PokemonType::Grass,
              damage: 15,
          },
      ],
  };
  ```
</details>

#### Summary

I want to implement a `Summary` trait for my Pokemon so I can see their current health & level. I should be able to call it like so:

```rust
println!("{}", squirtle.summary());
println!("{}", charmander.summary());
```

<details>
  <summary>Example output:</summary>

  ```bash
  [Squirtle]: 93/100 HP, Level 10
  [Charmander]: 50/50 HP, Level 5
  ```
</details>

<br>

We can reimplement the same `Summary` trait for the moves to get a similar summary of their types and power:

```rust
for m in &charmander.moves {
    println!("{}", m.summary());
}

println!();

for m in &squirtle.moves {
    println!("{}", m.summary());
}
```

<details>
  <summary>Example output:</summary>

  ```bash
  [Scratch]: Type Normal, Power 10
  [Ember]: Type Fire, Power 15

  [Tackle]: Type Normal, Power 10
  [Water Gun]: Type Water, Power 15
  ```
</details>


#### Battle

Let's simulate a basic pokemon battle. Here's an example battle:

```rust
println!("{}", charmander.summary());
println!("{}", squirtle.summary());
println!();

charmander.attack(&mut squirtle);
squirtle.attack(&mut charmander);
println!();

println!("{}", charmander.summary());
println!("{}", squirtle.summary());
println!();

println!("Leveling up Squirtle, healing charmander...");
println!();

squirtle.level_up();
charmander.heal();

println!("{}", charmander.summary());
println!("{}", squirtle.summary());
println!();
```

<details>
  <summary>Example output:</summary>

  ```txt
  [Charmander]: 60/60 HP, Level 6
  [Squirtle]: 50/50 HP, Level 5

  Charmander used Scratch!
  Squirtle took 10 damage!
  Squirtle used Water Gun!
  It's super effective!
  Charmander took 30 damage!

  [Charmander]: 30/60 HP, Level 6
  [Squirtle]: 40/50 HP, Level 5

  Leveling up Squirtle, healing charmander...

  [Charmander]: 60/60 HP, Level 6
  [Squirtle]: 60/60 HP, Level 6
  ```

</details>

Solutions:
- [Pokemon Solution Rust-Playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=ffb39143782a0adeba2e8fc660f090af)
- [Pokemon Solution 2 Rust-Playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=8e760a0811f8a42b9d6b18e738d41e5c)

## Resources

- [Spring23 Discussion 11 - Rust](https://github.com/cmsc330-umd/spring23/tree/main/discussions/d11_rust)
- [Rust Playground](https://play.rust-lang.org/)
- [Rust Book](https://doc.rust-lang.org/book/)
- [Rust Book - Defining and Instantiating Structs](https://doc.rust-lang.org/book/ch05-01-defining-structs.html)
- [Rust Book - Defining an Enum](https://doc.rust-lang.org/book/ch06-01-defining-an-enum.html)
- [Rust Book - Traits](https://doc.rust-lang.org/book/ch10-02-traits.html)

