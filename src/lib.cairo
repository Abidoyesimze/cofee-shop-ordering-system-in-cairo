#[derive(Drop, Debug, Copy, Clone)]
enum CofeeType {
    Capuccino,
    Latte,
    Mocha,
    Americano,
    Espresso,
    Macchiato
}

#[derive(Drop, Debug)]
enum CofeeSize {
    Small,
    Medium,
    Large
}

#[derive(Drop, Debug)]
enum CofeeAddition {
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

#[derive(Drop, Debug)]
struct Cofee {
    Type: CofeeType,
    Size: CofeeSize,
    Addition: CofeeAddition  // Changed to singular
}

trait PriceTrait {
    fn calculate_price(self: @CofeeType, size: @CofeeSize) -> u32;
}

trait StockTrait {
    fn check_stock(self: @CofeeType, stock: @Stock) -> bool;
    fn reduce_stock(ref self: CofeeType, ref stock: Stock);
}

// Existing price implementation remains the same

impl StockTraitImpl of StockTrait {
    fn check_stock(self: @CofeeType, stock: @Stock) -> bool {
        match *self {
            CofeeType::Capuccino => *stock.Capuccino > 0,
            CofeeType::Latte => *stock.Latte > 0,
            CofeeType::Mocha => *stock.Mocha > 0,
            CofeeType::Americano => *stock.Americano > 0,
            CofeeType::Espresso => *stock.Espresso > 0,
            CofeeType::Macchiato => *stock.Macchiato > 0,
        }
    }

    fn reduce_stock(ref self: CofeeType, ref stock: Stock) {
        match self {
            CofeeType::Capuccino => stock.Capuccino -= 1,
            CofeeType::Latte => stock.Latte -= 1,
            CofeeType::Mocha => stock.Mocha -= 1,
            CofeeType::Americano => stock.Americano -= 1,
            CofeeType::Espresso => stock.Espresso -= 1,
            CofeeType::Macchiato => stock.Macchiato -= 1,
        }
    }
    
}
fn restock(ref self: Stock, amount: u32) {
    self.Capuccino += amount;
    self.Latte += amount;
    self.Mocha += amount;
    self.Americano += amount;
    self.Espresso += amount;
    self.Macchiato += amount;

    // Restock additions
    self.Milk += amount;
    self.Cream += amount;
    self.Sugar += amount;
    self.Cinnamon += amount;
    self.Chocolate += amount;
    self.Vanilla += amount;
}



#[derive(Drop, Debug)]
struct Order {
    Id: u32,
    Coffee: Cofee,
    TotalPrice: u32,
    Status: OrderStatus
}

#[derive(Drop, Debug)]
enum OrderStatus {
    Pending,
    Preparing,
    Ready,
    Completed,
    Cancelled
}

// Payment Trait
trait PaymentTrait {
    fn process_payment(order_price: u32, payment_amount: u32) -> bool;
}

trait OrderTrait {
    fn create_order(
        coffee_type: CofeeType, 
        size: CofeeSize, 
        addition: CofeeAddition, 
        ref stock: Stock
    ) -> Option<Order>;
    
    fn update_order_status(ref self: Order, new_status: OrderStatus);
    fn cancel_order(ref self: Order, ref stock: Stock);
}


impl OrderTraitImpl of OrderTrait {
    fn create_order(
        coffee_type: CofeeType, 
        size: CofeeSize, 
        addition: CofeeAddition, 
        ref stock: Stock
    ) -> Option<Order> {
        // Check coffee type stock
        if !StockTraitImpl::check_stock(@coffee_type, @stock) {
            return Option::None;
        }

        // Check addition stock
        let addition_check = match addition {
            CofeeAddition::Milk => stock.Milk > 0,
            CofeeAddition::Cream => stock.Cream > 0,
            CofeeAddition::Sugar => stock.Sugar > 0,
            CofeeAddition::Cinnamon => stock.Cinnamon > 0,
            CofeeAddition::Chocolate => stock.Chocolate > 0,
            CofeeAddition::Vanilla => stock.Vanilla > 0,
            CofeeAddition::None => true
        };

        if !addition_check {
            return Option::None;
        }

        // Reduce stock
        StockTraitImpl::reduce_stock(ref coffee_type, ref stock);

        // Reduce addition stock
        match addition {
            CofeeAddition::Milk => stock.Milk -= 1,
            CofeeAddition::Cream => stock.Cream -= 1,
            CofeeAddition::Sugar => stock.Sugar -= 1,
            CofeeAddition::Cinnamon => stock.Cinnamon -= 1,
            CofeeAddition::Chocolate => stock.Chocolate -= 1,
            CofeeAddition::Vanilla => stock.Vanilla -= 1,
            CofeeAddition::None => {}
        }

        // Calculate price
        let total_price = CofeePriceImpl::calculate_price(@coffee_type, @size, @addition);

        // Create order
        Option::Some(Order {
            Id: 1, // In a real system, this would be dynamically generated
            Coffee: Cofee {
                Type: coffee_type,
                Size: size,
                Addition: addition
            },
            TotalPrice: total_price,
            Status: OrderStatus::Pending
        })
    }

    fn update_order_status(ref self: Order, new_status: OrderStatus) {
        self.Status = new_status;
    }

    fn cancel_order(ref self: Order, ref stock: Stock) {
        // Restore stock for coffee type
        match self.Coffee.Type {
            CofeeType::Capuccino => stock.Capuccino += 1,
            CofeeType::Latte => stock.Latte += 1,
            CofeeType::Mocha => stock.Mocha += 1,
            CofeeType::Americano => stock.Americano += 1,
            CofeeType::Espresso => stock.Espresso += 1,
            CofeeType::Macchiato => stock.Macchiato += 1,
        }

        // Restore stock for addition
        match self.Coffee.Addition {
            CofeeAddition::Milk => stock.Milk += 1,
            CofeeAddition::Cream => stock.Cream += 1,
            CofeeAddition::Sugar => stock.Sugar += 1,
            CofeeAddition::Cinnamon => stock.Cinnamon += 1,
            CofeeAddition::Chocolate => stock.Chocolate += 1,
            CofeeAddition::Vanilla => stock.Vanilla += 1,
            CofeeAddition::None => {}
        }

        // Update order status
        self.Status = OrderStatus::Cancelled;
    }
}
