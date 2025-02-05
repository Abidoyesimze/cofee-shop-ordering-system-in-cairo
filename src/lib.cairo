#[derive(Drop, Debug)]
enum CofeeType {
    Capuccino,
    Latte,
    Mocha,
    Americano,
    Espresso,
    Macchiato
}

#[derive(Drop, Debug)]
enum CofeeSize{
    Small,
    Medium,
    Large
}

#[derive(Drop, Debug)]
enum CofeeAddition{
    Milk,
    Cream,
    Sugar,
    Cinnamon,
    Chocolate,
    Vanilla
}

#[derive(Drop, Debug)]
struct Stock {
    Capuccino: u32,
    Latte: u32,
    Mocha: u32,
    Americano: u32,
    Espresso: u32,
    Macchiato: u32,
    Milk: u32,
    Cream: u32,
    Sugar: u32,
    Cinnamon: u32,
    Chocolate: u32,
    Vanilla: u32
}

trait PriceTrait{
    fn calculate_price(self: @CofeeType, size: @CofeeSize) -> u32;
}

#[derive(Drop, Debug)]
struct Cofee{
    Type: CofeeType,
    Size: CofeeSize,
    Additions: CofeeAddition
}

impl CofeePriceImpl of PriceTrait{
    fn calculate_price(self: @CofeeType, size: @CofeeSize) -> u32{

        let base_price: u32 = match self {
            CofeeType:: Capuccino => 20,
            CofeeType:: Americano => 30,
            CofeeType:: Latte => 40,
            CofeeType:: Mocha => 40,
            CofeeType:: Espresso => 50,
            CofeeType:: Macchiato => 60,
        };
        let size_price: u32 = match size {
            CofeeSize:: Small => 20,
            CofeeSize:: Medium => 30,
            CofeeSize:: Large => 40
        };
        base_price + size_price
    }

   
}
trait StockTrait{
    fn check_stock(self: @CofeeType, stock: @Stock) -> bool{
        let beans = match self {
            CofeeType::Capuccino => stock.Capuccino,
            CofeeType::Latte => stock.Latte,
            CofeeType::Mocha => stock.Mocha,
            CofeeType::Americano => stock.Americano,
            CofeeType::Espresso => stock.Espresso,
            CofeeType::Macchiato => stock.Macchiato,
        };
        *beans > 0
        match self {
            CofeeType::Capuccino => stock.Capuccino -= 1,
       }

    }

   
    
}
