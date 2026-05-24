// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Marketplace {
    error InvalidMetadataURI();
    error InvalidPrice();
    error ProductNotFound();
    error ProductInactive();
    error WrongPaymentAmount();
    error SellerCannotBuyOwnProduct();
    error OrderNotFound();
    error OnlySeller();
    error OnlyBuyer();
    error InvalidOrderStatus();
    error NothingToWithdraw();
    error WithdrawFailed();

    enum OrderStatus {
        Paid,
        Shipped,
        Completed,
        Cancelled
    }

    struct Product {
        uint256 id;
        address payable seller;
        string metadataURI;
        uint256 price;
        bool active;
    }

    struct Order {
        uint256 id;
        uint256 productId;
        address buyer;
        address payable seller;
        uint256 amount;
        OrderStatus status;
    }

    uint256 public nextProductId = 1;
    uint256 public nextOrderId = 1;

    mapping(uint256 => Product) private products;
    mapping(uint256 => Order) private orders;
    mapping(address => uint256) public withdrawableBalance;

    event ProductCreated(uint256 indexed productId, address indexed seller, string metadataURI, uint256 price);
    event ProductPurchased(uint256 indexed orderId, uint256 indexed productId, address indexed buyer, uint256 amount);
    event OrderShipped(uint256 indexed orderId);
    event OrderCompleted(uint256 indexed orderId);
    event SellerWithdrawal(address indexed seller, uint256 amount);

    function createProduct(string calldata metadataURI, uint256 price) external returns (uint256 productId) {
        if (bytes(metadataURI).length == 0) revert InvalidMetadataURI();
        if (price == 0) revert InvalidPrice();

        productId = nextProductId++;
        products[productId] = Product({
            id: productId,
            seller: payable(msg.sender),
            metadataURI: metadataURI,
            price: price,
            active: true
        });

        emit ProductCreated(productId, msg.sender, metadataURI, price);
    }

    function buyProduct(uint256 productId) external payable returns (uint256 orderId) {
        Product storage product = products[productId];
        if (product.id == 0) revert ProductNotFound();
        if (!product.active) revert ProductInactive();
        if (msg.sender == product.seller) revert SellerCannotBuyOwnProduct();
        if (msg.value != product.price) revert WrongPaymentAmount();

        orderId = nextOrderId++;
        orders[orderId] = Order({
            id: orderId,
            productId: productId,
            buyer: msg.sender,
            seller: product.seller,
            amount: msg.value,
            status: OrderStatus.Paid
        });

        emit ProductPurchased(orderId, productId, msg.sender, msg.value);
    }

    function markShipped(uint256 orderId) external {
        Order storage order = orders[orderId];
        if (order.id == 0) revert OrderNotFound();
        if (msg.sender != order.seller) revert OnlySeller();
        if (order.status != OrderStatus.Paid) revert InvalidOrderStatus();

        order.status = OrderStatus.Shipped;
        emit OrderShipped(orderId);
    }

    function completeOrder(uint256 orderId) external {
        Order storage order = orders[orderId];
        if (order.id == 0) revert OrderNotFound();
        if (msg.sender != order.buyer) revert OnlyBuyer();
        if (order.status != OrderStatus.Shipped) revert InvalidOrderStatus();

        order.status = OrderStatus.Completed;
        withdrawableBalance[order.seller] += order.amount;
        emit OrderCompleted(orderId);
    }

    function withdraw() external {
        uint256 amount = withdrawableBalance[msg.sender];
        if (amount == 0) revert NothingToWithdraw();

        withdrawableBalance[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        if (!success) revert WithdrawFailed();

        emit SellerWithdrawal(msg.sender, amount);
    }

    function getProduct(uint256 productId) external view returns (Product memory product) {
        product = products[productId];
        if (product.id == 0) revert ProductNotFound();
    }

    function getOrder(uint256 orderId) external view returns (Order memory order) {
        order = orders[orderId];
        if (order.id == 0) revert OrderNotFound();
    }
}
