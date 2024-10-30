CREATE TABLE [Customer] (
  [cus_id] int PRIMARY KEY IDENTITY(1, 1),
  [email] nvarchar(255),
  [first_name] nvarchar(255),
  [last_name] nvarchar(255),
  [gender] char,
  [address] nvarchar(255),
  [birth_date] date,
  [phone] nvarchar(255),
  [user_type] enum(Buyer,Seller)
)
GO

CREATE TABLE [Item] (
  [item_id] int PRIMARY KEY IDENTITY(1, 1),
  [name] nvarchar(255),
  [description] text,
  [price] decimal,
  [status] enum(active,inactive),
  [category_id] int,
  [created_at] datetime,
  [updated_at] datetime
)
GO

CREATE TABLE [Category] (
  [category_id] int PRIMARY KEY IDENTITY(1, 1),
  [name] nvarchar(255),
  [path] nvarchar(255)
)
GO

CREATE TABLE [Order] (
  [order_id] int PRIMARY KEY IDENTITY(1, 1),
  [customer_id] int,
  [order_date] datetime,
  [total_amount] decimal
)
GO

CREATE TABLE [OrderItem] (
  [order_id] int,
  [item_id] int,
  [quantity] int,
  [item_price] decimal
)
GO

ALTER TABLE [OrderItem] ADD FOREIGN KEY ([order_id]) REFERENCES [Order] ([order_id])
GO

ALTER TABLE [OrderItem] ADD FOREIGN KEY ([item_id]) REFERENCES [Item] ([item_id])
GO

ALTER TABLE [Customer] ADD FOREIGN KEY ([cus_id]) REFERENCES [Order] ([customer_id])
GO

ALTER TABLE [Category] ADD FOREIGN KEY ([category_id]) REFERENCES [Item] ([category_id])
GO
